import 'package:flutter/material.dart';

class RecipientForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController? nameController;
  final TextEditingController? phoneController;
  final TextEditingController? addressController;
  final TextEditingController? shortAddressController;
  final TextEditingController? buildingNumberController;
  final TextEditingController? unitNumberController;
  final TextEditingController? postalCodeController;
  final TextEditingController? cityController;
  final TextEditingController? districtController;
  final bool saveRecipientData;
  final ValueChanged<bool> onSaveRecipientDataChanged;
  final VoidCallback? onLoadSavedData;
  final bool hasSavedData;
  final VoidCallback? onChooseAddress;
  
  const RecipientForm({
    super.key, 
    required this.formKey,
    this.nameController,
    this.phoneController,
    this.addressController,
    this.shortAddressController,
    this.buildingNumberController,
    this.unitNumberController,
    this.postalCodeController,
    this.cityController,
    this.districtController,
    required this.saveRecipientData,
    required this.onSaveRecipientDataChanged,
    this.onLoadSavedData,
    this.hasSavedData = false,
    this.onChooseAddress,
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
                title: "معلومات المستلم",
                icon: Icons.location_on_outlined,
              ),
              const SizedBox(height: 20),

              // Quick actions for saved addresses
              _buildQuickActions(context),

              // Personal info section
              _buildFormSection(
                context: context,
                title: "البيانات الشخصية",
                children: [
                  _buildCleanInput(
                    context: context,
                    label: "اسم المستلم",
                    controller: nameController,
                    icon: Icons.person_outline,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'يرجى إدخال اسم المستلم';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildCleanInput(
                    context: context,
                    label: "رقم الجوال",
                    controller: phoneController,
                    icon: Icons.phone_outlined,
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'يرجى إدخال رقم الجوال';
                      }
                      if (!RegExp(r'^05[0-9]{8}$').hasMatch(value.trim())) {
                        return 'رقم جوال غير صحيح';
                      }
                      return null;
                    },
                  ),
                ],
              ),

              // National address section
              _buildFormSection(
                context: context,
                title: "العنوان الوطني",
                children: [
                  _buildCleanInput(
                    label: "العنوان المختصر",
                    controller: shortAddressController,
                    icon: Icons.location_on_outlined,
                    context: context,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'يرجى إدخال العنوان المختصر';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildCleanInput(
                          label: "رقم المبنى",
                          controller: buildingNumberController,
                          icon: Icons.apartment_outlined,
                          keyboardType: TextInputType.number,
                          context: context,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'مطلوب';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildCleanInput(
                          label: "الرقم الفرعي",
                          controller: unitNumberController,
                          icon: Icons.tag_outlined,
                          keyboardType: TextInputType.number,
                          context: context,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'مطلوب';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildCleanInput(
                          label: "الرمز البريدي",
                          controller: postalCodeController,
                          icon: Icons.markunread_mailbox_outlined,
                          keyboardType: TextInputType.number,
                          context: context,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'مطلوب';
                            }
                            if (value.trim().length != 5) {
                              return '5 أرقام';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildCleanInput(
                          label: "المدينة",
                          controller: cityController,
                          icon: Icons.location_city_outlined,
                          context: context,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'يرجى إدخال المدينة';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildCleanInput(
                          label: "الحي",
                          controller: districtController,
                          icon: Icons.place_outlined,
                          context: context,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'يرجى إدخال الحي';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildCleanInput(
                    label: "تفاصيل إضافية (اختياري)",
                    controller: addressController,
                    icon: Icons.home_outlined,
                    context: context,
                    maxLines: 2,
                  ),
                ],
              ),

              // Save preferences
              _buildSaveToggle(
                context: context,
                value: saveRecipientData,
                onChanged: onSaveRecipientDataChanged,
                title: "حفظ هذا العنوان",
                subtitle: "للاستخدام في الشحنات القادمة",
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

  Widget _buildQuickActions(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        children: [
          Expanded(
            child: _buildQuickActionChip(
              context: context,
              label: "اختر عنوان محفوظ",
              icon: Icons.location_on_rounded,
              color: Colors.blue,
              onPressed: () {
                print('🔘 Choose address button pressed in RecipientForm');
                onChooseAddress?.call();
              },
            ),
          ),
          if (hasSavedData) ...[
            const SizedBox(width: 12),
            Expanded(
              child: _buildQuickActionChip(
                context: context,
                label: "آخر عنوان",
                icon: Icons.history_rounded,
                color: Colors.green,
                onPressed: onLoadSavedData,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildQuickActionChip({
    required BuildContext context,
    required String label,
    required IconData icon,
    required Color color,
    VoidCallback? onPressed,
  }) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFF9B652E).withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: const Color(0xFF9B652E).withOpacity(0.3),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: const Color(0xFF9B652E),
              size: 16,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                label,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: const Color(0xFF9B652E),
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
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

  Widget _buildCleanInput({
    required String label,
    required TextEditingController? controller,
    required IconData icon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    int maxLines = 1,
    required BuildContext context,
  }) {
    final theme = Theme.of(context);

    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: validator,
      textAlign: TextAlign.right,
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
        prefixIcon: Icon(
          icon,
          size: 20,
          color: const Color(0xFF8B572A),
        ),
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
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Colors.red,
            width: 1,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Colors.red,
            width: 2,
          ),
        ),
        errorStyle: const TextStyle(
          fontSize: 12,
          height: 1.2,
        ),
      ),
    );
  }

  Widget _buildSaveToggle({
    required BuildContext context,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFAF3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: value 
              ? const Color(0xFF9B652E).withOpacity(0.3)
              : const Color(0xFF9B652E).withOpacity(0.1),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF222831),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: const Color(0xFF8B572A),
                  ),
                ),
              ],
            ),
          ),
          Switch.adaptive(
            value: value,
            onChanged: onChanged,
            activeColor: const Color(0xFF9B652E),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ],
      ),
    );
  }
}