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
    final theme = Theme.of(context);

    return Form(
      key: formKey,
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Compact header
              _buildCompactHeader(
                context: context,
                title: "تفاصيل الشحنة",
                icon: Icons.inventory_2_outlined,
              ),
              const SizedBox(height: 24),

              // Shipment type selection
              _buildSelectionSection(
                context: context,
                title: "نوع الشحنة",
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _buildSelectionCard(
                          context: context,
                          title: "وثيقة",
                          subtitle: "مستندات وأوراق",
                          icon: Icons.description_outlined,
                          color: const Color(0xFF2196F3),
                          isSelected: parcelType == "Document",
                          onTap: () => onParcelTypeChanged("Document"),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildSelectionCard(
                          context: context,
                          title: "طرد",
                          subtitle: "بضائع ومنتجات",
                          icon: Icons.inventory_2_outlined,
                          color: const Color(0xFF4CAF50),
                          isSelected: parcelType == "Normal",
                          onTap: () => onParcelTypeChanged("Normal"),
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              // Additional details for Normal parcels
              if (parcelType == "Normal") ...[
                // Size selection
                _buildSelectionSection(
                  context: context,
                  title: "حجم الشحنة",
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: _buildSizeCard(
                            context: context,
                            title: "صغير",
                            subtitle: "حتى 30 سم",
                            icon: Icons.crop_din_outlined,
                            color: const Color(0xFF4CAF50),
                            isSelected: parcelSize == "Small",
                            onTap: () => onParcelSizeChanged("Small"),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _buildSizeCard(
                            context: context,
                            title: "متوسط",
                            subtitle: "30-60 سم",
                            icon: Icons.crop_landscape_outlined,
                            color: const Color(0xFFFF9800),
                            isSelected: parcelSize == "Medium",
                            onTap: () => onParcelSizeChanged("Medium"),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _buildSizeCard(
                            context: context,
                            title: "كبير",
                            subtitle: "أكثر من 60 سم",
                            icon: Icons.crop_free_outlined,
                            color: const Color(0xFFF44336),
                            isSelected: parcelSize == "Large",
                            onTap: () => onParcelSizeChanged("Large"),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                // Weight input
                _buildFormSection(
                  context: context,
                  title: "الوزن",
                  children: [
                    _buildCleanInput(
                      context: context,
                      label: "الوزن بالكيلوجرام",
                      initialValue: weight,
                      onChanged: onWeightChanged,
                      icon: Icons.monitor_weight_outlined,
                      keyboardType: TextInputType.number,
                    ),
                  ],
                ),

                // Nature selection
                _buildSelectionSection(
                  context: context,
                  title: "طبيعة الشحنة",
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: _buildNatureCard(
                            context: context,
                            title: "قابل للكسر",
                            subtitle: "يحتاج عناية خاصة",
                            icon: Icons.warning_outlined,
                            color: const Color(0xFFF44336),
                            isSelected: parcelNature == "Fragile",
                            onTap: () => onParcelNatureChanged("Fragile"),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildNatureCard(
                            context: context,
                            title: "عادي",
                            subtitle: "بضائع عادية",
                            icon: Icons.check_circle_outline,
                            color: const Color(0xFF4CAF50),
                            isSelected: parcelNature == "Normal",
                            onTap: () => onParcelNatureChanged("Normal"),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],

              // Notes section
              _buildFormSection(
                context: context,
                title: "ملاحظات إضافية (اختياري)",
                children: [
                  _buildCleanInput(
                    context: context,
                    label: "أي ملاحظات خاصة بالشحنة",
                    icon: Icons.edit_note_outlined,
                    maxLines: 3,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCompactHeader({
    required BuildContext context,
    required String title,
    required IconData icon,
  }) {
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFAF3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF9B652E).withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: const Color(0xFF9B652E),
            size: 20,
          ),
          const SizedBox(width: 12),
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: const Color(0xFF9B652E),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormSection({
    required BuildContext context,
    required String title,
    required List<Widget> children,
  }) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Text(
            title,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: const Color(0xFF222831),
              letterSpacing: 0.2,
            ),
          ),
        ),
        ...children,
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildSelectionSection({
    required BuildContext context,
    required String title,
    required List<Widget> children,
  }) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Text(
            title,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: const Color(0xFF222831),
              letterSpacing: 0.2,
            ),
          ),
        ),
        ...children,
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildSelectionCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.1) : const Color(0xFFFFFAF3),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? color : const Color(0xFF9B652E).withOpacity(0.3),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isSelected ? color.withOpacity(0.2) : const Color(0xFF9B652E).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: isSelected ? color : const Color(0xFF8B572A),
                size: 28,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: isSelected ? color : const Color(0xFF1A1A1A),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 12,
                color: isSelected ? color.withOpacity(0.8) : const Color(0xFF8B572A),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSizeCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.1) : const Color(0xFFFFFAF3),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? color : const Color(0xFF9B652E).withOpacity(0.3),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected ? color : const Color(0xFF8B572A),
              size: 20,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 13,
                color: isSelected ? color : const Color(0xFF1A1A1A),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 10,
                color: isSelected ? color.withOpacity(0.8) : const Color(0xFF8B572A),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNatureCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.1) : const Color(0xFFFFFAF3),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? color : const Color(0xFF9B652E).withOpacity(0.3),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected ? color : const Color(0xFF8B572A),
              size: 24,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: isSelected ? color : const Color(0xFF1A1A1A),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 11,
                color: isSelected ? color.withOpacity(0.8) : const Color(0xFF8B572A),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCleanInput({
    required String label,
    String? initialValue,
    ValueChanged<String>? onChanged,
    IconData? icon,
    TextInputType? keyboardType,
    int maxLines = 1,
    required BuildContext context,
  }) {
    final theme = Theme.of(context);

    return TextFormField(
      initialValue: initialValue,
      onChanged: onChanged,
      keyboardType: keyboardType,
      maxLines: maxLines,
      style: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          fontSize: 14,
          color: const Color(0xFF8B572A),
          fontWeight: FontWeight.w500,
        ),
        prefixIcon: icon != null ? Icon(
          icon,
          size: 20,
          color: const Color(0xFF8B572A),
        ) : null,
        filled: true,
        fillColor: const Color(0xFFFFFAF3),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: const Color(0xFF9B652E).withOpacity(0.2),
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: const Color(0xFF9B652E),
            width: 2,
          ),
        ),
      ),
    );
  }
}