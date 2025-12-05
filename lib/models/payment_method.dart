import 'package:json_annotation/json_annotation.dart';

part 'payment_method.g.dart';

/// Payment method enumeration
enum PaymentMethodType {
  @JsonValue('cash')
  cash,
  @JsonValue('card')
  card,
  @JsonValue('apple_pay')
  applePay,
  @JsonValue('stc_pay')
  stcPay,
  @JsonValue('mada')
  mada,
}

/// Card payment details
@JsonSerializable(fieldRename: FieldRename.snake)
class CardPaymentDetails {
  final String cardNumber;
  final String expiryDate;
  final String cvv;
  final String? cardHolderName;

  const CardPaymentDetails({
    required this.cardNumber,
    required this.expiryDate,
    required this.cvv,
    this.cardHolderName,
  });

  factory CardPaymentDetails.fromJson(Map<String, dynamic> json) =>
      _$CardPaymentDetailsFromJson(json);

  Map<String, dynamic> toJson() => _$CardPaymentDetailsToJson(this);
}

/// Payment method model for API requests
@JsonSerializable(fieldRename: FieldRename.snake)
class PaymentMethod {
  final PaymentMethodType type;
  final CardPaymentDetails? cardDetails;
  final String? transactionId;
  final double? amount;

  const PaymentMethod({
    required this.type,
    this.cardDetails,
    this.transactionId,
    this.amount,
  });

  factory PaymentMethod.fromJson(Map<String, dynamic> json) =>
      _$PaymentMethodFromJson(json);

  Map<String, dynamic> toJson() => _$PaymentMethodToJson(this);

  /// Create cash payment method
  factory PaymentMethod.cash() => const PaymentMethod(type: PaymentMethodType.cash);

  /// Create card payment method
  factory PaymentMethod.card({
    required String cardNumber,
    required String expiryDate,
    required String cvv,
    String? cardHolderName,
    double? amount,
  }) =>
      PaymentMethod(
        type: PaymentMethodType.card,
        cardDetails: CardPaymentDetails(
          cardNumber: cardNumber,
          expiryDate: expiryDate,
          cvv: cvv,
          cardHolderName: cardHolderName,
        ),
        amount: amount,
      );

  /// Create Apple Pay payment method
  factory PaymentMethod.applePay({String? transactionId, double? amount}) =>
      PaymentMethod(
        type: PaymentMethodType.applePay,
        transactionId: transactionId,
        amount: amount,
      );
}

/// Payment processing result
@JsonSerializable(fieldRename: FieldRename.snake)
class PaymentResult {
  final bool success;
  final String? transactionId;
  final String? errorMessage;
  final double? amount;
  final PaymentMethodType paymentMethod;
  final DateTime? processedAt;

  const PaymentResult({
    required this.success,
    required this.paymentMethod,
    this.transactionId,
    this.errorMessage,
    this.amount,
    this.processedAt,
  });

  factory PaymentResult.fromJson(Map<String, dynamic> json) =>
      _$PaymentResultFromJson(json);

  Map<String, dynamic> toJson() => _$PaymentResultToJson(this);

  /// Create successful payment result
  factory PaymentResult.success({
    required PaymentMethodType paymentMethod,
    String? transactionId,
    double? amount,
  }) =>
      PaymentResult(
        success: true,
        paymentMethod: paymentMethod,
        transactionId: transactionId,
        amount: amount,
        processedAt: DateTime.now(),
      );

  /// Create failed payment result
  factory PaymentResult.failure({
    required PaymentMethodType paymentMethod,
    required String errorMessage,
  }) =>
      PaymentResult(
        success: false,
        paymentMethod: paymentMethod,
        errorMessage: errorMessage,
        processedAt: DateTime.now(),
      );
}


