import 'package:flutter/material.dart';

class CalculatePrice extends StatefulWidget {
  const CalculatePrice({super.key});

  @override
  State<CalculatePrice> createState() => _CalculatePriceState();
}

class _CalculatePriceState extends State<CalculatePrice>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  late AnimationController _animationController;
  late AnimationController _priceAnimationController;
  late Animation<double> _slideAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  int _currentStep = 0;
  String _parcelType = "Document";
  String _parcelSize = "Small";
  String _parcelNature = "Normal";
  String _weight = "";
  String? _fromCity;
  String? _toCity;
  double _estimatedPrice = 0.0;

  // List of available "from" cities
  final List<String> _fromCities = [
    'الرياض',
    'جدة',
    'مكة',
    'المدينة_المنورة',
    'الدمام',
    'الطائف'
  ];

  // Available destinations for each city
  List<String> _getDestinationsForCity(String? city) {
    if (city == null) return [];
    return _priceMatrix[city]?.keys.where((key) => key != 'local').toList() ??
        [];
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _priceAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _slideAnimation = Tween<double>(
      begin: 50.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _priceAnimationController,
      curve: Curves.bounceOut,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _priceAnimationController.dispose();
    super.dispose();
  }

  // Complete pricing data structure from the JSON file
  final Map<String, Map<String, Map<String, double>>> _priceMatrix = {
    'الرياض': {
      'local': {'small': 15, 'medium': 22, 'large': 35},
      'جدة': {'small': 45, 'medium': 65, 'large': 95},
      'مكة': {'small': 42, 'medium': 62, 'large': 90},
      'المدينة_المنورة': {'small': 40, 'medium': 60, 'large': 88},
      'الدمام': {'small': 25, 'medium': 38, 'large': 58},
      'الطائف': {'small': 38, 'medium': 55, 'large': 82},
      'أبها': {'small': 48, 'medium': 72, 'large': 105},
      'تبوك': {'small': 55, 'medium': 82, 'large': 125},
      'القصيم': {'small': 22, 'medium': 32, 'large': 48},
      'حائل': {'small': 32, 'medium': 48, 'large': 72},
      'نجران': {'small': 45, 'medium': 68, 'large': 98},
      'جازان': {'small': 52, 'medium': 78, 'large': 118},
      'الجوف': {'small': 55, 'medium': 85, 'large': 128},
      'الباحة': {'small': 38, 'medium': 58, 'large': 85},
      'ينبع': {'small': 48, 'medium': 72, 'large': 105},
      'الجبيل': {'small': 28, 'medium': 42, 'large': 65},
      'خميس_مشيط': {'small': 50, 'medium': 75, 'large': 110},
      'الخرج': {'small': 18, 'medium': 28, 'large': 42},
      'القطيف': {'small': 26, 'medium': 40, 'large': 62},
      'حفر_الباطن': {'small': 30, 'medium': 45, 'large': 68}
    },
    'جدة': {
      'local': {'small': 15, 'medium': 22, 'large': 35},
      'الرياض': {'small': 45, 'medium': 65, 'large': 95},
      'مكة': {'small': 18, 'medium': 28, 'large': 42},
      'المدينة_المنورة': {'small': 26, 'medium': 40, 'large': 62},
      'الدمام': {'small': 55, 'medium': 85, 'large': 128},
      'الطائف': {'small': 20, 'medium': 30, 'large': 45},
      'أبها': {'small': 32, 'medium': 48, 'large': 72},
      'تبوك': {'small': 48, 'medium': 72, 'large': 105},
      'القصيم': {'small': 52, 'medium': 78, 'large': 118},
      'حائل': {'small': 38, 'medium': 58, 'large': 85},
      'نجران': {'small': 42, 'medium': 65, 'large': 95},
      'جازان': {'small': 35, 'medium': 52, 'large': 78},
      'الجوف': {'small': 60, 'medium': 92, 'large': 135},
      'الباحة': {'small': 24, 'medium': 38, 'large': 58},
      'ينبع': {'small': 22, 'medium': 32, 'large': 48},
      'الجبيل': {'small': 58, 'medium': 88, 'large': 132},
      'خميس_مشيط': {'small': 33, 'medium': 50, 'large': 75},
      'الخرج': {'small': 48, 'medium': 72, 'large': 105},
      'القطيف': {'small': 56, 'medium': 85, 'large': 128},
      'حفر_الباطن': {'small': 58, 'medium': 88, 'large': 132}
    },
    'مكة': {
      'local': {'small': 15, 'medium': 22, 'large': 35},
      'الرياض': {'small': 42, 'medium': 62, 'large': 90},
      'جدة': {'small': 18, 'medium': 28, 'large': 42},
      'المدينة_المنورة': {'small': 24, 'medium': 38, 'large': 58},
      'الدمام': {'small': 52, 'medium': 78, 'large': 118},
      'الطائف': {'small': 18, 'medium': 28, 'large': 42},
      'أبها': {'small': 32, 'medium': 48, 'large': 72},
      'تبوك': {'small': 48, 'medium': 72, 'large': 105},
      'القصيم': {'small': 50, 'medium': 75, 'large': 112},
      'حائل': {'small': 40, 'medium': 60, 'large': 88},
      'نجران': {'small': 42, 'medium': 65, 'large': 95},
      'جازان': {'small': 32, 'medium': 48, 'large': 72},
      'الجوف': {'small': 58, 'medium': 88, 'large': 132},
      'الباحة': {'small': 22, 'medium': 32, 'large': 48},
      'ينبع': {'small': 24, 'medium': 38, 'large': 58},
      'الجبيل': {'small': 56, 'medium': 85, 'large': 128},
      'خميس_مشيط': {'small': 33, 'medium': 50, 'large': 75},
      'الخرج': {'small': 45, 'medium': 68, 'large': 98},
      'القطيف': {'small': 52, 'medium': 80, 'large': 120},
      'حفر_الباطن': {'small': 56, 'medium': 85, 'large': 128}
    },
    'المدينة_المنورة': {
      'local': {'small': 15, 'medium': 22, 'large': 35},
      'الرياض': {'small': 40, 'medium': 60, 'large': 88},
      'جدة': {'small': 26, 'medium': 40, 'large': 62},
      'مكة': {'small': 24, 'medium': 38, 'large': 58},
      'الدمام': {'small': 50, 'medium': 75, 'large': 112},
      'الطائف': {'small': 28, 'medium': 42, 'large': 65},
      'أبها': {'small': 45, 'medium': 68, 'large': 98},
      'تبوك': {'small': 35, 'medium': 52, 'large': 78},
      'القصيم': {'small': 30, 'medium': 45, 'large': 68},
      'حائل': {'small': 26, 'medium': 40, 'large': 62},
      'نجران': {'small': 52, 'medium': 78, 'large': 118},
      'جازان': {'small': 48, 'medium': 72, 'large': 105},
      'الجوف': {'small': 42, 'medium': 65, 'large': 95},
      'الباحة': {'small': 33, 'medium': 50, 'large': 75},
      'ينبع': {'small': 20, 'medium': 30, 'large': 45},
      'الجبيل': {'small': 55, 'medium': 82, 'large': 125},
      'خميس_مشيط': {'small': 48, 'medium': 72, 'large': 105},
      'الخرج': {'small': 42, 'medium': 65, 'large': 95},
      'القطيف': {'small': 52, 'medium': 78, 'large': 118},
      'حفر_الباطن': {'small': 55, 'medium': 82, 'large': 125}
    },
    'الدمام': {
      'local': {'small': 15, 'medium': 22, 'large': 35},
      'الرياض': {'small': 25, 'medium': 38, 'large': 58},
      'جدة': {'small': 55, 'medium': 85, 'large': 128},
      'مكة': {'small': 52, 'medium': 78, 'large': 118},
      'المدينة_المنورة': {'small': 50, 'medium': 75, 'large': 112},
      'الطائف': {'small': 50, 'medium': 75, 'large': 110},
      'أبها': {'small': 60, 'medium': 92, 'large': 135},
      'تبوك': {'small': 65, 'medium': 98, 'large': 145},
      'القصيم': {'small': 35, 'medium': 52, 'large': 78},
      'حائل': {'small': 48, 'medium': 72, 'large': 105},
      'نجران': {'small': 55, 'medium': 82, 'large': 125},
      'جازان': {'small': 62, 'medium': 95, 'large': 140},
      'الجوف': {'small': 50, 'medium': 75, 'large': 112},
      'الباحة': {'small': 50, 'medium': 75, 'large': 110},
      'ينبع': {'small': 60, 'medium': 90, 'large': 132},
      'الجبيل': {'small': 18, 'medium': 28, 'large': 42},
      'خميس_مشيط': {'small': 60, 'medium': 92, 'large': 135},
      'الخرج': {'small': 28, 'medium': 42, 'large': 65},
      'القطيف': {'small': 16, 'medium': 24, 'large': 38},
      'حفر_الباطن': {'small': 19, 'medium': 30, 'large': 45}
    },
    'الطائف': {
      'local': {'small': 14, 'medium': 20, 'large': 32},
      'الرياض': {'small': 38, 'medium': 55, 'large': 82},
      'جدة': {'small': 20, 'medium': 30, 'large': 45},
      'مكة': {'small': 18, 'medium': 28, 'large': 42},
      'المدينة_المنورة': {'small': 28, 'medium': 42, 'large': 65},
      'الدمام': {'small': 50, 'medium': 75, 'large': 110},
      'أبها': {'small': 30, 'medium': 45, 'large': 68},
      'تبوك': {'small': 48, 'medium': 72, 'large': 105},
      'القصيم': {'small': 42, 'medium': 65, 'large': 95},
      'حائل': {'small': 45, 'medium': 68, 'large': 98},
      'نجران': {'small': 40, 'medium': 60, 'large': 88}
    }
  };

  void _calculatePrice() {
    if (_formKey.currentState!.validate()) {
      if (_fromCity == null || _toCity == null) {
        _showErrorSnackBar('الرجاء اختيار المدن');
        return;
      }

      double basePrice = 0;

      // Determine the size category based on parcel type and size
      String sizeCategory = 'small';
      if (_parcelType == "Document") {
        sizeCategory = 'small'; // Documents are always small
      } else {
        switch (_parcelSize) {
          case "Small":
            sizeCategory = 'small';
            break;
          case "Medium":
            sizeCategory = 'medium';
            break;
          case "Large":
            sizeCategory = 'large';
            break;
        }
      }

      // Get base price from matrix
      if (_fromCity == _toCity) {
        // Local delivery
        basePrice = _priceMatrix[_fromCity]?['local']?[sizeCategory] ?? 15.0;
      } else {
        // Inter-city delivery - use exact pricing from matrix
        basePrice = _priceMatrix[_fromCity]?[_toCity]?[sizeCategory] ?? 0.0;

        if (basePrice == 0.0) {
          _showErrorSnackBar('لا يوجد سعر متاح لهذا المسار');
          return;
        }
      }

      // The pricing matrix already includes all factors, so use it directly
      _estimatedPrice = basePrice;
      _priceAnimationController.forward();
      setState(() {});
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red[400],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  void _nextStep() {
    if (_currentStep < 3) {
      setState(() {
        _currentStep++;
      });
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFFDF7ED),
      appBar: AppBar(
        elevation: 0,
        title: const Text('حاسبة تكلفة الشحن'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: AnimatedBuilder(
        animation: _fadeAnimation,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(0, _slideAnimation.value),
            child: Opacity(
              opacity: _fadeAnimation.value,
              child: SafeArea(
                child: Column(
                  children: [
                    // Progress Stepper
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 16),
                      child: _buildProgressIndicator(),
                    ),
                    // Main Content
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              _buildStepContent(),
                              const SizedBox(height: 32),
                              if (_estimatedPrice > 0) _buildPriceResult(),
                              const SizedBox(height: 24),
                              _buildNavigationButtons(),
                              const SizedBox(height: 32),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProgressIndicator() {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            children: List.generate(4, (index) {
              final isActive = index <= _currentStep;
              final isCompleted = index < _currentStep;
              
              return Expanded(
                child: Row(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isActive
                            ? const Color(0xFF9B652E)
                            : theme.dividerColor,
                        boxShadow: isActive
                            ? [
                                BoxShadow(
                                  color: const Color(0xFF9B652E).withOpacity(0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ]
                            : null,
                      ),
                      child: isCompleted
                          ? Icon(Icons.check, color: Colors.white, size: 18)
                          : Center(
                              child: Text(
                                '${index + 1}',
                                style: TextStyle(
                                  color: isActive ? Colors.white : const Color(0xFF8B572A),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                    ),
                    if (index < 3)
                      Expanded(
                        child: Container(
                          height: 2,
                          margin: const EdgeInsets.symmetric(horizontal: 8),
                          decoration: BoxDecoration(
                            color: index < _currentStep
                                ? const Color(0xFF9B652E)
                                : theme.dividerColor,
                            borderRadius: BorderRadius.circular(1),
                          ),
                        ),
                      ),
                  ],
                ),
              );
            }),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStepLabel("نوع الشحنة", 0),
              _buildStepLabel("التفاصيل", 1),
              _buildStepLabel("المواقع", 2),
              _buildStepLabel("النتيجة", 3),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStepLabel(String label, int stepIndex) {
    final isActive = stepIndex <= _currentStep;
    return Text(
      label,
      style: TextStyle(
        fontSize: 12,
        color: isActive 
            ? const Color(0xFF9B652E) 
            : const Color(0xFF8B572A),
        fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
      ),
    );
  }

  Widget _buildStepContent() {
    switch (_currentStep) {
      case 0:
        return _buildShipmentTypeStep();
      case 1:
        return _buildDetailsStep();
      case 2:
        return _buildLocationsStep();
      case 3:
        return _buildCalculationStep();
      default:
        return _buildShipmentTypeStep();
    }
  }

  Widget _buildShipmentTypeStep() {
    return _buildStepCard(
      title: "اختر نوع الشحنة",
      icon: Icons.inventory_2_outlined,
      child: Column(
        children: [
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _buildSelectionCard(
                  title: "وثيقة",
                  subtitle: "مستندات وأوراق",
                  icon: Icons.description_outlined,
                  isSelected: _parcelType == "Document",
                  onTap: () => setState(() => _parcelType = "Document"),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildSelectionCard(
                  title: "شحنة",
                  subtitle: "طرود ومنتجات",
                  icon: Icons.inventory_outlined,
                  isSelected: _parcelType == "Normal",
                  onTap: () => setState(() => _parcelType = "Normal"),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsStep() {
    return _buildStepCard(
      title: _parcelType == "Document" ? "تفاصيل الوثيقة" : "تفاصيل الشحنة",
      icon: _parcelType == "Document" 
          ? Icons.description_outlined 
          : Icons.inventory_2_outlined,
      child: Column(
        children: [
          if (_parcelType == "Normal") ...[
            const SizedBox(height: 20),
            _buildSectionTitle("حجم الشحنة"),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildSizeCard("صغير", "حتى 2 كجم", "Small"),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildSizeCard("متوسط", "حتى 10 كجم", "Medium"),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildSizeCard("كبير", "حتى 30 كجم", "Large"),
                ),
              ],
            ),
            const SizedBox(height: 24),
            _buildSectionTitle("طبيعة الشحنة"),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildNatureCard(
                    "عادي", 
                    Icons.inventory_outlined, 
                    "Normal"
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildNatureCard(
                    "قابل للكسر", 
                    Icons.warning_outlined, 
                    "Fragile"
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            _buildWeightInput(),
          ] else ...[
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF9B652E).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFF9B652E).withOpacity(0.3),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: const Color(0xFF9B652E),
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      "الوثائق تُعامل كشحنات صغيرة الحجم",
                      style: TextStyle(
                        color: const Color(0xFF9B652E),
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildLocationsStep() {
    return _buildStepCard(
      title: "اختر المواقع",
      icon: Icons.location_on_outlined,
      child: Column(
        children: [
          const SizedBox(height: 20),
          _buildLocationDropdown(
            "من",
            _fromCity,
            _fromCities,
            (value) => setState(() {
              _fromCity = value;
              _toCity = null; // Reset destination
            }),
            Icons.flight_takeoff_rounded,
          ),
          const SizedBox(height: 16),
          _buildLocationDropdown(
            "إلى",
            _toCity,
            _getDestinationsForCity(_fromCity),
            (value) => setState(() => _toCity = value),
            Icons.flight_land_rounded,
            enabled: _fromCity != null,
          ),
        ],
      ),
    );
  }

  Widget _buildCalculationStep() {
    return _buildStepCard(
      title: "مراجعة وحساب التكلفة",
      icon: Icons.calculate_outlined,
      child: Column(
        children: [
          const SizedBox(height: 20),
          _buildSummaryCard(),
        ],
      ),
    );
  }

  Widget _buildStepCard({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFF9B652E),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: Colors.white, size: 24),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: child,
          ),
        ],
      ),
    );
  }

  Widget _buildSelectionCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected 
              ? const Color(0xFF9B652E).withOpacity(0.1)
              : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected 
                ? const Color(0xFF9B652E)
                : theme.dividerColor,
            width: 2,
          ),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isSelected 
                    ? const Color(0xFF9B652E)
                    : const Color(0xFF8B572A),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon, 
                color: Theme.of(context).cardColor, 
                size: 28,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isSelected 
                    ? const Color(0xFF9B652E)
                    : Colors.grey[700],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSizeCard(String title, String subtitle, String value) {
    final isSelected = _parcelSize == value;
    return GestureDetector(
      onTap: () => setState(() => _parcelSize = value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(
          color: isSelected 
              ? const Color(0xFF9B652E).withOpacity(0.1)
              : Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected 
                ? const Color(0xFF9B652E)
                : Colors.grey[300]!,
            width: 1.5,
          ),
        ),
        child: Column(
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: isSelected 
                    ? const Color(0xFF9B652E)
                    : Colors.grey[700],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 10,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNatureCard(String title, IconData icon, String value) {
    final isSelected = _parcelNature == value;
    return GestureDetector(
      onTap: () => setState(() => _parcelNature = value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected 
              ? const Color(0xFF9B652E).withOpacity(0.1)
              : Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected 
                ? const Color(0xFF9B652E)
                : Colors.grey[300]!,
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected 
                  ? const Color(0xFF9B652E)
                  : Colors.grey[600],
              size: 20,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: isSelected 
                      ? const Color(0xFF9B652E)
                      : Colors.grey[700],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeightInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle("الوزن (كجم)"),
        const SizedBox(height: 8),
        TextFormField(
          initialValue: _weight,
          onChanged: (value) => setState(() => _weight = value),
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: "أدخل الوزن بالكيلوجرام",
            prefixIcon: Icon(
              Icons.monitor_weight_outlined,
              color: const Color(0xFF9B652E),
            ),
            filled: true,
            fillColor: Theme.of(context).scaffoldBackgroundColor,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: const Color(0xFF9B652E)),
            ),
          ),
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
    );
  }

  Widget _buildLocationDropdown(
    String label,
    String? value,
    List<String> cities,
    ValueChanged<String?> onChanged,
    IconData icon, {
    bool enabled = true,
  }) {
    final cityDisplayNames = {
      'الرياض': 'الرياض',
      'جدة': 'جدة',
      'مكة': 'مكة المكرمة',
      'المدينة_المنورة': 'المدينة المنورة',
      'الدمام': 'الدمام',
      'الطائف': 'الطائف',
      'أبها': 'أبها',
      'تبوك': 'تبوك',
      'القصيم': 'القصيم',
      'حائل': 'حائل',
      'نجران': 'نجران',
      'جازان': 'جازان',
      'الجوف': 'الجوف',
      'الباحة': 'الباحة',
      'ينبع': 'ينبع',
      'الجبيل': 'الجبيل',
      'خميس_مشيط': 'خميس مشيط',
      'الخرج': 'الخرج',
      'القطيف': 'القطيف',
      'حفر_الباطن': 'حفر الباطن'
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(label),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: value,
          onChanged: enabled ? onChanged : null,
          decoration: InputDecoration(
            hintText: enabled 
                ? (cities.isEmpty ? 'اختر مدينة المغادرة أولاً' : 'اختر المدينة')
                : 'اختر مدينة المغادرة أولاً',
            prefixIcon: Icon(icon, color: const Color(0xFF9B652E)),
            filled: true,
            fillColor: enabled ? Colors.grey[50] : Colors.grey[100],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: const Color(0xFF9B652E)),
            ),
          ),
          items: cities.map((city) {
            return DropdownMenuItem<String>(
              value: city,
              child: Text(cityDisplayNames[city] ?? city),
            );
          }).toList(),
          validator: enabled ? (value) {
            if (value == null || value.isEmpty) {
              return label == 'من' 
                  ? 'الرجاء اختيار مدينة المغادرة'
                  : 'الرجاء اختيار مدينة الوصول';
            }
            return null;
          } : null,
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.grey[800],
      ),
    );
  }

  Widget _buildSummaryCard() {
    final cityDisplayNames = {
      'الرياض': 'الرياض',
      'جدة': 'جدة',
      'مكة': 'مكة المكرمة',
      'المدينة_المنورة': 'المدينة المنورة',
      'الدمام': 'الدمام',
      'الطائف': 'الطائف',
    };

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSummaryRow("نوع الشحنة", _parcelType == "Document" ? "وثيقة" : "شحنة"),
          if (_parcelType == "Normal") ...[
            _buildSummaryRow("الحجم", _parcelSize == "Small" ? "صغير" : 
                                     _parcelSize == "Medium" ? "متوسط" : "كبير"),
            _buildSummaryRow("الطبيعة", _parcelNature == "Normal" ? "عادي" : "قابل للكسر"),
            if (_weight.isNotEmpty) _buildSummaryRow("الوزن", "$_weight كجم"),
          ],
          if (_fromCity != null) 
            _buildSummaryRow("من", cityDisplayNames[_fromCity] ?? _fromCity!),
          if (_toCity != null) 
            _buildSummaryRow("إلى", cityDisplayNames[_toCity] ?? _toCity!),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _calculatePrice,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF9B652E),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.calculate, color: Colors.white, size: 20),
                  const SizedBox(width: 8),
                  const Text(
                    "حساب التكلفة",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.grey[800],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceResult() {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF9B652E),
                  const Color(0xFF9B652E).withOpacity(0.8),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF9B652E).withOpacity(0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.monetization_on,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      "التكلفة المقدرة",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  "${_estimatedPrice.toStringAsFixed(0)} ريال سعودي",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    "شامل جميع الرسوم",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildNavigationButtons() {
    return Row(
      children: [
        if (_currentStep > 0)
          Expanded(
            child: OutlinedButton(
              onPressed: _previousStep,
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                side: BorderSide(color: const Color(0xFF9B652E)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.arrow_back_ios,
                    color: const Color(0xFF9B652E),
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    "السابق",
                    style: TextStyle(
                      color: const Color(0xFF9B652E),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        if (_currentStep > 0 && _currentStep < 3) const SizedBox(width: 12),
        if (_currentStep < 3)
          Expanded(
            child: ElevatedButton(
              onPressed: _nextStep,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF9B652E),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "التالي",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white,
                    size: 16,
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}