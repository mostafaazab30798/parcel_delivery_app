import 'package:equatable/equatable.dart';
import '../../models/payment_method.dart';
import '../../models/api_shipment.dart';

abstract class PaymentEvent extends Equatable {
  const PaymentEvent();

  @override
  List<Object?> get props => [];
}

/// Event to start payment processing
class PaymentStarted extends PaymentEvent {
  const PaymentStarted();
}

/// Event to calculate shipping cost
class PaymentCostCalculationRequested extends PaymentEvent {
  final ApiShipment shipment;

  const PaymentCostCalculationRequested(this.shipment);

  @override
  List<Object?> get props => [shipment];
}

/// Event to select payment method
class PaymentMethodSelected extends PaymentEvent {
  final PaymentMethodType paymentMethodType;

  const PaymentMethodSelected(this.paymentMethodType);

  @override
  List<Object?> get props => [paymentMethodType];
}

/// Event to process payment
class PaymentProcessRequested extends PaymentEvent {
  final String trackingNumber;
  final PaymentMethod paymentMethod;
  final double amount;

  const PaymentProcessRequested({
    required this.trackingNumber,
    required this.paymentMethod,
    required this.amount,
  });

  @override
  List<Object?> get props => [trackingNumber, paymentMethod, amount];
}

/// Event to reset payment state
class PaymentReset extends PaymentEvent {
  const PaymentReset();
}


