import 'package:flutter/material.dart';

class SenderForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  const SenderForm({super.key, required this.formKey});

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
              icon: Icons.person, text: "معلومات المرسل", context: context),
          SizedBox(height: spacing),
          _roundedInput("الاسم الكامل", context),
          SizedBox(height: spacing),
          _roundedInput("رقم الهاتف", context),
          SizedBox(height: spacing),
          _roundedInput("العنوان الوطني", context),
          SizedBox(height: spacing),
          _roundedInput("العنوان الحالي", context),
        ],
      ),
    );
  }
}

Widget _headerCard(
    {required IconData icon,
    required String text,
    required BuildContext context}) {
  final screenSize = MediaQuery.of(context).size;
  final isSmallScreen = screenSize.width < 600;
  final padding = screenSize.width * (isSmallScreen ? 0.05 : 0.07);
  final spacing = screenSize.width * (isSmallScreen ? 0.03 : 0.04);
  return Container(
    padding: EdgeInsets.all(padding),
    decoration: BoxDecoration(
      color: Theme.of(context).primaryColor,
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(
            color: Color(0x334F8FFF), blurRadius: 16, offset: Offset(0, 4)),
      ],
    ),
    child: Column(
      children: [
        Icon(icon, color: Colors.white, size: 40),
        SizedBox(height: spacing),
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

Widget _roundedInput(String label, BuildContext context,
    {String? initialValue, ValueChanged<String>? onChanged, IconData? icon}) {
  return Directionality(
    textDirection: TextDirection.rtl,
    child: TextFormField(
      initialValue: initialValue,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Color(0xFF8F9BB3),
              fontWeight: FontWeight.w500,
            ),
        filled: true,
        fillColor: Colors.white,
        prefixIcon: icon != null
            ? Icon(icon, color: Theme.of(context).primaryColor)
            : null,
        contentPadding: EdgeInsets.symmetric(vertical: 18, horizontal: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Color(0xFFE4E9F2)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Color(0xFFE4E9F2)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Theme.of(context).primaryColor),
        ),
      ),
    ),
  );
}
