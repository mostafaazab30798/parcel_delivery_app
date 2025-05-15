import 'package:flutter/material.dart';

import '../../components/user/parcel_form.dart';
import '../../components/user/payment.dart';
import '../../components/user/recepient_form.dart';

class NewDeliveryScreen extends StatefulWidget {
  const NewDeliveryScreen({super.key});

  @override
  State<NewDeliveryScreen> createState() => _NewDeliveryScreenState();
}

class _NewDeliveryScreenState extends State<NewDeliveryScreen> {
  final PageController _pageController = PageController();
  int _currentStep = 0;

  final _recipientFormKey = GlobalKey<FormState>();
  final _parcelFormKey = GlobalKey<FormState>();

  String _parcelType = 'Document';
  String _parcelNature = 'Regular';
  String _parcelSize = 'Small';
  String? _weight;

  void _nextStep() {
    if (_currentStep < 3) {
      setState(() => _currentStep++);
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    }
  }

  void _prevStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 600;
    final padding = screenSize.width * (isSmallScreen ? 0.05 : 0.07);
    final spacing = screenSize.width * (isSmallScreen ? 0.03 : 0.04);

    final steps = [
      RecipientForm(formKey: _recipientFormKey),
      ParcelForm(
        formKey: _parcelFormKey,
        parcelType: _parcelType,
        onParcelTypeChanged: (val) => setState(() => _parcelType = val),
        weight: _weight,
        onWeightChanged: (val) => setState(() => _weight = val),
        parcelSize: _parcelSize,
        onParcelSizeChanged: (val) => setState(() => _parcelSize = val),
        parcelNature: _parcelNature,
        onParcelNatureChanged: (val) => setState(() => _parcelNature = val),
      ),
      PaymentPage(
        onConfirm: (method) {
          // Handle payment confirmation
        },
        showAppBar: true,
      ),
    ];

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
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
            Text('إضافة شحنة جديدة'),
          ],
        ),
      ),
      body: Column(
        children: [
          SizedBox(height: spacing * 2),
          _ProgressIndicator(
            currentStep: _currentStep,
            totalSteps: steps.length,
            color: theme.primaryColor,
            inactiveColor: theme.dividerColor,
          ),
          SizedBox(height: spacing * 2),
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: steps,
            ),
          ),
          SizedBox(height: spacing),
          Row(
            children: [
              if (_currentStep > 0)
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: padding),
                    child: OutlinedButton(
                      onPressed: _prevStep,
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: spacing * 1.2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        side: BorderSide(color: theme.primaryColor),
                      ),
                      child: Text(
                        'عودة',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: theme.primaryColor,
                        ),
                      ),
                    ),
                  ),
                ),
              if (_currentStep > 0) SizedBox(width: spacing),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: padding),
                  child: ElevatedButton(
                    onPressed: _currentStep == steps.length - 1
                        ? () {
                            // Confirmation logic
                          }
                        : _nextStep,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.primaryColor,
                      padding: EdgeInsets.symmetric(vertical: spacing * 1.2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      _currentStep == steps.length - 1 ? 'تأكيد' : 'التالي',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: spacing * 2),
        ],
      ),
    );
  }
}

class _ProgressIndicator extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final Color color;
  final Color inactiveColor;

  const _ProgressIndicator({
    required this.currentStep,
    required this.totalSteps,
    required this.color,
    required this.inactiveColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(totalSteps, (index) {
        final isActive = index <= currentStep;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 6),
          width: isActive ? 32 : 16,
          height: 8,
          decoration: BoxDecoration(
            color: isActive ? color : inactiveColor,
            borderRadius: BorderRadius.circular(6),
          ),
        );
      }),
    );
  }
}
