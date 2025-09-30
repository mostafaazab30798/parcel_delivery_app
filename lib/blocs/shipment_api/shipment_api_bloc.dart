import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/api_shipment.dart';
import '../../repos/shipment_repository.dart';
import 'shipment_api_event.dart';
import 'shipment_api_state.dart';

class ShipmentApiBloc extends Bloc<ShipmentApiEvent, ShipmentApiState> {
  final ShipmentRepository _repository;

  ShipmentApiBloc({required ShipmentRepository repository})
      : _repository = repository,
        super(const ShipmentApiInitial()) {
    on<ShipmentApiStarted>(_onStarted);
    on<ShipmentApiCreateRequested>(_onCreateRequested);
    on<ShipmentApiLoadRequested>(_onLoadRequested);
    on<ShipmentApiUpdateRequested>(_onUpdateRequested);
    on<ShipmentApiDeleteRequested>(_onDeleteRequested);
    on<ShipmentApiAssignDriverRequested>(_onAssignDriverRequested);
    on<ShipmentApiLoadUnassignedRequested>(_onLoadUnassignedRequested);
  }

  Future<void> _onStarted(
    ShipmentApiStarted event,
    Emitter<ShipmentApiState> emit,
  ) async {
    emit(const ShipmentApiInitial());
  }

  Future<void> _onCreateRequested(
    ShipmentApiCreateRequested event,
    Emitter<ShipmentApiState> emit,
  ) async {
    try {
      emit(const ShipmentApiLoading());
      final shipment = await _repository.createShipment(event.shipment);
      emit(ShipmentApiSuccess([shipment]));
    } catch (e) {
      emit(ShipmentApiFailure(e.toString()));
    }
  }

  Future<void> _onLoadRequested(
    ShipmentApiLoadRequested event,
    Emitter<ShipmentApiState> emit,
  ) async {
    try {
      emit(const ShipmentApiLoading());
      final shipments = await _repository.getAllShipments();
      emit(ShipmentApiSuccess(shipments));
    } catch (e) {
      emit(ShipmentApiFailure(e.toString()));
    }
  }

  Future<void> _onUpdateRequested(
    ShipmentApiUpdateRequested event,
    Emitter<ShipmentApiState> emit,
  ) async {
    try {
      emit(const ShipmentApiLoading());
      final updatedShipment = await _repository.updateShipment(
        event.trackingNumber,
        event.updateData,
      );
      
      // Update the shipment in the current list
      if (state is ShipmentApiSuccess) {
        final currentState = state as ShipmentApiSuccess;
        final currentShipments = currentState.shipments;
        final updatedIndex = currentShipments.indexWhere(
          (s) => s.trackingNumber == event.trackingNumber,
        );
        
        if (updatedIndex != -1) {
          final updatedShipments = List<ApiShipment>.from(currentShipments);
          updatedShipments[updatedIndex] = updatedShipment;
          emit(ShipmentApiSuccess(updatedShipments));
        } else {
          emit(ShipmentApiSuccess(currentShipments));
        }
      } else {
        emit(ShipmentApiSuccess([updatedShipment]));
      }
    } catch (e) {
      emit(ShipmentApiFailure(e.toString()));
    }
  }

  Future<void> _onDeleteRequested(
    ShipmentApiDeleteRequested event,
    Emitter<ShipmentApiState> emit,
  ) async {
    try {
      emit(const ShipmentApiLoading());
      await _repository.deleteShipment(event.trackingNumber);
      
      // Remove the shipment from the current list
      if (state is ShipmentApiSuccess) {
        final currentState = state as ShipmentApiSuccess;
        final currentShipments = currentState.shipments;
        final updatedShipments = currentShipments
            .where((s) => s.trackingNumber != event.trackingNumber)
            .toList();
        
        emit(ShipmentApiSuccess(updatedShipments));
      } else {
        emit(const ShipmentApiInitial());
      }
    } catch (e) {
      emit(ShipmentApiFailure(e.toString()));
    }
  }

  Future<void> _onAssignDriverRequested(
    ShipmentApiAssignDriverRequested event,
    Emitter<ShipmentApiState> emit,
  ) async {
    try {
      emit(const ShipmentApiLoading());
      final updatedShipment = await _repository.assignDriverToShipment(
        event.trackingNumber,
        event.driverId,
      );
      
      // Update the shipment in the current list
      if (state is ShipmentApiSuccess) {
        final currentState = state as ShipmentApiSuccess;
        final currentShipments = currentState.shipments;
        final updatedIndex = currentShipments.indexWhere(
          (s) => s.trackingNumber == event.trackingNumber,
        );
        
        if (updatedIndex != -1) {
          final updatedShipments = List<ApiShipment>.from(currentShipments);
          updatedShipments[updatedIndex] = updatedShipment;
          emit(ShipmentApiSuccess(updatedShipments));
        } else {
          emit(ShipmentApiSuccess(currentShipments));
        }
      } else {
        emit(ShipmentApiSuccess([updatedShipment]));
      }
    } catch (e) {
      emit(ShipmentApiFailure(e.toString()));
    }
  }

  Future<void> _onLoadUnassignedRequested(
    ShipmentApiLoadUnassignedRequested event,
    Emitter<ShipmentApiState> emit,
  ) async {
    try {
      emit(const ShipmentApiLoading());
      final shipments = await _repository.getUnassignedShipments();
      emit(ShipmentApiSuccess(shipments));
    } catch (e) {
      emit(ShipmentApiFailure(e.toString()));
    }
  }

  @override
  Future<void> close() {
    _repository.dispose();
    return super.close();
  }
}
