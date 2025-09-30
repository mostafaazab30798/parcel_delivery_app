// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_method.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CardPaymentDetails _$CardPaymentDetailsFromJson(Map<String, dynamic> json) =>
    CardPaymentDetails(
      cardNumber: json['card_number'] as String,
      expiryDate: json['expiry_date'] as String,
      cvv: json['cvv'] as String,
      cardHolderName: json['card_holder_name'] as String?,
    );

Map<String, dynamic> _$CardPaymentDetailsToJson(CardPaymentDetails instance) =>
    <String, dynamic>{
      'card_number': instance.cardNumber,
      'expiry_date': instance.expiryDate,
      'cvv': instance.cvv,
      'card_holder_name': instance.cardHolderName,
    };

PaymentMethod _$PaymentMethodFromJson(Map<String, dynamic> json) =>
    PaymentMethod(
      type: $enumDecode(_$PaymentMethodTypeEnumMap, json['type']),
      cardDetails: json['card_details'] == null
          ? null
          : CardPaymentDetails.fromJson(
              json['card_details'] as Map<String, dynamic>),
      transactionId: json['transaction_id'] as String?,
      amount: (json['amount'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$PaymentMethodToJson(PaymentMethod instance) =>
    <String, dynamic>{
      'type': _$PaymentMethodTypeEnumMap[instance.type]!,
      'card_details': instance.cardDetails,
      'transaction_id': instance.transactionId,
      'amount': instance.amount,
    };

const _$PaymentMethodTypeEnumMap = {
  PaymentMethodType.cash: 'cash',
  PaymentMethodType.card: 'card',
  PaymentMethodType.applePay: 'apple_pay',
  PaymentMethodType.stcPay: 'stc_pay',
  PaymentMethodType.mada: 'mada',
};

PaymentResult _$PaymentResultFromJson(Map<String, dynamic> json) =>
    PaymentResult(
      success: json['success'] as bool,
      paymentMethod:
          $enumDecode(_$PaymentMethodTypeEnumMap, json['payment_method']),
      transactionId: json['transaction_id'] as String?,
      errorMessage: json['error_message'] as String?,
      amount: (json['amount'] as num?)?.toDouble(),
      processedAt: json['processed_at'] == null
          ? null
          : DateTime.parse(json['processed_at'] as String),
    );

Map<String, dynamic> _$PaymentResultToJson(PaymentResult instance) =>
    <String, dynamic>{
      'success': instance.success,
      'transaction_id': instance.transactionId,
      'error_message': instance.errorMessage,
      'amount': instance.amount,
      'payment_method': _$PaymentMethodTypeEnumMap[instance.paymentMethod]!,
      'processed_at': instance.processedAt?.toIso8601String(),
    };
