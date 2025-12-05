import 'package:equatable/equatable.dart';
import '../../models/payment_method.dart';

abstract class PaymentState extends Equatable {
  const PaymentState();

  @override
  List<Object?> get props => [];
}

/// Initial payment state
class PaymentInitial extends PaymentState {
  const PaymentInitial();
}

/// Loading state for cost calculation
class PaymentCostCalculating extends PaymentState {
  const PaymentCostCalculating();
}

/// State when cost is calculated and payment method can be selected
class PaymentMethodSelection extends PaymentState {
  final double shippingCost;
  final PaymentMethodType? selectedPaymentMethod;
  final List<PaymentMethodType> availablePaymentMethods;

  const PaymentMethodSelection({
    required this.shippingCost,
    required this.availablePaymentMethods,
    this.selectedPaymentMethod,
  });

  @override
  List<Object?> get props => [shippingCost, selectedPaymentMethod, availablePaymentMethods];

  PaymentMethodSelection copyWith({
    double? shippingCost,
    PaymentMethodType? selectedPaymentMethod,
    List<PaymentMethodType>? availablePaymentMethods,
  }) {
    return PaymentMethodSelection(
      shippingCost: shippingCost ?? this.shippingCost,
      selectedPaymentMethod: selectedPaymentMethod ?? this.selectedPaymentMethod,
      availablePaymentMethods: availablePaymentMethods ?? this.availablePaymentMethods,
    );
  }
}

/// Processing payment state
class PaymentProcessing extends PaymentState {
  final double amount;
  final PaymentMethodType paymentMethod;

  const PaymentProcessing({
    required this.amount,
    required this.paymentMethod,
  });

  @override
  List<Object?> get props => [amount, paymentMethod];
}

/// Payment successful state
class PaymentSuccess extends PaymentState {
  final PaymentResult result;

  const PaymentSuccess(this.result);

  @override
  List<Object?> get props => [result];
}

/// Payment failed state
class PaymentFailure extends PaymentState {
  final String message;
  final PaymentMethodType? failedPaymentMethod;

  const PaymentFailure({
    required this.message,
    this.failedPaymentMethod,
  });

  @override
  List<Object?> get props => [message, failedPaymentMethod];
}


