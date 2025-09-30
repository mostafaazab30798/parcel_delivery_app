import 'package:flutter/material.dart';

class SenderForm extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController phoneController;
  final TextEditingController addressController;
  final TextEditingController shortAddressController;
  final TextEditingController buildingNumberController;
  final TextEditingController unitNumberController;
  final TextEditingController postalCodeController;
  final TextEditingController cityController;
  final TextEditingController districtController;
  final bool saveSenderData;
  final ValueChanged<bool> onSaveSenderDataChanged;
  final VoidCallback? onLoadSavedData;
  final bool hasSavedData;
  final VoidCallback? onChooseAddress;

  const SenderForm({
    super.key,
    required this.formKey,
    required this.nameController,
    required this.phoneController,
    required this.addressController,
    required this.shortAddressController,
    required this.buildingNumberController,
    required this.unitNumberController,
    required this.postalCodeController,
    required this.cityController,
    required this.districtController,
    required this.saveSenderData,
    required this.onSaveSenderDataChanged,
    this.onLoadSavedData,
    this.hasSavedData = false,
    this.onChooseAddress,
  });

  @override
  State<SenderForm> createState() => _SenderFormState();
}

class _SenderFormState extends State<SenderForm> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Form(
      key: widget.formKey,
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
                title: "معلومات المرسل",
                icon: Icons.person_outline,
              ),
              const SizedBox(height: 20),

              // Quick actions (only if has saved data)
              if (widget.hasSavedData)
                _buildQuickActionChip(
                  context: context,
                  label: "استخدام البيانات المحفوظة",
                  icon: Icons.history_rounded,
                  onPressed: widget.onLoadSavedData,
                ),

              // Personal info section
              _buildFormSection(
                context: context,
                title: "البيانات الشخصية",
                children: [
                  _buildCleanInput(
                    label: "الاسم الكامل",
                    controller: widget.nameController,
                    icon: Icons.person_outline,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'يرجى إدخال الاسم';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildCleanInput(
                    label: "رقم الجوال",
                    controller: widget.phoneController,
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
                    controller: widget.shortAddressController,
                    icon: Icons.location_on_outlined,
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
                          controller: widget.buildingNumberController,
                          icon: Icons.apartment_outlined,
                          keyboardType: TextInputType.number,
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
                          controller: widget.unitNumberController,
                          icon: Icons.tag_outlined,
                          keyboardType: TextInputType.number,
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
                          controller: widget.postalCodeController,
                          icon: Icons.markunread_mailbox_outlined,
                          keyboardType: TextInputType.number,
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
                          controller: widget.cityController,
                          icon: Icons.location_city_outlined,
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
                          controller: widget.districtController,
                          icon: Icons.map_outlined,
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
                    controller: widget.addressController,
                    icon: Icons.home_outlined,
                    maxLines: 2,
                  ),
                ],
              ),

              // Save preferences
              _buildSaveToggle(
                context: context,
                value: widget.saveSenderData,
                onChanged: widget.onSaveSenderDataChanged,
                title: "حفظ بياناتي",
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
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF9B652E).withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
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

  Widget _buildQuickActionChip({
    required BuildContext context,
    required String label,
    required IconData icon,
    VoidCallback? onPressed,
  }) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.blue.withOpacity(0.3),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: Colors.blue,
                size: 16,
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.blue,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
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
    required TextEditingController controller,
    required IconData icon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: validator,
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
          borderSide: const BorderSide(
            color: Color(0xFF9B652E),
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
              ? theme.primaryColor.withOpacity(0.3)
              : Colors.grey[200]!,
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