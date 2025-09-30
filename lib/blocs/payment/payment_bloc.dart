import 'package:flutter_bloc/flutter_bloc.dart';
import '../../services/payment_service.dart';
import 'payment_event.dart';
import 'payment_state.dart';

class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  final PaymentService _paymentService;

  PaymentBloc({required PaymentService paymentService})
      : _paymentService = paymentService,
        super(const PaymentInitial()) {
    on<PaymentStarted>(_onStarted);
    on<PaymentCostCalculationRequested>(_onCostCalculationRequested);
    on<PaymentMethodSelected>(_onPaymentMethodSelected);
    on<PaymentProcessRequested>(_onProcessRequested);
    on<PaymentReset>(_onReset);
  }

  Future<void> _onStarted(
    PaymentStarted event,
    Emitter<PaymentState> emit,
  ) async {
    emit(const PaymentInitial());
  }

  Future<void> _onCostCalculationRequested(
    PaymentCostCalculationRequested event,
    Emitter<PaymentState> emit,
  ) async {
    try {
      emit(const PaymentCostCalculating());
      
      final cost = await _paymentService.calculateShippingCost(event.shipment);
      final availablePaymentMethods = _paymentService.getAvailablePaymentMethods();
      
      emit(PaymentMethodSelection(
        shippingCost: cost,
        availablePaymentMethods: availablePaymentMethods,
      ));
    } catch (e) {
      emit(PaymentFailure(message: 'فشل في حساب تكلفة الشحن: $e'));
    }
  }

  Future<void> _onPaymentMethodSelected(
    PaymentMethodSelected event,
    Emitter<PaymentState> emit,
  ) async {
    if (state is PaymentMethodSelection) {
      final currentState = state as PaymentMethodSelection;
      emit(currentState.copyWith(selectedPaymentMethod: event.paymentMethodType));
    }
  }

  Future<void> _onProcessRequested(
    PaymentProcessRequested event,
    Emitter<PaymentState> emit,
  ) async {
    try {
      emit(PaymentProcessing(
        amount: event.amount,
        paymentMethod: event.paymentMethod.type,
      ));
      
      final result = await _paymentService.processPayment(
        trackingNumber: event.trackingNumber,
        paymentMethod: event.paymentMethod,
        amount: event.amount,
      );
      
      if (result.success) {
        emit(PaymentSuccess(result));
      } else {
        emit(PaymentFailure(
          message: result.errorMessage ?? 'فشل في معالجة الدفع',
          failedPaymentMethod: result.paymentMethod,
        ));
      }
    } catch (e) {
      emit(PaymentFailure(
        message: 'خطأ في معالجة الدفع: $e',
        failedPaymentMethod: event.paymentMethod.type,
      ));
    }
  }

  Future<void> _onReset(
    PaymentReset event,
    Emitter<PaymentState> emit,
  ) async {
    emit(const PaymentInitial());
  }

  @override
  Future<void> close() {
    _paymentService.dispose();
    return super.close();
  }
}
