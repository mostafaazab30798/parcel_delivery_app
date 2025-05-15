import 'package:flutter/material.dart';
import 'package:order_tracker/order_tracker.dart';

class TrackingPackage extends StatefulWidget {
  const TrackingPackage({Key? key}) : super(key: key);

  @override
  State<TrackingPackage> createState() => _TrackingPackageState();
}

class _TrackingPackageState extends State<TrackingPackage> {
  ///this TextDto present in a package add data in this dto and set in a list.

  List<TextDto> orderList = [
    TextDto("تم قبول الشحنة", ""),
  ];

  List<TextDto> outOfDeliveryList = [
    TextDto("في الطريق", ""),
  ];

  List<TextDto> deliveredList = [
    TextDto("تم التوصيل", ""),
  ];

  List<TextDto> shippedList = [
    TextDto("تم الاستلام", ""),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: OrderTracker(
        status: Status.order,
        activeColor: Colors.green,
        inActiveColor: Colors.grey[300],
        orderTitleAndDateList: orderList,
        outOfDeliveryTitleAndDateList: outOfDeliveryList,
        deliveredTitleAndDateList: deliveredList,
        shippedTitleAndDateList: shippedList,
      ),
    );
  }
}
