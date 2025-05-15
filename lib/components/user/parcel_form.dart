import 'package:flutter/material.dart';

class ParcelForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final String parcelType;
  final ValueChanged<String> onParcelTypeChanged;
  final String? weight;
  final ValueChanged<String> onWeightChanged;
  final String parcelSize;
  final ValueChanged<String> onParcelSizeChanged;
  final String parcelNature;
  final ValueChanged<String> onParcelNatureChanged;

  const ParcelForm({
    super.key,
    required this.formKey,
    required this.parcelType,
    required this.onParcelTypeChanged,
    required this.weight,
    required this.onWeightChanged,
    required this.parcelSize,
    required this.onParcelSizeChanged,
    required this.parcelNature,
    required this.onParcelNatureChanged,
  });

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 600;
    final padding = screenSize.width * (isSmallScreen ? 0.05 : 0.07);
    final spacing = screenSize.width * (isSmallScreen ? 0.03 : 0.04);

    return Form(
      key: formKey,
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: ListView(
          padding: EdgeInsets.all(padding),
          children: [
            _headerCard(
              icon: Icons.inventory_2,
              text: "معلومات الشحنة",
              context: context,
            ),
            SizedBox(height: spacing),
            Text(
              "نوع الشحنة",
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF222B45),
                  ),
            ),
            SizedBox(height: spacing * 0.5),
            Row(
              children: [
                _ChoiceChip(
                  context: context,
                  label: "وثيقة",
                  selected: parcelType == "Document",
                  onTap: () => onParcelTypeChanged("Document"),
                  icon: 'assets/images/doc.png',
                ),
                SizedBox(width: spacing),
                _ChoiceChip(
                  context: context,
                  label: "شحنة",
                  selected: parcelType == "Package",
                  onTap: () => onParcelTypeChanged("Package"),
                  icon: 'assets/images/regular.png',
                ),
              ],
            ),
            if (parcelType == "Package") ...[
              SizedBox(height: spacing),
              Text(
                "حجم الشحنة",
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF222B45),
                    ),
              ),
              SizedBox(height: spacing * 0.5),
              Row(
                children: [
                  _ChoiceChip(
                    label: "صغير",
                    selected: parcelSize == "Small",
                    onTap: () => onParcelSizeChanged("Small"),
                    context: context,
                  ),
                  SizedBox(width: spacing),
                  _ChoiceChip(
                    label: "متوسط",
                    selected: parcelSize == "Medium",
                    onTap: () => onParcelSizeChanged("Medium"),
                    context: context,
                  ),
                  SizedBox(width: spacing),
                  _ChoiceChip(
                    label: "كبير",
                    selected: parcelSize == "Large",
                    onTap: () => onParcelSizeChanged("Large"),
                    context: context,
                  ),
                ],
              ),
              SizedBox(height: spacing),
              _roundedInput(
                "الوزن (كجم)",
                context,
                initialValue: weight,
                onChanged: onWeightChanged,
                icon: Icons.monitor_weight_outlined,
              ),
              SizedBox(height: spacing),
              Text(
                "طبيعة الشحنة",
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF222B45),
                    ),
              ),
              SizedBox(height: spacing * 0.5),
              Row(
                children: [
                  _ChoiceChip(
                    label: "قابل للكسر",
                    selected: parcelNature == "Fragile",
                    onTap: () => onParcelNatureChanged("Fragile"),
                    icon: 'assets/images/fragile.png',
                    iconColor: Colors.redAccent,
                    context: context,
                  ),
                  SizedBox(width: spacing),
                  _ChoiceChip(
                    label: "عادي",
                    selected: parcelNature == "Regular",
                    onTap: () => onParcelNatureChanged("Regular"),
                    icon: 'assets/images/regular.png',
                    iconColor: Colors.green,
                    context: context,
                  ),
                ],
              ),
            ],
            SizedBox(height: spacing),
            Text(
              "الملاحظات",
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF222B45),
                  ),
            ),
            SizedBox(height: spacing),
            _roundedInput(
              "الملاحظات",
              context,
            ),
          ],
        ),
      ),
    );
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
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.white,
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _roundedInput(
    String label,
    BuildContext context, {
    String? initialValue,
    ValueChanged<String>? onChanged,
    IconData? icon,
  }) {
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 600;
    final padding = screenSize.width * (isSmallScreen ? 0.05 : 0.07);

    return TextFormField(
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
        contentPadding:
            EdgeInsets.symmetric(vertical: padding, horizontal: padding),
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
    );
  }

  Widget _ChoiceChip({
    required String label,
    required bool selected,
    required VoidCallback onTap,
    String? icon,
    Color? iconColor,
    required BuildContext context,
  }) {
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 600;
    final padding = screenSize.width * (isSmallScreen ? 0.05 : 0.07);
    final spacing = screenSize.width * (isSmallScreen ? 0.03 : 0.04);
    final iconSize = screenSize.width * (isSmallScreen ? 0.03 : 0.04);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding:
            EdgeInsets.symmetric(horizontal: padding, vertical: padding * 0.5),
        decoration: BoxDecoration(
          color: selected ? Theme.of(context).primaryColor : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color:
                selected ? Theme.of(context).primaryColor : Color(0xFFE4E9F2),
          ),
          boxShadow: selected
              ? [
                  BoxShadow(
                      color: Color(0x334F8FFF),
                      blurRadius: 8,
                      offset: Offset(0, 2))
                ]
              : [],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null)
              Image.asset(
                icon,
                width: iconSize * 1.5,
                height: iconSize * 1.5,
              ),
            if (icon != null) SizedBox(width: spacing),
            Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: selected ? Colors.white : Color(0xFF222B45),
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
