import 'package:flutter/material.dart';
import 'package:iofest/widgets/custom_bottom_nav_bar.dart';

import '../api_service.dart';
import '../shared/theme.dart' as app_theme;
import 'package:google_fonts/google_fonts.dart';

class StorybookContentScreen extends StatefulWidget {
  final int storybookId;
  const StorybookContentScreen({Key? key, required this.storybookId})
      : super(key: key);

  @override
  State<StorybookContentScreen> createState() => _StorybookContentScreenState();
}

class _StorybookContentScreenState extends State<StorybookContentScreen> {
  late Future<Map<String, dynamic>?> _storybookFuture;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _storybookFuture = ApiService.fetchStorybookRawById(widget.storybookId);
  }

  void _goToPage(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: app_theme.kWhiteColor,
      body: FutureBuilder<Map<String, dynamic>?>(
        future: _storybookFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('Failed to load storybook'));
          }
          final data = snapshot.data!['data'];
          final List pages = data['pages'] ?? [];
          if (pages.isEmpty) {
            return const Center(child: Text('No pages available'));
          }
          final page = pages[_currentPage];
          final List panels = page['panels'] ?? [];

          return SafeArea(
            child: Stack(
              children: [
                Positioned(
                  top: 0,
                  right: 0,
                  child: Image.asset(
                    'assets/images/Group 29.png',
                    width: MediaQuery.of(context).size.width,
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  child: Image.asset(
                    'assets/images/Group 28.png',
                    width: MediaQuery.of(context).size.width,
                  ),
                ),
                // Content panels (smaller, with space for bottom nav)
                Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 20, bottom: 80), // enough space for nav bar
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ...panels.map<Widget>((panel) {
                            final panelContent =
                                (panel['panel_contents'] as List).isNotEmpty
                                    ? panel['panel_contents'][0]
                                    : null;
                            if (panelContent == null)
                              return const SizedBox.shrink();
                            // Dynamic height logic
                            double panelHeight;
                            if (panels.length == 1) {
                              panelHeight = 600;
                            } else if (panels.length == 2) {
                              panelHeight = 300;
                            } else {
                              panelHeight = 200;
                            }
                            return _buildPanel(panelContent,
                                height: panelHeight);
                          }).toList(),
                        ],
                      ),
                    ),
                  ),
                ),
                // Top navigation row (back, prev, next)
                Positioned(
                  top: 16,
                  child: Row(
                    children: [
                      _buildHeader(context),
                    ],
                  ),
                ),
                Positioned(
                  top: 16,
                  left: 20,
                  right: 20,
                  bottom: 120,
                  child: Row(
                    mainAxisAlignment: _currentPage == 0
                        ? MainAxisAlignment.end
                        : MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Previous button
                      if (_currentPage > 0)
                        _navButton(Icons.arrow_back_ios_new,
                            () => _goToPage(_currentPage - 1)),
                      // Next button
                      if (_currentPage < pages.length - 1)
                        _navButton(Icons.arrow_forward_ios,
                            () => _goToPage(_currentPage + 1)),
                    ],
                  ),
                ),
                // Custom bottom nav bar
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: CustomBottomNavBar(
                    currentIndex: 2, // or your preferred index
                    onTap: (index) {
                      // handle nav bar tap if needed
                    },
                  ),
                ),
                // Finish Reading button (only on last page)
                if (_currentPage == pages.length - 1)
                  Positioned(
                    bottom: 100,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFECECFA),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24)),
                          elevation: 4,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 32, vertical: 14),
                        ),
                        onPressed: () {
                          showDialog(
                            context: context,
                            barrierDismissible: true,
                            builder: (context) =>
                                _buildFinishDialog(context, widget.storybookId),
                          );
                        },
                        child: Text(
                          'Finish Reading',
                          style: GoogleFonts.poppins(
                            color: Colors.black87,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 32),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            decoration: const BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Color(0x3F000000),
                  blurRadius: 8,
                  offset: Offset(0, 4),
                  spreadRadius: 0,
                )
              ],
            ),
            child: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: app_theme.kPrimaryLightColor,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Image.asset('assets/images/back arrow.png',
                    width: 24, height: 24),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _navButton(IconData icon, VoidCallback onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 60,
        height: 60,
        decoration: const BoxDecoration(
          color: Colors.black54,
          shape: BoxShape.circle,
        ),
        padding: const EdgeInsets.all(8),
        child: Icon(icon, color: app_theme.kWhiteColor, size: 22),
      ),
    );
  }

  Widget _buildPanel(Map<String, dynamic> content, {double height = 150}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Stack(
          children: [
            SizedBox(
              height: height,
              width: 320,
              child: Image.network(
                content['image'] ?? '',
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: Colors.grey[200],
                  child: const Icon(Icons.broken_image, size: 48),
                ),
              ),
            ),
            // Gradient overlay
            Container(
              height: height,
              width: 320,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Color.fromRGBO(0, 0, 0, .8),
                    Color.fromRGBO(0, 0, 0, .4),
                  ],
                ),
              ),
            ),
            // Text overlays
            Positioned.fill(
              child: Padding(
                padding: const EdgeInsets.all(14.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (content['top_text'] != null)
                      Align(
                        alignment: _parseAlign(content['top_text_align']),
                        child: Text(
                          content['top_text'] ?? '',
                          textAlign: _parseTextAlign(content['top_text_align']),
                          style: GoogleFonts.poppins(
                            color: app_theme.kWhiteColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            shadows: [
                              Shadow(
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 4,
                              ),
                            ],
                          ),
                        ),
                      ),
                    const Spacer(),
                    if (content['middle_text'] != null)
                      Align(
                        alignment: _parseAlign(content['middle_text_align']),
                        child: Text(
                          content['middle_text'] ?? '',
                          textAlign:
                              _parseTextAlign(content['middle_text_align']),
                          style: GoogleFonts.poppins(
                            color: app_theme.kWhiteColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            shadows: [
                              Shadow(
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 4,
                              ),
                            ],
                          ),
                        ),
                      ),
                    if (content['bottom_text'] != null)
                      Align(
                        alignment: _parseAlign(content['bottom_text_align']),
                        child: Text(
                          content['bottom_text'] ?? '',
                          textAlign:
                              _parseTextAlign(content['bottom_text_align']),
                          style: GoogleFonts.poppins(
                            color: app_theme.kWhiteColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            shadows: [
                              Shadow(
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 4,
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFinishDialog(BuildContext context, int storybookId) {
    int _rating = 1;
    TextEditingController _commentController = TextEditingController();
    return StatefulBuilder(
      builder: (context, setState) {
        return Dialog(
          backgroundColor: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: const Icon(Icons.close,
                          size: 28, color: Colors.black54),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'You Finished the Story!',
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                      color: Colors.black87),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  'did you like the story?',
                  style:
                      GoogleFonts.poppins(fontSize: 16, color: Colors.black87),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                      5,
                      (index) => GestureDetector(
                            onTap: () {
                              setState(() {
                                _rating = index + 1;
                              });
                            },
                            child: Icon(
                              Icons.star,
                              size: 40,
                              color: index < _rating
                                  ? const Color(0xFFB2A4FF)
                                  : const Color(0xFFE4E1F7),
                            ),
                          )),
                ),
                const SizedBox(height: 6),
                Text('choose your stars',
                    style:
                        GoogleFonts.poppins(fontSize: 14, color: Colors.grey)),
                const SizedBox(height: 24),
                Text(
                  'Tell us what you thought\nabout the story!',
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black87),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 14),
                TextField(
                  controller: _commentController,
                  maxLength: 255,
                  maxLines: 3,
                  minLines: 2,
                  decoration: InputDecoration(
                    hintText: 'Loves the story!',
                    hintStyle:
                        GoogleFonts.poppins(color: Colors.grey, fontSize: 16),
                    filled: true,
                    fillColor: const Color(0xFFECECFA),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                    counterText: '',
                  ),
                  style:
                      GoogleFonts.poppins(fontSize: 16, color: Colors.black87),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFECECFA),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24)),
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 18),
                    ),
                    onPressed: () async {
                      bool success = await ApiService.logStorybookRead(
                        idStorybook: storybookId,
                        rating: _rating,
                        comments: _commentController.text.trim().isEmpty
                            ? null
                            : _commentController.text.trim(),
                      );
                      if (success) {
                        Navigator.of(context).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            backgroundColor: Colors.transparent,
                            content: Text(
                              'Success',
                              textAlign: TextAlign.center,
                            ),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            backgroundColor: Colors.transparent,
                            content: Text(
                              'Failed to submit feedback. Probably server',
                              textAlign: TextAlign.center,
                            ),
                          ),
                        );
                      }
                    },
                    child: Text(
                      'Send',
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                          fontSize: 18),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Alignment _parseAlign(String? align) {
    switch (align) {
      case 'TextAlign.center':
        return Alignment.topCenter;
      case 'TextAlign.right':
        return Alignment.topRight;
      case 'TextAlign.left':
        return Alignment.topLeft;
      default:
        return Alignment.topLeft;
    }
  }

  TextAlign _parseTextAlign(String? align) {
    switch (align) {
      case 'TextAlign.center':
        return TextAlign.center;
      case 'TextAlign.right':
        return TextAlign.right;
      case 'TextAlign.left':
        return TextAlign.left;
      default:
        return TextAlign.left;
    }
  }
}
