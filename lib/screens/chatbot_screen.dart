import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../api_service.dart';

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  List<_ChatMessage> _messages = [
    _ChatMessage(isBot: true, text: "Hey! TappyAI here! How can I help you?"),
  ];
  Map<String, dynamic>? _aiContext;
  bool _loading = false;
  bool _initializing = true;

  @override
  void initState() {
    super.initState();
    _initializeContext();
  }

  Future<void> _initializeContext() async {
    setState(() {
      _initializing = true;
    });
    final context = await ApiService.fetchAiContext();
    setState(() {
      _aiContext = context;
      _messages = [
        _ChatMessage(isBot: true, text: "Hey! TappyAI here! How can I help you?")
      ];
      _initializing = false;
    });
  }

  List<Map<String, String>> _toChatHistory() {
    // Convert to Fireworks chat format
    return _messages.map((m) => {
      "role": m.isBot ? "tappyai" : "user",
      "content": m.text,
    }).toList();
  }

  Future<void> _sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty || _aiContext == null || _loading) return;
    setState(() {
      _messages.add(_ChatMessage(isBot: false, text: text));
      _loading = true;
      _controller.clear();
    });
    Future.delayed(const Duration(milliseconds: 100), () {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
    try {
      final reply = await ApiService.sendToFireworksAI(
        aiContext: _aiContext!,
        chatHistory: _toChatHistory(),
      );
      setState(() {
        _messages.add(_ChatMessage(isBot: true, text: reply ?? 'Sorry, I could not understand that.'));
        _loading = false;
      });
      Future.delayed(const Duration(milliseconds: 100), () {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    } catch (e) {
      setState(() {
        _messages.add(_ChatMessage(isBot: true, text: 'Sorry, there was an error.'));
        _loading = false;
      });
    }
  }

  void _newChat() async {
    _controller.clear();
    await _initializeContext();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7FD),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('[Beta] TappyAI ChatBot', style: GoogleFonts.poppins(
          fontWeight: FontWeight.bold,
          color: const Color(0xFF5D5A88),
        )),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Color(0xFFB2A4FF)),
            tooltip: 'New Chat',
            onPressed: _loading || _initializing ? null : _newChat,
          ),
        ],
      ),
      body: Stack(
        children: [
          // Top purple background cloud
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Image.asset(
              'assets/images/Group 29.png',
              fit: BoxFit.fitWidth,
              width: double.infinity,
            ),
          ),
          // Bottom purple cloud
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Image.asset(
              'assets/images/Group 28.png',
              fit: BoxFit.fitWidth,
              width: double.infinity,
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.android, color: Color(0xFFB2A4FF), size: 32),
                      const SizedBox(width: 12),
                      Text(
                        '[Beta] TappyAI\nChatBot',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF5D5A88),
                          fontSize: 22,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                Expanded(
                  child: _initializing
                      ? const Center(child: CircularProgressIndicator())
                      : ListView.builder(
                          controller: _scrollController,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 18, vertical: 10),
                          itemCount: _messages.length + (_loading ? 1 : 0),
                          itemBuilder: (context, idx) {
                            if (_loading && idx == _messages.length) {
                              // Show bot typing indicator
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 7.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(right: 8.0),
                                      child: CircleAvatar(
                                        backgroundColor: const Color(0xFFE4E1F7),
                                        radius: 24,
                                        child: Icon(Icons.android,
                                            color: Color(0xFFB2A4FF), size: 30),
                                      ),
                                    ),
                                    Flexible(
                                      child: Container(
                                        decoration: const BoxDecoration(
                                          color: Color(0xFF232234),
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(18),
                                            topRight: Radius.circular(18),
                                            bottomRight: Radius.circular(18),
                                          ),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 18, vertical: 14),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            SizedBox(
                                              width: 18,
                                              height: 18,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2.5,
                                                color: Colors.white,
                                              ),
                                            ),
                                            const SizedBox(width: 12),
                                            Text(
                                              'TappyAI is thinking...',
                                              style: GoogleFonts.poppins(
                                                color: Colors.white,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }
                            final msg = _messages[idx];
                            final isBot = msg.isBot;
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 7.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: isBot
                                    ? MainAxisAlignment.start
                                    : MainAxisAlignment.end,
                                children: [
                                  if (isBot)
                                    Padding(
                                      padding: const EdgeInsets.only(right: 8.0),
                                      child: CircleAvatar(
                                        backgroundColor: const Color(0xFFE4E1F7),
                                        radius: 24,
                                        child: Icon(Icons.android,
                                            color: Color(0xFFB2A4FF), size: 30),
                                      ),
                                    ),
                                  Flexible(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: isBot
                                            ? const Color(0xFF232234)
                                            : const Color(0xFF5D5A88),
                                        borderRadius: BorderRadius.only(
                                          topLeft: const Radius.circular(18),
                                          topRight: const Radius.circular(18),
                                          bottomLeft: Radius.circular(isBot ? 0 : 18),
                                          bottomRight:
                                              Radius.circular(isBot ? 18 : 0),
                                        ),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 18, vertical: 14),
                                      child: Text(
                                        msg.text,
                                        style: GoogleFonts.poppins(
                                          color: Colors.white,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w400,
                                        ),
                                        textAlign: TextAlign.left,
                                      ),
                                    ),
                                  ),
                                  if (!isBot)
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(left: 8.0, top: 8),
                                      child: CircleAvatar(
                                        backgroundColor: const Color(0xFFE4E1F7),
                                        radius: 18,
                                        child: Icon(Icons.person,
                                            color: Color(0xFF5D5A88), size: 22),
                                      ),
                                    ),
                                ],
                              ),
                            );
                          },
                        ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 18, right: 18, bottom: 30, top: 10),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFFE4E1F7),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: TextField(
                            controller: _controller,
                            style: GoogleFonts.poppins(fontSize: 16),
                            decoration: InputDecoration(
                              hintText: 'Type your message...',
                              hintStyle: GoogleFonts.poppins(
                                  color: Colors.grey[600], fontSize: 16),
                              border: OutlineInputBorder(
                                // Use OutlineInputBorder for a visible border
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                              enabledBorder: OutlineInputBorder(
                                // Border when enabled (not focused)
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide
                                    .none, // No visible border line, relies on container's background
                              ),
                              focusedBorder: OutlineInputBorder(
                                // Border when focused
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 18, vertical: 14),
                            ),
                            onSubmitted: (_) => _sendMessage(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      GestureDetector(
                        onTap: _loading || _initializing ? null : _sendMessage,
                        child: Container(
                          decoration: BoxDecoration(
                            color: (_loading || _initializing)
                                ? const Color(0xFFB2A4FF).withOpacity(0.5)
                                : const Color(0xFFB2A4FF),
                            shape: BoxShape.circle,
                          ),
                          padding: const EdgeInsets.all(14),
                          child: const Icon(Icons.send, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
                // Bottom navigation bar (mock, not functional)
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _NavIcon(icon: Icons.menu_book),
                      const SizedBox(width: 18),
                      _NavIcon(icon: Icons.style),
                      const SizedBox(width: 18),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.10),
                          shape: BoxShape.circle,
                        ),
                        padding: const EdgeInsets.all(10),
                        child: const Icon(Icons.android,
                            size: 32, color: Color(0xFF5D5A88)),
                      ),
                      const SizedBox(width: 18),
                      _NavIcon(icon: Icons.access_time),
                      const SizedBox(width: 18),
                      _NavIcon(icon: Icons.dashboard),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ChatMessage {
  final bool isBot;
  final String text;
  _ChatMessage({required this.isBot, required this.text});
}

class _NavIcon extends StatelessWidget {
  final IconData icon;
  const _NavIcon({required this.icon});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
          ),
        ],
      ),
      padding: const EdgeInsets.all(12),
      child: Icon(icon, color: Color(0xFFB2A4FF), size: 28),
    );
  }
}
