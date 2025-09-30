import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/payment_method.dart';
import '../../blocs/payment/payment_bloc.dart';
import '../../blocs/payment/payment_event.dart';
import '../../blocs/payment/payment_state.dart';

/// Custom formatter for credit card numbers (adds spaces every 4 digits)
class CardNumberInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Remove all non-digit characters
    final digitsOnly = newValue.text.replaceAll(RegExp(r'\D'), '');
    
    // Limit to 16 digits
    final limitedDigits = digitsOnly.length > 16 
        ? digitsOnly.substring(0, 16) 
        : digitsOnly;
    
    // Add spaces every 4 digits
    String formatted = '';
    for (int i = 0; i < limitedDigits.length; i++) {
      if (i > 0 && i % 4 == 0) {
        formatted += ' ';
      }
      formatted += limitedDigits[i];
    }
    
    // Calculate cursor position based on the number of digits entered
    int cursorPosition = formatted.length;
    
    // If we're at a position where a space should be added, move cursor after it
    if (limitedDigits.isNotEmpty && limitedDigits.length % 4 == 0 && limitedDigits.length < 16) {
      cursorPosition = formatted.length;
    }
    
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: cursorPosition),
    );
  }
}

/// Custom formatter for expiry date (MM/YY format)
class ExpiryDateInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Remove all non-digit characters
    final digitsOnly = newValue.text.replaceAll(RegExp(r'\D'), '');
    
    // Limit to 4 digits
    final limitedDigits = digitsOnly.length > 4 
        ? digitsOnly.substring(0, 4) 
        : digitsOnly;
    
    // Format as MM/YY
    String formatted = '';
    for (int i = 0; i < limitedDigits.length; i++) {
      if (i == 2) {
        formatted += '/';
      }
      formatted += limitedDigits[i];
    }
    
    // Calculate cursor position
    int cursorPosition = formatted.length;
    
    // If we just added the slash (after 2nd digit), position cursor after it
    if (limitedDigits.length == 2) {
      cursorPosition = formatted.length;
    }
    
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: cursorPosition),
    );
  }
}

class PaymentPage extends StatefulWidget {
  final void Function(PaymentMethod paymentMethod, double amount)? onConfirm;
  final bool showAppBar;
  const PaymentPage({super.key, this.onConfirm, this.showAppBar = false});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  PaymentMethodType _selectedPaymentMethod = PaymentMethodType.cash;
  final _cardNumberController = TextEditingController();
  final _expiryController = TextEditingController();
  final _cvvController = TextEditingController();
  final _cardHolderController = TextEditingController();
  bool _isProcessingPayment = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 600;
    final padding = screenSize.width * (isSmallScreen ? 0.05 : 0.07);
    final spacing = screenSize.width * (isSmallScreen ? 0.03 : 0.04);
    final cardColor = const Color(0xFFFFFAF3);
    final primaryColor = const Color(0xFF9B652E);

    return BlocBuilder<PaymentBloc, PaymentState>(
      builder: (context, state) {
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
                
                // Cost display
                if (state is PaymentMethodSelection) 
                  Container(
                    margin: EdgeInsets.only(bottom: spacing * 2),
                    padding: EdgeInsets.all(spacing * 1.5),
                    decoration: BoxDecoration(
                      color: primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: primaryColor.withOpacity(0.3)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'إجمالي التكلفة',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: primaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          '${state.shippingCost.toStringAsFixed(2)} ريال',
                          style: theme.textTheme.titleLarge?.copyWith(
                            color: primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                
                if (state is PaymentCostCalculating)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(32.0),
                      child: CircularProgressIndicator(),
                    ),
                  ),
                
                if (state is PaymentMethodSelection) ...[
                  // Cash payment option
                  _buildPaymentOption(
                    context,
                    paymentType: PaymentMethodType.cash,
                    selected: _selectedPaymentMethod == PaymentMethodType.cash,
                    icon: Icons.attach_money_rounded,
                    label: 'الدفع عند الاستلام',
                    subtitle: 'ادفع عند استلام الشحنة',
                    onTap: () => _selectPaymentMethod(PaymentMethodType.cash),
                    color: const Color(0xFF8B572A),
                  ),
                  SizedBox(height: spacing * 1.5),
                  
                  // Card payment option
                  if (state.availablePaymentMethods.contains(PaymentMethodType.card) ||
                      state.availablePaymentMethods.contains(PaymentMethodType.mada))
                    _buildPaymentOption(
                      context,
                      paymentType: PaymentMethodType.card,
                      selected: _selectedPaymentMethod == PaymentMethodType.card || 
                                _selectedPaymentMethod == PaymentMethodType.mada,
                      icon: Icons.credit_card_rounded,
                      label: 'بطاقة فيزا/مدى',
                      subtitle: 'ادفع باستخدام بطاقتك الائتمانية',
                      onTap: () => _selectPaymentMethod(PaymentMethodType.card),
                      color: primaryColor,
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: Image.asset('assets/images/mada.png', height: 28),
                          ),
                        ],
                      ),
                    ),
                  
                  if (state.availablePaymentMethods.contains(PaymentMethodType.card) ||
                      state.availablePaymentMethods.contains(PaymentMethodType.mada))
                    SizedBox(height: spacing * 1.5),
                  
                  // Apple Pay option (iOS only)
                  if (state.availablePaymentMethods.contains(PaymentMethodType.applePay))
                    _buildPaymentOption(
                      context,
                      paymentType: PaymentMethodType.applePay,
                      selected: _selectedPaymentMethod == PaymentMethodType.applePay,
                      icon: Icons.phone_iphone_rounded,
                      label: 'Apple Pay',
                      subtitle: 'ادفع باستخدام Apple Pay',
                      onTap: () => _selectPaymentMethod(PaymentMethodType.applePay),
                      color: Colors.black,
                      trailing: Image.asset('assets/images/apple_pay.png', height: 28),
                    ),
                  
                  if (state.availablePaymentMethods.contains(PaymentMethodType.applePay))
                    SizedBox(height: spacing * 1.5),
                  
                  // Card input form
                  if (_selectedPaymentMethod == PaymentMethodType.card || 
                      _selectedPaymentMethod == PaymentMethodType.mada) ...[
                    SizedBox(height: spacing * 2),
                    _buildCardInput(context, theme, primaryColor, cardColor, spacing),
                  ],
                  
                  // Confirm button
                  SizedBox(height: spacing * 2),
                  ElevatedButton(
                    onPressed: _isProcessingPayment ? null : () => _confirmPayment(state.shippingCost),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: _isProcessingPayment
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : Text(
                            'تأكيد الدفع',
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ],
                
                if (state is PaymentProcessing)
                  Container(
                    padding: EdgeInsets.all(spacing * 2),
                    child: Column(
                      children: [
                        const CircularProgressIndicator(),
                        SizedBox(height: spacing),
                        Text(
                          'جاري معالجة الدفع...',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: primaryColor,
                          ),
                        ),
                        Text(
                          'المبلغ: ${state.amount.toStringAsFixed(2)} ريال',
                          style: theme.textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                
                if (state is PaymentFailure)
                  Container(
                    margin: EdgeInsets.only(top: spacing * 2),
                    padding: EdgeInsets.all(spacing * 1.5),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.red.withOpacity(0.3)),
                    ),
                    child: Column(
                      children: [
                        Icon(Icons.error_outline, color: Colors.red, size: 32),
                        SizedBox(height: spacing),
                        Text(
                          'فشل في معالجة الدفع',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: Colors.red,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          state.message,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: Colors.red.shade700,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: spacing),
                        ElevatedButton(
                          onPressed: () {
                            context.read<PaymentBloc>().add(const PaymentReset());
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('إعادة المحاولة'),
                        ),
                      ],
                    ),
                  ),
                
                SizedBox(height: spacing * 2),
              ],
            ),
          ),
        );
      },
    );
  }

  void _selectPaymentMethod(PaymentMethodType paymentMethod) {
    setState(() {
      _selectedPaymentMethod = paymentMethod;
    });
    context.read<PaymentBloc>().add(PaymentMethodSelected(paymentMethod));
  }

  void _confirmPayment(double amount) {
    if (widget.onConfirm == null) return;
    
    setState(() {
      _isProcessingPayment = true;
    });
    
    PaymentMethod paymentMethod;
    
    switch (_selectedPaymentMethod) {
      case PaymentMethodType.cash:
        paymentMethod = PaymentMethod.cash();
        break;
      case PaymentMethodType.card:
      case PaymentMethodType.mada:
        // Remove spaces from card number for validation
        final cleanCardNumber = _cardNumberController.text.replaceAll(' ', '');
        
        if (cleanCardNumber.isEmpty || 
            _expiryController.text.isEmpty || 
            _cvvController.text.isEmpty) {
          setState(() {
            _isProcessingPayment = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('يرجى إدخال بيانات البطاقة كاملة'),
              backgroundColor: Colors.red,
            ),
          );
          return;
        }
        
        // Validate card number length (should be 16 digits)
        if (cleanCardNumber.length != 16) {
          setState(() {
            _isProcessingPayment = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('رقم البطاقة يجب أن يكون 16 رقم'),
              backgroundColor: Colors.red,
            ),
          );
          return;
        }
        
        // Validate expiry date format (should be MM/YY)
        if (_expiryController.text.length != 5 || !_expiryController.text.contains('/')) {
          setState(() {
            _isProcessingPayment = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('تاريخ الانتهاء يجب أن يكون بصيغة MM/YY'),
              backgroundColor: Colors.red,
            ),
          );
          return;
        }
        
        // Validate CVV length (should be 3 or 4 digits)
        if (_cvvController.text.length < 3 || _cvvController.text.length > 4) {
          setState(() {
            _isProcessingPayment = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('CVV يجب أن يكون 3 أو 4 أرقام'),
              backgroundColor: Colors.red,
            ),
          );
          return;
        }
        
        paymentMethod = PaymentMethod.card(
          cardNumber: cleanCardNumber, // Use clean card number without spaces
          expiryDate: _expiryController.text,
          cvv: _cvvController.text,
          cardHolderName: _cardHolderController.text.isEmpty 
              ? null 
              : _cardHolderController.text,
          amount: amount,
        );
        break;
      case PaymentMethodType.applePay:
        paymentMethod = PaymentMethod.applePay(amount: amount);
        break;
      case PaymentMethodType.stcPay:
        paymentMethod = PaymentMethod(type: PaymentMethodType.stcPay, amount: amount);
        break;
    }
    
    widget.onConfirm!(paymentMethod, amount);
    
    setState(() {
      _isProcessingPayment = false;
    });
  }

  Widget _buildPaymentOption(
    BuildContext context, {
    required PaymentMethodType paymentType,
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
          color: selected ? color.withOpacity(0.08) : const Color(0xFFFFFAF3),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: selected ? color : const Color(0xFF9B652E).withOpacity(0.2),
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
                color: const Color(0xFF9B652E).withOpacity(0.13),
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
                      color: const Color(0xFF9B652E).withOpacity(0.7),
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
            Radio<PaymentMethodType>(
              value: paymentType,
              groupValue: _selectedPaymentMethod,
              onChanged: (_) => onTap(),
              activeColor: const Color(0xFF9B652E),
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
            controller: _cardHolderController,
            decoration: InputDecoration(
              labelText: 'اسم حامل البطاقة (اختياري)',
              labelStyle: TextStyle(color: const Color(0xFF8B572A)),
              filled: true,
              fillColor: const Color(0xFFFFFAF3),
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
                borderSide: BorderSide(color: const Color(0xFF9B652E), width: 2),
              ),
              prefixIcon: Icon(Icons.person, color: const Color(0xFF9B652E)),
            ),
            textDirection: TextDirection.rtl,
          ),
          SizedBox(height: spacing),
          TextField(
            controller: _cardNumberController,
            keyboardType: TextInputType.number,
            inputFormatters: [
              CardNumberInputFormatter(),
            ],
            decoration: InputDecoration(
              labelText: 'رقم البطاقة *',
              hintText: '1234 5678 9012 3456',
              labelStyle: TextStyle(color: const Color(0xFF8B572A)),
              hintStyle: TextStyle(color: const Color(0xFF8B572A).withOpacity(0.5)),
              filled: true,
              fillColor: const Color(0xFFFFFAF3),
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
                borderSide: BorderSide(color: const Color(0xFF9B652E), width: 2),
              ),
              prefixIcon: Icon(Icons.credit_card, color: const Color(0xFF9B652E)),
            ),
            textDirection: TextDirection.ltr,
          ),
          SizedBox(height: spacing),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _expiryController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    ExpiryDateInputFormatter(),
                  ],
                  decoration: InputDecoration(
                    labelText: 'تاريخ الانتهاء *',
                    hintText: 'MM/YY',
                    labelStyle: TextStyle(color: const Color(0xFF8B572A)),
                    hintStyle: TextStyle(color: const Color(0xFF8B572A).withOpacity(0.5)),
                    filled: true,
                    fillColor: const Color(0xFFFFFAF3),
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
                      borderSide: BorderSide(color: const Color(0xFF9B652E), width: 2),
                    ),
                    prefixIcon: Icon(Icons.date_range, color: const Color(0xFF9B652E)),
                  ),
                  textDirection: TextDirection.ltr,
                ),
              ),
              SizedBox(width: spacing),
              Expanded(
                child: TextField(
                  controller: _cvvController,
                  keyboardType: TextInputType.number,
                  obscureText: true,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(4), // CVV can be 3 or 4 digits
                  ],
                  decoration: InputDecoration(
                    labelText: 'CVV *',
                    hintText: '123',
                    labelStyle: TextStyle(color: const Color(0xFF8B572A)),
                    hintStyle: TextStyle(color: const Color(0xFF8B572A).withOpacity(0.5)),
                    filled: true,
                    fillColor: const Color(0xFFFFFAF3),
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
                      borderSide: BorderSide(color: const Color(0xFF9B652E), width: 2),
                    ),
                    prefixIcon: Icon(Icons.lock, color: const Color(0xFF9B652E)),
                  ),
                  textDirection: TextDirection.ltr,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
