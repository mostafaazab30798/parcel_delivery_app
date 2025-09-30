import 'dart:io' show Platform;
import 'package:http/http.dart' as http;
import '../models/payment_method.dart';
import '../models/api_shipment.dart';
import 'auth_service.dart';

/// Service for handling payment processing
class PaymentService {
  final http.Client _httpClient;
  final AuthService _authService;

  PaymentService({http.Client? httpClient, AuthService? authService})
      : _httpClient = httpClient ?? http.Client(),
        _authService = authService ?? AuthService();

  /// Process payment for a shipment
  Future<PaymentResult> processPayment({
    required String trackingNumber,
    required PaymentMethod paymentMethod,
    required double amount,
  }) async {
    try {
      print('🔄 Processing payment for shipment: $trackingNumber');
      print('💳 Payment method: ${paymentMethod.type}');
      print('💰 Amount: $amount SAR');

      switch (paymentMethod.type) {
        case PaymentMethodType.cash:
          return _processCashPayment(trackingNumber, amount);
        
        case PaymentMethodType.card:
        case PaymentMethodType.mada:
          return _processCardPayment(trackingNumber, paymentMethod, amount);
        
        case PaymentMethodType.applePay:
          return _processApplePayPayment(trackingNumber, amount);
        
        case PaymentMethodType.stcPay:
          return _processStcPayPayment(trackingNumber, amount);
      }
    } catch (e) {
      print('❌ Payment processing error: $e');
      return PaymentResult.failure(
        paymentMethod: paymentMethod.type,
        errorMessage: 'خطأ في معالجة الدفع: $e',
      );
    }
  }

  /// Process cash payment (cash on delivery)
  Future<PaymentResult> _processCashPayment(String trackingNumber, double amount) async {
    try {
      // For cash payments, we just mark the payment method in the shipment
      // The actual payment will be collected on delivery
      final response = await _authService.authenticatedRequest(
        method: 'PUT',
        endpoint: '/shipments/$trackingNumber',
        body: {
          'paymentMethod': 'cash',
          'paymentStatus': 'pending',
          'amount': amount,
        },
      );

      if (response.statusCode == 200) {
        print('✅ Cash payment method set successfully');
        return PaymentResult.success(
          paymentMethod: PaymentMethodType.cash,
          transactionId: 'COD_$trackingNumber',
          amount: amount,
        );
      } else {
        throw Exception('Failed to set payment method: ${response.body}');
      }
    } catch (e) {
      print('❌ Cash payment error: $e');
      return PaymentResult.failure(
        paymentMethod: PaymentMethodType.cash,
        errorMessage: 'فشل في تعيين طريقة الدفع النقدي',
      );
    }
  }

  /// Process card payment (Visa/Mada)
  Future<PaymentResult> _processCardPayment(
    String trackingNumber,
    PaymentMethod paymentMethod,
    double amount,
  ) async {
    try {
      if (paymentMethod.cardDetails == null) {
        throw Exception('Card details are required for card payment');
      }

      // In a real implementation, this would integrate with a payment gateway
      // For now, we'll simulate the payment process
      await _simulatePaymentGateway(paymentMethod.cardDetails!, amount);

      final transactionId = 'TXN_${DateTime.now().millisecondsSinceEpoch}';
      
      // Update shipment with payment information
      final response = await _authService.authenticatedRequest(
        method: 'PUT',
        endpoint: '/shipments/$trackingNumber',
        body: {
          'paymentMethod': paymentMethod.type == PaymentMethodType.mada ? 'mada' : 'card',
          'paymentStatus': 'completed',
          'transactionId': transactionId,
          'amount': amount,
          'cardLast4': paymentMethod.cardDetails!.cardNumber.substring(
            paymentMethod.cardDetails!.cardNumber.length - 4,
          ),
        },
      );

      if (response.statusCode == 200) {
        print('✅ Card payment processed successfully');
        return PaymentResult.success(
          paymentMethod: paymentMethod.type,
          transactionId: transactionId,
          amount: amount,
        );
      } else {
        throw Exception('Failed to update shipment payment: ${response.body}');
      }
    } catch (e) {
      print('❌ Card payment error: $e');
      return PaymentResult.failure(
        paymentMethod: paymentMethod.type,
        errorMessage: 'فشل في معالجة دفع البطاقة: $e',
      );
    }
  }

  /// Process Apple Pay payment
  Future<PaymentResult> _processApplePayPayment(String trackingNumber, double amount) async {
    try {
      if (!Platform.isIOS) {
        throw Exception('Apple Pay is only available on iOS devices');
      }

      // In a real implementation, this would use Apple Pay SDK
      // For now, we'll simulate the process
      await Future.delayed(const Duration(seconds: 2)); // Simulate processing

      final transactionId = 'APPLE_${DateTime.now().millisecondsSinceEpoch}';
      
      // Update shipment with payment information
      final response = await _authService.authenticatedRequest(
        method: 'PUT',
        endpoint: '/shipments/$trackingNumber',
        body: {
          'paymentMethod': 'apple_pay',
          'paymentStatus': 'completed',
          'transactionId': transactionId,
          'amount': amount,
        },
      );

      if (response.statusCode == 200) {
        print('✅ Apple Pay payment processed successfully');
        return PaymentResult.success(
          paymentMethod: PaymentMethodType.applePay,
          transactionId: transactionId,
          amount: amount,
        );
      } else {
        throw Exception('Failed to update shipment payment: ${response.body}');
      }
    } catch (e) {
      print('❌ Apple Pay error: $e');
      return PaymentResult.failure(
        paymentMethod: PaymentMethodType.applePay,
        errorMessage: 'فشل في معالجة Apple Pay: $e',
      );
    }
  }

  /// Process STC Pay payment
  Future<PaymentResult> _processStcPayPayment(String trackingNumber, double amount) async {
    try {
      // In a real implementation, this would integrate with STC Pay SDK
      // For now, we'll simulate the process
      await Future.delayed(const Duration(seconds: 2)); // Simulate processing

      final transactionId = 'STC_${DateTime.now().millisecondsSinceEpoch}';
      
      // Update shipment with payment information
      final response = await _authService.authenticatedRequest(
        method: 'PUT',
        endpoint: '/shipments/$trackingNumber',
        body: {
          'paymentMethod': 'stc_pay',
          'paymentStatus': 'completed',
          'transactionId': transactionId,
          'amount': amount,
        },
      );

      if (response.statusCode == 200) {
        print('✅ STC Pay payment processed successfully');
        return PaymentResult.success(
          paymentMethod: PaymentMethodType.stcPay,
          transactionId: transactionId,
          amount: amount,
        );
      } else {
        throw Exception('Failed to update shipment payment: ${response.body}');
      }
    } catch (e) {
      print('❌ STC Pay error: $e');
      return PaymentResult.failure(
        paymentMethod: PaymentMethodType.stcPay,
        errorMessage: 'فشل في معالجة STC Pay: $e',
      );
    }
  }

  /// Simulate payment gateway processing (for demo purposes)
  Future<void> _simulatePaymentGateway(CardPaymentDetails cardDetails, double amount) async {
    print('🔄 Simulating payment gateway...');
    print('💳 Card: ****${cardDetails.cardNumber.substring(cardDetails.cardNumber.length - 4)}');
    print('💰 Amount: $amount SAR');
    
    // Simulate processing time
    await Future.delayed(const Duration(seconds: 2));
    
    // Simulate validation
    if (cardDetails.cardNumber.length < 16) {
      throw Exception('رقم البطاقة غير صحيح');
    }
    
    if (cardDetails.cvv.length < 3) {
      throw Exception('رمز CVV غير صحيح');
    }
    
    // Simulate random failure (5% chance)
    if (DateTime.now().millisecond % 20 == 0) {
      throw Exception('فشل في المعاملة - يرجى المحاولة مرة أخرى');
    }
    
    print('✅ Payment gateway simulation completed successfully');
  }

  /// Calculate shipping cost based on shipment details
  Future<double> calculateShippingCost(ApiShipment shipment) async {
    try {
      print('🧮 Calculating shipping cost...');
      
      // Base cost calculation logic based on the payment.json examples
      double baseCost = 15.0; // Base local delivery cost
      
      // Check if it's inter-city delivery
      final senderCity = shipment.sender.address.national?.city?.toLowerCase() ?? '';
      final recipientCity = shipment.recipient.address.national?.city?.toLowerCase() ?? '';
      
      if (senderCity != recipientCity && senderCity.isNotEmpty && recipientCity.isNotEmpty) {
        baseCost = 65.0; // Inter-city base cost
      }
      
      // Add weight-based cost
      if (shipment.weight != null && shipment.weight! > 0) {
        if (shipment.weight! > 20) {
          baseCost -= 7.0; // Large package discount as per examples
        } else if (shipment.weight! > 5) {
          baseCost += 0.0; // Medium weight - no change
        }
      }
      
      // Add nature-based cost
      if (shipment.nature?.toLowerCase() == 'fragile') {
        baseCost += 5.0; // Fragile handling fee
      }
      
      // Document type is cheaper
      if (shipment.shipmentType?.toLowerCase() == 'document') {
        baseCost = 15.0; // Fixed document price
      }
      
      print('💰 Calculated shipping cost: $baseCost SAR');
      return baseCost;
      
    } catch (e) {
      print('❌ Cost calculation error: $e');
      return 25.0; // Default fallback cost
    }
  }

  /// Get payment methods available for the current platform
  List<PaymentMethodType> getAvailablePaymentMethods() {
    final methods = <PaymentMethodType>[
      PaymentMethodType.cash,
      PaymentMethodType.card,
      PaymentMethodType.mada,
    ];
    
    if (Platform.isIOS) {
      methods.add(PaymentMethodType.applePay);
    }
    
    // Add STC Pay for Saudi users (you might want to check locale here)
    methods.add(PaymentMethodType.stcPay);
    
    return methods;
  }

  /// Dispose of resources
  void dispose() {
    _httpClient.close();
  }
}
