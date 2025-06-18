import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'models/storybook.dart';
import 'models/activity.dart';
import 'models/daily_task_today.dart';

class HomePageData {
  final Map<String, dynamic> user;
  final Storybook? storybookOfTheDay;
  final Storybook? newestStorybook;
  final Storybook? mostViewedStorybook;
  final List<Storybook> recommendedStorybooks;
  final List<Storybook> recentStorybooks;
  final Map<String, List<Storybook>> filteredStorybooksByGenre;

  HomePageData({
    required this.user,
    required this.storybookOfTheDay,
    required this.newestStorybook,
    required this.mostViewedStorybook,
    required this.recommendedStorybooks,
    required this.recentStorybooks,
    required this.filteredStorybooksByGenre,
  });

  factory HomePageData.fromJson(Map<String, dynamic> json) {
    Map<String, List<Storybook>> filtered = {};
    if (json['filtered_storybooks'] != null) {
      (json['filtered_storybooks'] as Map<String, dynamic>)
          .forEach((genre, list) {
        filtered[genre] = (list as List)
            .map((sb) => Storybook.fromJson(sb as Map<String, dynamic>))
            .toList();
      });
    }
    return HomePageData(
      user: json['user'] ?? {},
      storybookOfTheDay: json['storybook_of_the_day'] != null
          ? Storybook.fromJson(json['storybook_of_the_day'])
          : null,
      newestStorybook: json['newest_storybook'] != null
          ? Storybook.fromJson(json['newest_storybook'])
          : null,
      mostViewedStorybook: json['most_viewed_storybook'] != null
          ? Storybook.fromJson(json['most_viewed_storybook'])
          : null,
      recommendedStorybooks: (json['recommended_storybooks'] as List?)
              ?.map((sb) => Storybook.fromJson(sb))
              .toList() ??
          [],
      recentStorybooks: (json['recent_storybooks'] as List?)
              ?.map((sb) => Storybook.fromJson(sb))
              .toList() ??
          [],
      filteredStorybooksByGenre: filtered,
    );
  }
}

class ApiService {
  // Fetches the AI context from the backend (requires Bearer token)
  static Future<Map<String, dynamic>?> fetchAiContext() async {
    final token = await getToken();
    final url = Uri.parse('http://10.0.2.2:8000/api/v1/ai-context');
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      return json.decode(response.body) as Map<String, dynamic>;
    }
    return null;
  }

  /// Sends chat history and system prompt to Fireworks AI, returns only the reply string.
  /// [chatHistory] should be a list of maps: {"role": "user"|"tappyai", "content": "..."}
  static Future<String?> sendToFireworksAI({
    required Map<String, dynamic> aiContext,
    required List<Map<String, String>> chatHistory,
  }) async {
    final apiKey = 'fw_3ZKRcdUjGQN8ea8kyb8DMZzd';
    if (apiKey.isEmpty) {
      throw Exception('Fireworks API key not found in .env');
    }
    final url =
        Uri.parse('https://api.fireworks.ai/inference/v1/chat/completions');
    // System prompt per your requirements
    final systemPrompt =
        '''You are TappyAI, an expert children's education assistant for a storybook app.
You must always follow these rules:

1. All your responses must be valid JSON, and nothing else. No explanations, no markdown, no extra text.
2. Your JSON response must always have this structure:
   {
     "role": "tappyai",
     "reply": "<your answer here>"
   }
3. You must always use a friendly, supportive, and playful style appropriate for young children and their parents. Your tone should be positive, encouraging, and helpful.
4. If you understand these instructions and the context below, respond ONLY with "..." (as a plain string, not JSON).
5. For the first user message after receiving these rules, always reply with:
   {
     "role": "tappyai",
     "reply": "Hey! TappyAI here! How can I help you?"
   }

Here is the user's data and context:
${jsonEncode(aiContext)}

When the user asks a question, use the data above and your expertise in children's education to answer as TappyAI, always in the required JSON format and style.''';

    // Build Fireworks AI messages array
    final List<Map<String, String>> messages = [
      {"role": "system", "content": systemPrompt},
      ...chatHistory
    ];

    final body = jsonEncode({
      "model": "accounts/fireworks/models/llama4-maverick-instruct-basic",
      "messages": messages,
      "max_tokens": 131072,
      "top_p": 1,
      "top_k": 40,
      "presence_penalty": 0,
      "frequency_penalty": 0,
      "temperature": 0.6,
    });

    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: body,
    );
    print('FIREWORKS STATUS: ' + response.statusCode.toString());
    print('FIREWORKS BODY: ' + response.body);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      // Fireworks returns choices[0].message.content, which should be JSON
      final String? content = data['choices']?[0]?['message']?['content'];
      // ignore: avoid_print
      // Use a logging framework in production, e.g., logger
      print('FIREWORKS RAW CONTENT: ${content ?? 'null'}');
      if (content != null && content.trim().startsWith('{')) {
        try {
          final parsed = json.decode(content);
          return parsed['reply'] as String?;
        } catch (e) {
          return null;
        }
      }
      // If the bot returns just "..." for the rules, handle that as well
      if (content != null && content.trim() == '...') {
        return 'Hey! TappyAI here! How can I help you?';
      }
    }
    return null;
  }

  // Log storybook read with rating and comments
  static Future<bool> logStorybookRead(
      {required int idStorybook, int rating = 1, String? comments}) async {
    final url = Uri.parse('http://10.0.2.2:8000/api/v1/storybook-reads');
    final Map<String, dynamic> body = {
      'id_storybook': idStorybook,
      'rating': rating,
    };
    if (comments != null && comments.trim().isNotEmpty) {
      body['comments'] = comments.trim();
    }
    final token = await getToken();
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
      body: jsonEncode(body),
    );
    return response.statusCode == 200 || response.statusCode == 201;
  }

  // Fetch raw JSON for storybook content screen
  static Future<Map<String, dynamic>?> fetchStorybookRawById(
      int storybookId) async {
    final url = Uri.parse('http://10.0.2.2:8000/api/v1/storybook/$storybookId');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      return json.decode(response.body) as Map<String, dynamic>;
    } else {
      return null;
    }
  }

  /// Fetch today's daily task analytics
  static Future<DailyTaskToday?> fetchDailyTaskToday() async {
    final token = await getToken();
    final url = Uri.parse('http://10.0.2.2:8000/api/v1/daily-tasks/today/full');
    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        // The API returns { "daily_tasks": [ ... ] } so extract the first element
        if (jsonData['daily_tasks'] != null &&
            (jsonData['daily_tasks'] as List).isNotEmpty) {
          return DailyTaskToday.fromJson(jsonData['daily_tasks'][0]);
        }
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  static Future<Storybook?> fetchStorybookById(int id) async {
    final token = await getToken();
    final url = Uri.parse('$baseUrl/storybook/$id');
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      if (jsonData['data'] != null) {
        return Storybook.fromJson(jsonData['data']);
      }
    }
    return null;
  }

  static Future<bool> completeDailyTask(int activityId,
      {required int understanding,
      required int participation,
      required String notes}) async {
    final token = await getToken();
    final url = Uri.parse('$baseUrl/daily-tasks/$activityId/complete');
    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'understanding': understanding,
        'participation': participation,
        'notes': notes,
      }),
    );
    return response.statusCode == 200;
  }

  /// Fetch all activities from the API
  static Future<List<Activity>> fetchAllActivities() async {
    final url = Uri.parse('$baseUrl/activities');
    try {
      final response =
          await http.get(url, headers: {'Accept': 'application/json'});
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Activity.fromJson(json)).toList();
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  /// Fetch a random activity (as a list with one element) from the API
  static Future<Activity?> fetchRandomActivity() async {
    final url = Uri.parse('$baseUrl/activities/random');
    try {
      final response =
          await http.get(url, headers: {'Accept': 'application/json'});
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        if (data.isNotEmpty) {
          return Activity.fromJson(data.first);
        }
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  // Fetch home page data
  static Future<HomePageData?> fetchHomePage(String token) async {
    final url =
        Uri.parse(' baseUrl/home'.replaceFirst('\u0000baseUrl', baseUrl));
    try {
      final response = await http.get(
        url,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return HomePageData.fromJson(data);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  static const _storage = FlutterSecureStorage();
  static const _tokenKey = 'auth_token';

  static Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  static Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }

  // Use 10.0.2.2 for Android emulator, change to your LAN IP if using a real device
  static const String baseUrl = 'http://10.0.2.2:8000/api/v1';

  // Login
  static Future<Map<String, dynamic>> login(
      String email, String password) async {
    final url = Uri.parse('$baseUrl/login');
    try {
      final response = await http.post(
        url,
        headers: {
          'Accept': 'application/json',
        },
        body: {
          'email': email,
          'password': password,
        },
      );
      final data = json.decode(response.body);
      if (response.statusCode == 200 && data['token'] != null) {
        return {'success': true, 'token': data['token'], 'user': data['user']};
      } else {
        return {'success': false, 'message': data['message'] ?? 'Login failed'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error: $e'};
    }
  }

  // Register
  static Future<Map<String, dynamic>> register(String username, String email,
      String password, String confirmPassword) async {
    final url = Uri.parse('$baseUrl/register');
    try {
      final response = await http.post(
        url,
        headers: {
          'Accept': 'application/json',
        },
        body: {
          'name': username,
          'username': username,
          'email': email,
          'password': password,
          'password_confirmation': confirmPassword,
        },
      );
      final data = json.decode(response.body);
      if (response.statusCode == 201 && data['token'] != null) {
        return {'success': true, 'token': data['token'], 'user': data['user']};
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Registration failed'
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error: $e'};
    }
  }
}
