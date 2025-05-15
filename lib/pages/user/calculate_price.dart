import 'package:flutter/material.dart';

class CalculatePrice extends StatefulWidget {
  const CalculatePrice({super.key});

  @override
  State<CalculatePrice> createState() => _CalculatePriceState();
}

class _CalculatePriceState extends State<CalculatePrice> {
  final _formKey = GlobalKey<FormState>();
  String _deliveryType = "Standard";
  String _parcelType = "Document";
  String _parcelSize = "Small";
  String _parcelNature = "Regular";
  String _weight = "";
  String _fromLocation = "";
  String _toLocation = "";
  double _estimatedPrice = 0.0;

  void _calculatePrice() {
    if (_formKey.currentState!.validate()) {
      // Base price calculation
      double basePrice = 10.0; // Base price in currency units

      // Parcel type factor
      double typeFactor = _parcelType == "Document" ? 1.0 : 1.5;

      // Weight factor (price per kg) - only for packages
      double weightPrice =
          _parcelType == "Document" ? 0.0 : double.parse(_weight) * 2.0;

      // Parcel size factor - only for packages
      double sizeFactor = 1.0;
      if (_parcelType == "Package") {
        switch (_parcelSize) {
          case "Small":
            sizeFactor = 1.0;
            break;
          case "Medium":
            sizeFactor = 1.3;
            break;
          case "Large":
            sizeFactor = 1.6;
            break;
        }
      }

      // Parcel nature factor - only for packages
      double natureFactor =
          _parcelType == "Package" && _parcelNature == "Fragile" ? 1.5 : 1.0;

      // Delivery type multiplier
      double typeMultiplier = _deliveryType == "Express" ? 1.5 : 1.0;

      // Calculate final price
      _estimatedPrice = (basePrice + weightPrice) *
          typeFactor *
          sizeFactor *
          natureFactor *
          typeMultiplier;

      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 600;
    final padding = screenSize.width * (isSmallScreen ? 0.05 : 0.07);
    final spacing = screenSize.width * (isSmallScreen ? 0.03 : 0.04);

    final iconSize = screenSize.width * (isSmallScreen ? 0.03 : 0.04);

    return Scaffold(
      appBar: AppBar(
        title: const Text('حساب تكلفة الشحن'),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: ListView(
            padding: EdgeInsets.all(padding),
            children: [
              _headerCard(
                icon: Icons.calculate_outlined,
                text: "حساب التكلفة",
                context: context,
              ),
              SizedBox(height: spacing),
              Text(
                "نوع الشحنة",
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF222B45),
                    ),
              ),
              SizedBox(height: spacing * 0.5),
              Row(
                children: [
                  _ChoiceChip(
                    context: context,
                    label: "وثيقة",
                    selected: _parcelType == "Document",
                    onTap: () => setState(() => _parcelType = "Document"),
                    icon: 'assets/images/doc.png',
                  ),
                  SizedBox(width: spacing),
                  _ChoiceChip(
                    context: context,
                    label: "شحنة",
                    selected: _parcelType == "Package",
                    onTap: () => setState(() => _parcelType = "Package"),
                    icon: 'assets/images/regular.png',
                  ),
                ],
              ),
              if (_parcelType == "Package") ...[
                SizedBox(height: spacing),
                Text(
                  "حجم الشحنة",
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF222B45),
                      ),
                ),
                SizedBox(height: spacing * 0.5),
                Row(
                  children: [
                    _ChoiceChip(
                      label: "صغير",
                      selected: _parcelSize == "Small",
                      onTap: () => setState(() => _parcelSize = "Small"),
                      context: context,
                    ),
                    SizedBox(width: spacing),
                    _ChoiceChip(
                      label: "متوسط",
                      selected: _parcelSize == "Medium",
                      onTap: () => setState(() => _parcelSize = "Medium"),
                      context: context,
                    ),
                    SizedBox(width: spacing),
                    _ChoiceChip(
                      label: "كبير",
                      selected: _parcelSize == "Large",
                      onTap: () => setState(() => _parcelSize = "Large"),
                      context: context,
                    ),
                  ],
                ),
                SizedBox(height: spacing),
                Text(
                  "طبيعة الشحنة",
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF222B45),
                      ),
                ),
                SizedBox(height: spacing * 0.5),
                Row(
                  children: [
                    _ChoiceChip(
                      label: "قابل للكسر",
                      selected: _parcelNature == "Fragile",
                      onTap: () => setState(() => _parcelNature = "Fragile"),
                      icon: 'assets/images/fragile.png',
                      iconColor: Colors.redAccent,
                      context: context,
                    ),
                    SizedBox(width: spacing),
                    _ChoiceChip(
                      label: "عادي",
                      selected: _parcelNature == "Regular",
                      onTap: () => setState(() => _parcelNature = "Regular"),
                      icon: 'assets/images/regular.png',
                      iconColor: Colors.green,
                      context: context,
                    ),
                  ],
                ),
                SizedBox(height: spacing),
                _roundedInput(
                  "الوزن (كجم)",
                  context,
                  initialValue: _weight,
                  onChanged: (value) => setState(() => _weight = value),
                  icon: Icons.monitor_weight_outlined,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'الرجاء إدخال الوزن';
                    }
                    if (double.tryParse(value) == null) {
                      return 'الرجاء إدخال رقم صحيح';
                    }
                    return null;
                  },
                ),
              ],
              SizedBox(height: spacing),
              Text(
                "نوع التوصيل",
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF222B45),
                    ),
              ),
              SizedBox(height: spacing * 0.5),
              Row(
                children: [
                  _ChoiceChip(
                    context: context,
                    label: "عادي",
                    selected: _deliveryType == "Standard",
                    onTap: () => setState(() => _deliveryType = "Standard"),
                    icon: 'assets/images/box.png',
                    height: iconSize * 2,
                  ),
                  SizedBox(width: spacing),
                  _ChoiceChip(
                    context: context,
                    label: "سريع",
                    selected: _deliveryType == "Express",
                    onTap: () => setState(() => _deliveryType = "Express"),
                    icon: 'assets/images/delivery_truck.png',
                    height: iconSize * 2,
                  ),
                ],
              ),
              SizedBox(height: spacing),
              Text(
                "موقع التوصيل",
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF222B45),
                    ),
              ),
              SizedBox(height: spacing * 0.5),
              _roundedInput(
                "من",
                context,
                initialValue: _fromLocation,
                onChanged: (value) => setState(() => _fromLocation = value),
                icon: Icons.location_on_outlined,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'الرجاء إدخال موقع البداية';
                  }
                  return null;
                },
              ),
              SizedBox(height: spacing),
              _roundedInput(
                "إلى",
                context,
                initialValue: _toLocation,
                onChanged: (value) => setState(() => _toLocation = value),
                icon: Icons.location_on_outlined,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'الرجاء إدخال موقع الوصول';
                  }
                  return null;
                },
              ),
              SizedBox(height: spacing * 2),
              if (_estimatedPrice > 0) ...[
                Container(
                  padding: EdgeInsets.all(padding),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        "التكلفة المقدرة",
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      SizedBox(height: spacing * 0.5),
                      Text(
                        "${_estimatedPrice.toStringAsFixed(2)} ريال",
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: spacing),
              ],
              ElevatedButton(
                onPressed: _calculatePrice,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  padding: EdgeInsets.symmetric(vertical: padding),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: Text(
                  "حساب التكلفة",
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                        fontSize: 20,
                        color: Theme.of(context).cardColor,
                        //fontWeight: FontWeight.bold,
                      ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _headerCard({
    required IconData icon,
    required String text,
    required BuildContext context,
  }) {
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
            color: const Color(0x334F8FFF),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
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
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 600;
    final padding = screenSize.width * (isSmallScreen ? 0.05 : 0.07);

    return TextFormField(
      initialValue: initialValue,
      onChanged: onChanged,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: const Color(0xFF8F9BB3),
              fontWeight: FontWeight.w500,
            ),
        filled: true,
        fillColor: Colors.white,
        prefixIcon: icon != null
            ? Icon(icon, color: Theme.of(context).primaryColor)
            : null,
        contentPadding: EdgeInsets.symmetric(
          vertical: padding,
          horizontal: padding,
        ),
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
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.red),
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
    double? height,
    required BuildContext context,
  }) {
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 600;
    final padding = screenSize.width * (isSmallScreen ? 0.05 : 0.07);
    final spacing = screenSize.width * (isSmallScreen ? 0.03 : 0.04);
    final iconSize = screenSize.width * (isSmallScreen ? 0.03 : 0.04);

    height = height ?? iconSize * 1.5;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: padding,
          vertical: padding * 0.5,
        ),
        decoration: BoxDecoration(
          color: selected ? Theme.of(context).primaryColor : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected
                ? Theme.of(context).primaryColor
                : const Color(0xFFE4E9F2),
          ),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: const Color(0x334F8FFF),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  )
                ]
              : [],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null)
              Image.asset(
                icon,
                height: height,
              ),
            if (icon != null) SizedBox(width: spacing * .5),
            Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: selected ? Colors.white : const Color(0xFF222B45),
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
