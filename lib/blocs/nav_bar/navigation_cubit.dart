import 'package:flutter_bloc/flutter_bloc.dart';

class NavigationCubit extends Cubit<int> {
  NavigationCubit() : super(0);
  
  void changeTab(int index) {
    try {
      emit(index);
    } catch (e) {
      print('Error changing tab: $e');
    }
  }
}
