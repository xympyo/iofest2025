import 'package:flutter/material.dart';
import '../shared/theme.dart' as app_theme;

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: app_theme.kWhiteColor,
      appBar: AppBar(
        backgroundColor: app_theme.kPrimaryLightColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close, color: app_theme.kBlackColor, size: 30),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Edit Profile',
          style: app_theme.blackTextStyle.copyWith(
            fontSize: 20,
            fontWeight: app_theme.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.check, color: app_theme.kPrimaryColor, size: 30),
            onPressed: () {
              // TODO: Implement save profile logic
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: app_theme.defaultMargin,
          vertical: 30,
        ),
        child: Column(
          children: [
            _buildTextField(label: 'Name', value: 'Moshe Dayan'),
            const SizedBox(height: 24),
            _buildTextField(label: 'Username', value: '@xympyo'),
            const SizedBox(height: 24),
            _buildTextField(label: 'Email Address', value: 'xympyo@gmail.com'),
          ],
        ),
      ),
    );
  }

  // Helper widget for text fields
  Widget _buildTextField({required String label, required String value}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: app_theme.primaryTextStyle.copyWith(
            color: app_theme.kPrimaryColor,
            fontWeight: app_theme.medium,
          ),
        ),
        TextFormField(
          initialValue: value,
          style: app_theme.blackTextStyle.copyWith(
            fontSize: 16,
            fontWeight: app_theme.semiBold,
          ),
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(vertical: 12),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: app_theme.kBlackColor.withOpacity(0.3)),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: app_theme.kPrimaryColor),
            ),
          ),
        ),
      ],
    );
  }
}