import 'package:flutter/material.dart';
import '../widgets/activity_info_card.dart';
import '../shared/theme.dart' as app_theme;

class QuickActivityScreen extends StatefulWidget {
  const QuickActivityScreen({super.key});

  @override
  State<QuickActivityScreen> createState() => _QuickActivityScreenState();
}

class _QuickActivityScreenState extends State<QuickActivityScreen> {
  bool isCardChosen = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: app_theme.kWhiteColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: app_theme.defaultMargin),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Top Title
              Text(
                "Let's choose what\nactivity we can do today!",
                textAlign: TextAlign.center,
                style: app_theme.blackTextStyle.copyWith(
                  fontSize: 28,
                  fontWeight: app_theme.bold,
                ),
              ),

              // The Card - this is where your randomization logic would go
              // For now, we display one card as an example.
              ActivityInfoCard(
                category: 'Cognitive',
                iconPath: 'assets/images/brain.png',
                title: 'Make up a story together!',
                description: 'you say one sentence, your child says the next!',
                backgroundColor: app_theme.kTriaryColor, // Using the pink color
              ),

              // The Button - changes based on whether a card is chosen
              _buildBottomButton(),
            ],
          ),
        ),
      ),
    );
  }

  // Helper to build the button at the bottom
  Widget _buildBottomButton() {
    return GestureDetector(
      onTap: () {
        setState(() {
          // This is where you would randomize and then show the result
          isCardChosen = !isCardChosen;
        });
      },
      child: Container(
        height: 60,
        width: isCardChosen ? 200 : 60, // Animate width change
        decoration: BoxDecoration(
          color: isCardChosen ? app_theme.kBlackColor : app_theme.kPrimaryColor,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Center(
          child: isCardChosen
              ? Text('Finish', style: app_theme.whiteTextStyle.copyWith(fontSize: 16))
              : Icon(Icons.sync, color: app_theme.kWhiteColor, size: 30),
        ),
      ),
    );
  }
}