import 'package:equatable/equatable.dart';

class Driver extends Equatable {
  int? sucDeliveries;
  int? onGoingDeliveries;
  String? name;
  int? id;
  int? totalStars;
  int? totalReviews;

  Driver(
      {this.sucDeliveries,
      this.onGoingDeliveries,
      this.name,
      this.id,
      this.totalStars,
      this.totalReviews});

  @override
  List<Object?> get props =>
      [sucDeliveries, onGoingDeliveries, name, id, totalStars, totalReviews];
}
