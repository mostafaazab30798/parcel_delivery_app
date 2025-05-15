import 'package:flutter/material.dart';
import 'dart:io' show Platform;

class PaymentPage extends StatefulWidget {
  final void Function(String method)? onConfirm;
  final bool showAppBar;
  const PaymentPage({super.key, this.onConfirm, this.showAppBar = false});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  String _selected = 'cash';
  final _cardNumberController = TextEditingController();
  final _expiryController = TextEditingController();
  final _cvvController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 600;
    final padding = screenSize.width * (isSmallScreen ? 0.05 : 0.07);
    final spacing = screenSize.width * (isSmallScreen ? 0.03 : 0.04);
    final cardColor = theme.cardColor;
    final primaryColor = theme.primaryColor;

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: padding, vertical: spacing),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (widget.showAppBar)
              Padding(
                padding: EdgeInsets.only(bottom: spacing),
                child: Text('الدفع',
                    style: theme.textTheme.displayLarge,
                    textAlign: TextAlign.center),
              ),
            SizedBox(height: spacing),
            Text('اختر طريقة الدفع',
                style: theme.textTheme.displayLarge,
                textAlign: TextAlign.right),
            SizedBox(height: spacing * 2),
            _buildPaymentOption(
              context,
              value: 'cash',
              selected: _selected == 'cash',
              icon: Icons.attach_money_rounded,
              label: 'الدفع عند الاستلام',
              subtitle: 'ادفع عند استلام الشحنة',
              onTap: () => setState(() => _selected = 'cash'),
              color: Colors.orange.shade700,
            ),
            SizedBox(height: spacing * 1.5),
            _buildPaymentOption(
              context,
              value: 'app',
              selected: _selected == 'app',
              icon: Icons.phone_iphone_rounded,
              label: 'الدفع عبر التطبيق',
              subtitle: 'ادفع باستخدام إحدى الطرق الإلكترونية',
              onTap: () => setState(() => _selected = 'app'),
              color: primaryColor,
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (Platform.isIOS)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Image.asset('assets/images/apple_pay.png',
                          height: 28),
                    ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Image.asset('assets/images/mada.png', height: 28),
                  ),
                ],
              ),
            ),
            if (_selected == 'app') ...[
              SizedBox(height: spacing * 2),
              if (Platform.isIOS)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      icon: Image.asset('assets/images/apple_pay.png',
                          height: 24),
                      label: Text('الدفع عبر Apple Pay',
                          style: theme.textTheme.bodyLarge
                              ?.copyWith(color: Colors.white)),
                      onPressed: () {
                        // Apple Pay logic here
                      },
                    ),
                    SizedBox(height: spacing * 1.5),
                    Center(child: Text('أو', style: theme.textTheme.bodySmall)),
                    SizedBox(height: spacing * 1.5),
                  ],
                ),
              _buildCardInput(context, theme, primaryColor, cardColor, spacing),
            ],
            SizedBox(height: spacing * 2),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentOption(
    BuildContext context, {
    required String value,
    required bool selected,
    required IconData icon,
    required String label,
    required String subtitle,
    required VoidCallback onTap,
    required Color color,
    Widget? trailing,
  }) {
    final theme = Theme.of(context);
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 18),
        decoration: BoxDecoration(
          color: selected ? color.withOpacity(0.08) : theme.cardColor,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: selected ? color : Colors.transparent,
            width: selected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: color.withOpacity(0.13),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    label,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: color,
                      fontWeight: FontWeight.bold,
                    ),
                    textDirection: TextDirection.rtl,
                  ),
                  SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: color.withOpacity(0.7),
                    ),
                    textDirection: TextDirection.rtl,
                  ),
                ],
              ),
            ),
            if (trailing != null) ...[
              SizedBox(width: 8),
              trailing,
            ],
            Radio<String>(
              value: value,
              groupValue: _selected,
              onChanged: (_) => onTap(),
              activeColor: color,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardInput(BuildContext context, ThemeData theme,
      Color primaryColor, Color cardColor, double spacing) {
    return Container(
      padding: EdgeInsets.all(spacing * 1.2),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('بطاقة فيزا/مدى',
              style: theme.textTheme.bodyLarge?.copyWith(color: primaryColor),
              textAlign: TextAlign.right),
          SizedBox(height: spacing),
          TextField(
            controller: _cardNumberController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'رقم البطاقة',
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              prefixIcon: Icon(Icons.credit_card, color: primaryColor),
            ),
            textDirection: TextDirection.rtl,
          ),
          SizedBox(height: spacing),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _expiryController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'تاريخ الانتهاء',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                    prefixIcon: Icon(Icons.date_range, color: primaryColor),
                  ),
                  textDirection: TextDirection.rtl,
                ),
              ),
              SizedBox(width: spacing),
              Expanded(
                child: TextField(
                  controller: _cvvController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'CVV',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                    prefixIcon: Icon(Icons.lock, color: primaryColor),
                  ),
                  textDirection: TextDirection.rtl,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
