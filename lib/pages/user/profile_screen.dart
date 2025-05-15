import 'package:flutter/material.dart';

class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 600;
    final padding = screenSize.width * (isSmallScreen ? 0.05 : 0.07);
    final spacing = screenSize.width * (isSmallScreen ? 0.03 : 0.04);
    final titleFontSize = screenSize.width * (isSmallScreen ? 0.06 : 0.045);
    final headerFontSize = screenSize.width * (isSmallScreen ? 0.07 : 0.055);
    final bodyFontSize = screenSize.width * (isSmallScreen ? 0.045 : 0.035);
    final buttonFontSize = screenSize.width * (isSmallScreen ? 0.045 : 0.035);
    final primaryColor = theme.primaryColor;
    final cardColor = theme.cardColor;
    final backgroundColor = theme.scaffoldBackgroundColor;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              height: spacing * 4,
              width: spacing * 6,
              padding: EdgeInsets.all(spacing * 0.5),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(16),
                image: DecorationImage(
                  image: AssetImage('assets/images/logo.png'),
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
            Text(
              'الملف الشخصي',
              style: Theme.of(context).textTheme.displayLarge?.copyWith(
                    fontSize: titleFontSize,
                    color: Theme.of(context).cardColor,
                  ),
            ),
          ],
        ),
      ),
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 500),
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: padding),
              child: Column(
                children: [
                  _buildProfileHeader(
                      context, theme, primaryColor, cardColor, spacing),
                  SizedBox(height: spacing * 6),

                  // Action Buttons
                  _buildActionButton(
                    context,
                    icon: Icons.edit,
                    label: 'تعديل البيانات الشخصية',
                    spacing: spacing,
                  ),
                  _buildActionButton(
                    context,
                    icon: Icons.photo_camera,
                    label: 'تغيير الصورة الشخصية',
                    spacing: spacing,
                  ),
                  _buildActionButton(
                    context,
                    icon: Icons.location_on,
                    label: 'إدارة عناوين التوصيل',
                    spacing: spacing,
                  ),

                  SizedBox(height: spacing * 4),
                  _buildLogoutButton(context, primaryColor),
                  SizedBox(height: spacing * 3),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context, ThemeData theme,
      Color primaryColor, Color cardColor, double spacing) {
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 600;
    final padding = screenSize.width * (isSmallScreen ? 0.05 : 0.07);
    final spacing = screenSize.width * (isSmallScreen ? 0.03 : 0.04);
    final headerFontSize = screenSize.width * (isSmallScreen ? 0.06 : 0.055);
    final bodyFontSize = screenSize.width * (isSmallScreen ? 0.035 : 0.035);
    final primaryColor = theme.primaryColor;
    final cardColor = theme.cardColor;
    final backgroundColor = theme.scaffoldBackgroundColor;
    return Stack(
      clipBehavior: Clip.none,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Image.asset(
            'assets/images/prof_card.png',
            width: double.infinity,
            height: isSmallScreen ? 200 : 220,
            fit: BoxFit.cover,
          ),
        ),
        Positioned(
          bottom: -spacing * 4,
          left: 0,
          right: 0,
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: spacing),
            padding: EdgeInsets.symmetric(
                vertical: spacing * (isSmallScreen ? 1.2 : 2),
                horizontal: spacing * (isSmallScreen ? 1.5 : 2.5)),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: isSmallScreen ? 60 : 80,
                  height: isSmallScreen ? 60 : 80,
                  decoration: BoxDecoration(
                    color: primaryColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(Icons.person,
                      size: isSmallScreen ? 40 : 56, color: primaryColor),
                ),
                SizedBox(width: spacing),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'محمد أحمد',
                        style: theme.textTheme.displayLarge?.copyWith(
                            color: primaryColor, fontSize: headerFontSize),
                      ),
                      SizedBox(height: spacing * 0.1),
                      Text(
                        '+96659142423',
                        style: theme.textTheme.bodyLarge?.copyWith(
                            color: primaryColor.withOpacity(0.7),
                            fontSize: bodyFontSize),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton(BuildContext context,
      {required IconData icon,
      required String label,
      required double spacing}) {
    final theme = Theme.of(context);
    final primaryColor = theme.primaryColor;
    final cardColor = theme.cardColor;
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 600;
    final buttonFontSize = screenSize.width * (isSmallScreen ? 0.045 : 0.035);

    return Padding(
      padding: EdgeInsets.symmetric(vertical: spacing),
      child: Container(
        padding: EdgeInsets.symmetric(
            vertical: spacing * 1.2, horizontal: spacing * 1.5),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: primaryColor),
            const Spacer(),
            Text(
              label,
              style: theme.textTheme.bodyLarge
                  ?.copyWith(color: primaryColor, fontSize: buttonFontSize),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context, Color primaryColor) {
    final theme = Theme.of(context);
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 600;
    final buttonFontSize = screenSize.width * (isSmallScreen ? 0.045 : 0.035);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: ElevatedButton.icon(
        icon: Icon(Icons.logout_rounded, color: Colors.red.shade400),
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).cardColor,
          foregroundColor: primaryColor,
          minimumSize: const Size(double.infinity, 52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 1,
        ),
        label: Text(
          'تسجيل الخروج',
          style: theme.textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: primaryColor,
            fontSize: buttonFontSize,
          ),
        ),
        onPressed: () {},
      ),
    );
  }
}
