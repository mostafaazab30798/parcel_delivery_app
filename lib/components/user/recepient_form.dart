import 'package:flutter/material.dart';

class RecipientForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  const RecipientForm({super.key, required this.formKey});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 600;
    final padding = screenSize.width * (isSmallScreen ? 0.05 : 0.07);
    final spacing = screenSize.width * (isSmallScreen ? 0.03 : 0.04);

    return Form(
      key: formKey,
      child: ListView(
        padding: EdgeInsets.all(padding),
        children: [
          _headerCard(
              icon: Icons.person_outline,
              text: "معلومات المرسل إليه",
              context: context),
          SizedBox(height: spacing),
          _roundedInput("الاسم الكامل", context),
          SizedBox(height: spacing),
          _roundedInput("رقم الهاتف", context),
          SizedBox(height: spacing),
          _roundedInput("المدينة", context),
          SizedBox(height: spacing),
          _roundedInput("الحي", context),
          SizedBox(height: spacing),
          _roundedInput("العنوان الوطني", context),
        ],
      ),
    );
  }
}

Widget _headerCard(
    {required IconData icon,
    required String text,
    required BuildContext context}) {
  return Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: Theme.of(context).primaryColor,
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(
          color: Theme.of(context).primaryColor.withOpacity(0.2),
          blurRadius: 16,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: Column(
      children: [
        Icon(icon, color: Colors.white, size: 40),
        const SizedBox(height: 10),
        Text(
          text,
          style: Theme.of(context)
              .textTheme
              .bodyLarge
              ?.copyWith(color: Colors.white),
          textAlign: TextAlign.center,
        ),
      ],
    ),
  );
}

Widget _roundedInput(String label, BuildContext context) {
  return Directionality(
    textDirection: TextDirection.rtl,
    child: TextFormField(
      textAlign: TextAlign.right,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(
          overflow: TextOverflow.ellipsis,
          color: Color(0xFF8F9BB3),
          fontWeight: FontWeight.w500,
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFE4E9F2)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFE4E9F2)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Theme.of(context).primaryColor),
        ),
      ),
    ),
  );
}
