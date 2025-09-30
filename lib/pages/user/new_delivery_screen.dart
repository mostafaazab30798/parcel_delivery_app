import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../components/user/parcel_form.dart';
import '../../components/user/payment.dart';
import '../../components/user/recepient_form.dart';
import '../../components/user/sender_form.dart';
import 'choose_address_screen.dart';
import '../../models/api_shipment.dart';
import '../../models/address.dart';
import '../../blocs/shipment_api/shipment_api_bloc.dart';
import '../../blocs/shipment_api/shipment_api_event.dart';
import '../../blocs/shipment_api/shipment_api_state.dart';
import '../../blocs/payment/payment_bloc.dart';
import '../../blocs/payment/payment_event.dart';
import '../../models/payment_method.dart';
import '../../services/auth_service.dart';
import '../../services/user_data_service.dart';
import '../../services/payment_service.dart';

class NewDeliveryScreen extends StatefulWidget {
  const NewDeliveryScreen({super.key});

  @override
  State<NewDeliveryScreen> createState() => _NewDeliveryScreenState();
}

class _NewDeliveryScreenState extends State<NewDeliveryScreen>
    with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  int _currentStep = 0;

  final _senderFormKey = GlobalKey<FormState>();
  final _recipientFormKey = GlobalKey<FormState>();
  final _parcelFormKey = GlobalKey<FormState>();
  
  // Controllers for sender form
  final _senderNameController = TextEditingController();
  final _senderPhoneController = TextEditingController();
  final _senderAddressController = TextEditingController();
  final _senderShortAddressController = TextEditingController();
  final _senderBuildingNumberController = TextEditingController();
  final _senderUnitNumberController = TextEditingController();
  final _senderPostalCodeController = TextEditingController();
  final _senderCityController = TextEditingController();
  final _senderDistrictController = TextEditingController();
  
  // Controllers for recipient form
  final _recipientNameController = TextEditingController();
  final _recipientPhoneController = TextEditingController();
  final _recipientAddressController = TextEditingController();
  final _recipientShortAddressController = TextEditingController();
  final _recipientBuildingNumberController = TextEditingController();
  final _recipientUnitNumberController = TextEditingController();
  final _recipientPostalCodeController = TextEditingController();
  final _recipientCityController = TextEditingController();
  final _recipientDistrictController = TextEditingController();
  
  final AuthService _authService = AuthService();
  final UserDataService _userDataService = UserDataService.instance;
  
  bool _saveSenderData = false;
  bool _hasSavedSenderData = false;
  bool _saveRecipientData = false;
  bool _hasSavedRecipientData = false;

  String _parcelType = 'Normal';
  String _parcelNature = 'Normal';
  String _parcelSize = 'Small';
  String? _weight;
  
  bool _isSubmitting = false;
  PaymentMethod? _selectedPaymentMethod;
  double? _calculatedCost;

  // Step information for modern UI
  final List<StepInfo> _steps = [
    StepInfo(
      title: 'معلومات المرسل',
      subtitle: 'أدخل بياناتك',
      icon: Icons.person_outline,
      isCompleted: false,
    ),
    StepInfo(
      title: 'معلومات المستلم',
      subtitle: 'بيانات المرسل إليه',
      icon: Icons.location_on_outlined,
      isCompleted: false,
    ),
    StepInfo(
      title: 'تفاصيل الشحنة',
      subtitle: 'نوع وحجم الطرد',
      icon: Icons.inventory_2_outlined,
      isCompleted: false,
    ),
    StepInfo(
      title: 'الدفع والتأكيد',
      subtitle: 'اختيار طريقة الدفع',
      icon: Icons.payment_outlined,
      isCompleted: false,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
    
    _loadCurrentUser();
    _checkSavedSenderData();
    _checkSavedRecipientData();
    _createSampleAddressesIfNeeded();
  }
  
  Future<void> _createSampleAddressesIfNeeded() async {
    final addresses = await _userDataService.loadAllAddresses();
    if (addresses.isEmpty) {
      final sampleAddresses = [
        {
          'name': 'أحمد محمد',
          'phone': '0551234567',
          'shortAddress': 'RIYD2842',
          'buildingNumber': '123',
          'unitNumber': '5',
          'postalCode': '12345',
          'city': 'الرياض',
          'district': 'العليا',
          'address': 'شارع الملك فهد، بجوار مول العليا',
          'notes': '',
        },
        {
          'name': 'فاطمة أحمد',
          'phone': '0562345678',
          'shortAddress': 'JEDD4521',
          'buildingNumber': '456',
          'unitNumber': '12',
          'postalCode': '23456',
          'city': 'جدة',
          'district': 'الحمراء',
          'address': 'شارع التحلية، مجمع الأندلس',
          'notes': '',
        },
        {
          'name': 'خالد علي',
          'phone': '0573456789',
          'shortAddress': 'DMMM7893',
          'buildingNumber': '789',
          'unitNumber': '3',
          'postalCode': '34567',
          'city': 'الدمام',
          'district': 'الفيصلية',
          'address': 'طريق الملك فهد، برج الأعمال',
          'notes': '',
        },
      ];
      
      for (final address in sampleAddresses) {
        await _userDataService.addAddress(address);
        print('✅ Sample address added: ${address['name']}');
      }
      
      _checkSavedRecipientData();
    }
  }

  Future<void> _loadCurrentUser() async {
    try {
      final currentUser = await _authService.getCurrentUser();
      if (currentUser != null && mounted) {
        setState(() {
          if (_senderNameController.text.isEmpty) {
            _senderNameController.text = currentUser.userData['name'] ?? '';
          }
          if (_senderPhoneController.text.isEmpty) {
            _senderPhoneController.text = currentUser.userData['phone'] ?? '';
          }
        });
        print('📱 Loaded user data into sender form');
      }
    } catch (e) {
      print('❌ Failed to load current user: $e');
    }
  }

  Future<void> _checkSavedSenderData() async {
    final hasSaved = await _userDataService.hasSavedSenderData();
    if (mounted) {
      setState(() {
        _hasSavedSenderData = hasSaved;
      });
    }
  }

  Future<void> _checkSavedRecipientData() async {
    final addresses = await _userDataService.loadAllAddresses();
    if (mounted) {
      setState(() {
        _hasSavedRecipientData = addresses.isNotEmpty;
      });
    }
  }

  Future<void> _loadSavedSenderData() async {
    try {
      final savedData = await _userDataService.getSenderDataAsMap();
      if (savedData.isNotEmpty && mounted) {
        setState(() {
          _senderNameController.text = savedData['name'] ?? '';
          _senderPhoneController.text = savedData['phone'] ?? '';
          _senderShortAddressController.text = savedData['shortAddress'] ?? '';
          _senderBuildingNumberController.text = savedData['buildingNumber'] ?? '';
          _senderUnitNumberController.text = savedData['unitNumber'] ?? '';
          _senderPostalCodeController.text = savedData['postalCode'] ?? '';
          _senderCityController.text = savedData['city'] ?? '';
          _senderDistrictController.text = savedData['district'] ?? '';
          _senderAddressController.text = savedData['address'] ?? '';
        });
        
        _showSuccessSnackBar('تم تحميل بيانات المرسل المحفوظة');
      }
    } catch (e) {
      print('❌ Failed to load saved sender data: $e');
      _showErrorSnackBar('فشل في تحميل بيانات المرسل المحفوظة');
    }
  }

  Future<void> _loadSavedRecipientData() async {
    try {
      final savedData = await _userDataService.getRecipientDataAsMap();
      if (savedData.isNotEmpty && mounted) {
        _loadRecipientAddressData(savedData);
        _showSuccessSnackBar('تم تحميل آخر عنوان مستخدم');
      }
    } catch (e) {
      print('❌ Failed to load saved recipient data: $e');
    }
  }

  void _loadRecipientAddressData(Map<String, String> addressData) {
    setState(() {
      _recipientNameController.text = addressData['name'] ?? '';
      _recipientPhoneController.text = addressData['phone'] ?? '';
      _recipientShortAddressController.text = addressData['shortAddress'] ?? '';
      _recipientBuildingNumberController.text = addressData['buildingNumber'] ?? '';
      _recipientUnitNumberController.text = addressData['unitNumber'] ?? '';
      _recipientPostalCodeController.text = addressData['postalCode'] ?? '';
      _recipientCityController.text = addressData['city'] ?? '';
      _recipientDistrictController.text = addressData['district'] ?? '';
      _recipientAddressController.text = addressData['address'] ?? '';
    });
  }

  Future<void> _chooseFromSavedAddresses() async {
    print('🔘 Choose from saved addresses button clicked');
    
    final addresses = await _userDataService.loadAllAddresses();
    print('🔍 Available addresses: ${addresses.length}');
    
    if (addresses.isEmpty) {
      _showWarningSnackBar('لا توجد عناوين محفوظة. يرجى إنشاء شحنة أولاً لحفظ عناوين المستلمين.');
      return;
    }
    
    final selectedAddress = await Navigator.of(context).push<Map<String, String>>(
      MaterialPageRoute(
        builder: (context) => const ChooseAddressScreen(),
      ),
    );

    if (selectedAddress != null && mounted) {
      _loadRecipientAddressData(selectedAddress);
      _showSuccessSnackBar('تم تحميل العنوان المحدد');
    }
  }

  void _nextStep() {
    bool isValid = false;
    if (_currentStep == 0) {
      isValid = _senderFormKey.currentState?.validate() ?? false;
    } else if (_currentStep == 1) {
      isValid = _recipientFormKey.currentState?.validate() ?? false;
    } else if (_currentStep == 2) {
      isValid = _parcelFormKey.currentState?.validate() ?? false;
    } else {
      isValid = true;
    }
    
    if (!isValid) {
      _showErrorSnackBar('يرجى ملء جميع الحقول المطلوبة');
      return;
    }
    
    if (_currentStep < _steps.length - 1) {
      setState(() {
        _steps[_currentStep].isCompleted = true;
        _currentStep++;
      });
      
      // If moving to payment step, calculate shipping cost
      if (_currentStep == 3) {
        _calculateShippingCost();
      }
      
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOutCubic,
      );
    }
  }
  
  void _calculateShippingCost() {
    try {
      // We'll handle this in the PaymentPage widget directly since PaymentBloc is provided there
      print('✅ Shipment ready for cost calculation');
    } catch (e) {
      print('❌ Error building shipment for cost calculation: $e');
      _showErrorSnackBar('فشل في تحضير بيانات الشحنة');
    }
  }

  void _handlePaymentConfirm(PaymentMethod paymentMethod, double amount) {
    setState(() {
      _selectedPaymentMethod = paymentMethod;
      _calculatedCost = amount;
    });
    _submitShipment();
  }

  String _getApiPaymentMethod(PaymentMethod? paymentMethod) {
    if (paymentMethod == null) {
      return 'payment_on_delivery'; // Default to cash on delivery
    }
    
    switch (paymentMethod.type) {
      case PaymentMethodType.cash:
        return 'payment_on_delivery';
      case PaymentMethodType.card:
      case PaymentMethodType.mada:
      case PaymentMethodType.applePay:
      case PaymentMethodType.stcPay:
        return 'bank_card';
    }
  }

  /// Build shipment for cost calculation (always uses default payment method)
  ApiShipment _buildShipmentForCostCalculation() {
    return ApiShipment(
      sender: Sender(
        name: _senderNameController.text.trim(),
        phone: _senderPhoneController.text.trim(),
        address: Address(
          shortCode: _senderShortAddressController.text.trim(),
          national: NationalAddress(
            buildingNumber: _senderBuildingNumberController.text.trim(),
            street: _senderUnitNumberController.text.trim(),
            district: _senderDistrictController.text.trim(),
            city: _senderCityController.text.trim(),
            region: _senderCityController.text.trim(),
            postalCode: _senderPostalCodeController.text.trim(),
          ),
        ),
        notes: _senderAddressController.text.trim().isEmpty 
            ? null 
            : _senderAddressController.text.trim(),
      ),
      recipient: Recipient(
        name: _recipientNameController.text.trim(),
        phone: _recipientPhoneController.text.trim(),
        address: Address(
          shortCode: _recipientShortAddressController.text.trim(),
          national: NationalAddress(
            buildingNumber: _recipientBuildingNumberController.text.trim(),
            street: _recipientUnitNumberController.text.trim(),
            district: _recipientDistrictController.text.trim(),
            city: _recipientCityController.text.trim(),
            region: _recipientCityController.text.trim(),
            postalCode: _recipientPostalCodeController.text.trim(),
          ),
        ),
        notes: _recipientAddressController.text.trim().isEmpty 
            ? null 
            : _recipientAddressController.text.trim(),
      ),
      shipmentType: _parcelType,
      weight: _weight != null ? double.tryParse(_weight!) : null,
      nature: _parcelNature,
      paymentMethod: 'payment_on_delivery', // Default for cost calculation
    );
  }

  ApiShipment _buildShipment() {
    final paymentMethod = _getApiPaymentMethod(_selectedPaymentMethod);
    print('🔍 Building shipment with payment method: $paymentMethod');
    print('🔍 Selected payment method: $_selectedPaymentMethod');
    
    return ApiShipment(
      sender: Sender(
        name: _senderNameController.text.trim(),
        phone: _senderPhoneController.text.trim(),
        address: Address(
          shortCode: _senderShortAddressController.text.trim(),
          national: NationalAddress(
            buildingNumber: _senderBuildingNumberController.text.trim(),
            street: _senderUnitNumberController.text.trim(),
            district: _senderDistrictController.text.trim(),
            city: _senderCityController.text.trim(),
            region: _senderCityController.text.trim(),
            postalCode: _senderPostalCodeController.text.trim(),
          ),
        ),
        notes: _senderAddressController.text.trim().isEmpty 
            ? null 
            : _senderAddressController.text.trim(),
      ),
      recipient: Recipient(
        name: _recipientNameController.text.trim(),
        phone: _recipientPhoneController.text.trim(),
        address: Address(
          shortCode: _recipientShortAddressController.text.trim(),
          national: NationalAddress(
            buildingNumber: _recipientBuildingNumberController.text.trim(),
            street: _recipientUnitNumberController.text.trim(),
            district: _recipientDistrictController.text.trim(),
            city: _recipientCityController.text.trim(),
            region: _recipientCityController.text.trim(),
            postalCode: _recipientPostalCodeController.text.trim(),
          ),
        ),
        notes: _recipientAddressController.text.trim().isEmpty 
            ? null 
            : _recipientAddressController.text.trim(),
      ),
      shipmentType: _parcelType,
      weight: _weight != null ? double.tryParse(_weight!) : null,
      nature: _parcelNature,
      paymentMethod: paymentMethod,
    );
  }

  Future<void> _submitShipment() async {
    if (_isSubmitting) return;
    
    setState(() => _isSubmitting = true);
    
    try {
      if (_saveSenderData) {
        final success = await _userDataService.saveSenderDataFromMap(
          name: _senderNameController.text.trim(),
          phone: _senderPhoneController.text.trim(),
          shortAddress: _senderShortAddressController.text.trim(),
          buildingNumber: _senderBuildingNumberController.text.trim(),
          unitNumber: _senderUnitNumberController.text.trim(),
          postalCode: _senderPostalCodeController.text.trim(),
          city: _senderCityController.text.trim(),
          district: _senderDistrictController.text.trim(),
          address: _senderAddressController.text.trim(),
        );
        
        if (success) {
          print('✅ Sender data saved successfully');
          setState(() => _hasSavedSenderData = true);
        }
      }
      
      if (_saveRecipientData) {
        final recipientAddressData = {
          'name': _recipientNameController.text.trim(),
          'phone': _recipientPhoneController.text.trim(),
          'shortAddress': _recipientShortAddressController.text.trim(),
          'buildingNumber': _recipientBuildingNumberController.text.trim(),
          'unitNumber': _recipientUnitNumberController.text.trim(),
          'postalCode': _recipientPostalCodeController.text.trim(),
          'city': _recipientCityController.text.trim(),
          'district': _recipientDistrictController.text.trim(),
          'address': _recipientAddressController.text.trim(),
          'notes': '',
        };
        
        final success = await _userDataService.addAddress(recipientAddressData);
        
        if (success) {
          print('✅ Recipient address saved successfully');
          setState(() => _hasSavedRecipientData = true);
        }
      }
      
      final shipment = _buildShipment();
      
      context.read<ShipmentApiBloc>().add(
        ShipmentApiCreateRequested(shipment),
      );
      
    } catch (e) {
      setState(() => _isSubmitting = false);
      _showErrorSnackBar('خطأ في إنشاء الشحنة: $e');
    }
  }

  Future<void> _processPayment(String trackingNumber, PaymentMethod paymentMethod, double amount) async {
    try {
      final paymentService = PaymentService();
      final result = await paymentService.processPayment(
        trackingNumber: trackingNumber,
        paymentMethod: paymentMethod,
        amount: amount,
      );
      
      if (result.success) {
        _showSuccessSnackBar('تم إنشاء الشحنة ومعالجة الدفع بنجاح!');
        _navigateHome();
      } else {
        _showErrorSnackBar('تم إنشاء الشحنة ولكن فشل في معالجة الدفع: ${result.errorMessage}');
        _navigateHome();
      }
    } catch (e) {
      print('❌ Payment processing error: $e');
      _showErrorSnackBar('تم إنشاء الشحنة ولكن حدث خطأ في الدفع');
      _navigateHome();
    }
  }

  void _navigateHome() {
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        if (Navigator.of(context).canPop()) {
          context.pop();
        } else {
          context.go('/user-home');
        }
      }
    });
  }

  void _prevStep() {
    if (_currentStep > 0) {
      setState(() {
        _steps[_currentStep - 1].isCompleted = false;
        _currentStep--;
      });
      _pageController.previousPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Expanded(child: Text(message, style: const TextStyle(fontSize: 14))),
          ],
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Expanded(child: Text(message, style: const TextStyle(fontSize: 14))),
          ],
        ),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  void _showWarningSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.warning, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                message,
                textAlign: TextAlign.right,
                style: const TextStyle(fontFamily: 'Cairo', fontSize: 14),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.orange,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final steps = [
      SenderForm(
        formKey: _senderFormKey,
        nameController: _senderNameController,
        phoneController: _senderPhoneController,
        addressController: _senderAddressController,
        shortAddressController: _senderShortAddressController,
        buildingNumberController: _senderBuildingNumberController,
        unitNumberController: _senderUnitNumberController,
        postalCodeController: _senderPostalCodeController,
        cityController: _senderCityController,
        districtController: _senderDistrictController,
        saveSenderData: _saveSenderData,
        onSaveSenderDataChanged: (value) => setState(() => _saveSenderData = value),
        onLoadSavedData: _loadSavedSenderData,
        hasSavedData: _hasSavedSenderData,
      ),
      RecipientForm(
        formKey: _recipientFormKey,
        nameController: _recipientNameController,
        phoneController: _recipientPhoneController,
        addressController: _recipientAddressController,
        shortAddressController: _recipientShortAddressController,
        buildingNumberController: _recipientBuildingNumberController,
        unitNumberController: _recipientUnitNumberController,
        postalCodeController: _recipientPostalCodeController,
        cityController: _recipientCityController,
        districtController: _recipientDistrictController,
        saveRecipientData: _saveRecipientData,
        onSaveRecipientDataChanged: (value) => setState(() => _saveRecipientData = value),
        onLoadSavedData: _loadSavedRecipientData,
        hasSavedData: _hasSavedRecipientData,
        onChooseAddress: _chooseFromSavedAddresses,
      ),
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
      BlocProvider<PaymentBloc>(
        create: (context) {
          final bloc = PaymentBloc(paymentService: PaymentService());
          // Trigger cost calculation when payment bloc is created
          Future.microtask(() {
            bloc.add(PaymentCostCalculationRequested(_buildShipmentForCostCalculation()));
          });
          return bloc;
        },
        child: PaymentPage(
          onConfirm: (paymentMethod, amount) => _handlePaymentConfirm(paymentMethod, amount),
          showAppBar: false,
        ),
      ),
    ];

    return MultiBlocListener(
      listeners: [
        BlocListener<ShipmentApiBloc, ShipmentApiState>(
          listener: (context, state) {
            setState(() => _isSubmitting = false);
            
            if (state is ShipmentApiSuccess) {
              // Process payment if needed
              if (_selectedPaymentMethod != null && 
                  _calculatedCost != null && 
                  state.shipments.isNotEmpty) {
                _processPayment(state.shipments.first.trackingNumber ?? '', 
                              _selectedPaymentMethod!, 
                              _calculatedCost!);
              } else {
                _showSuccessSnackBar('تم إنشاء الشحنة بنجاح!');
                _navigateHome();
              }
            } else if (state is ShipmentApiFailure) {
              _showErrorSnackBar('خطأ في إنشاء الشحنة: ${state.message}');
            }
          },
        ),
      ],
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Column(
              children: [
                // Clean App Bar
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: theme.cardColor,
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
                      IconButton(
                        onPressed: () => context.pop(),
                        icon: Icon(
                          Icons.arrow_back_ios_rounded,
                          color: const Color(0xFF9B652E),
                          size: 20,
                        ),
                        style: IconButton.styleFrom(
                          backgroundColor: const Color(0xFF9B652E).withOpacity(0.1),
                          padding: const EdgeInsets.all(8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'إنشاء شحنة جديدة',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF222831),
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              _steps[_currentStep].subtitle,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: const Color(0xFF8B572A),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF9B652E).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          _steps[_currentStep].icon,
                          color: const Color(0xFF9B652E),
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                ),

                // Compact Progress Indicator
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  child: CompactProgressIndicator(
                    steps: _steps,
                    currentStep: _currentStep,
                    primaryColor: const Color(0xFF9B652E),
                  ),
                ),

                // Content
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    children: steps,
                  ),
                ),

                // Clean Navigation Buttons
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: theme.cardColor,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.03),
                        blurRadius: 8,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      if (_currentStep > 0)
                        Expanded(
                          child: OutlinedButton(
                            onPressed: _prevStep,
                            style: OutlinedButton.styleFrom(
                              foregroundColor: const Color(0xFF9B652E),
                              side: BorderSide(color: const Color(0xFF9B652E).withOpacity(0.5)),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              'السابق',
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                      if (_currentStep > 0) const SizedBox(width: 12),
                      Expanded(
                        flex: _currentStep == 0 ? 1 : 2,
                        child: ElevatedButton(
                          onPressed: _isSubmitting 
                              ? null 
                              : (_currentStep == steps.length - 1
                                  ? _submitShipment
                                  : _nextStep),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF9B652E),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          child: _isSubmitting
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : Text(
                                  _currentStep == steps.length - 1 
                                      ? 'تأكيد الشحنة' 
                                      : 'التالي',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  @override
  void dispose() {
    _animationController.dispose();
    _senderNameController.dispose();
    _senderPhoneController.dispose();
    _senderAddressController.dispose();
    _senderShortAddressController.dispose();
    _senderBuildingNumberController.dispose();
    _senderUnitNumberController.dispose();
    _senderPostalCodeController.dispose();
    _senderCityController.dispose();
    _senderDistrictController.dispose();
    _recipientNameController.dispose();
    _recipientPhoneController.dispose();
    _recipientAddressController.dispose();
    _recipientShortAddressController.dispose();
    _recipientBuildingNumberController.dispose();
    _recipientUnitNumberController.dispose();
    _recipientPostalCodeController.dispose();
    _recipientCityController.dispose();
    _recipientDistrictController.dispose();
    _pageController.dispose();
    _authService.dispose();
    super.dispose();
  }
}

// Step Information Model
class StepInfo {
  final String title;
  final String subtitle;
  final IconData icon;
  bool isCompleted;

  StepInfo({
    required this.title,
    required this.subtitle,
    required this.icon,
    this.isCompleted = false,
  });
}

// Compact Progress Indicator Widget
class CompactProgressIndicator extends StatelessWidget {
  final List<StepInfo> steps;
  final int currentStep;
  final Color primaryColor;

  const CompactProgressIndicator({
    super.key,
    required this.steps,
    required this.currentStep,
    required this.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Progress bar
        Container(
          height: 6,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(3),
          ),
          child: Stack(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeInOutCubic,
                height: 6,
                width: MediaQuery.of(context).size.width * 
                    ((currentStep + 1) / steps.length),
                decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        
        // Step indicators - more compact
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(steps.length, (index) {
            final step = steps[index];
            final isActive = index <= currentStep;
            final isCurrent = index == currentStep;
            
            return Expanded(
              child: Column(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: step.isCompleted
                          ? primaryColor
                          : (isActive 
                              ? primaryColor.withOpacity(0.15)
                              : Colors.grey[100]),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: isActive ? primaryColor : Colors.grey[300]!,
                        width: isCurrent ? 2 : 1,
                      ),
                    ),
                    child: Icon(
                      step.isCompleted 
                          ? Icons.check_rounded
                          : step.icon,
                      color: step.isCompleted
                          ? Colors.white
                          : (isActive ? primaryColor : Colors.grey[500]),
                      size: 16,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    step.title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: isCurrent ? FontWeight.w600 : FontWeight.w500,
                      color: isActive ? primaryColor : Colors.grey[600],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            );
          }),
        ),
      ],
    );
  }
}