import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

enum NavigationTab {
  home(0),
  shipments(1),
  earnings(2),
  settings(3);

  const NavigationTab(this.tabIndex);
  final int tabIndex;

  static NavigationTab fromIndex(int index) {
    return NavigationTab.values.firstWhere(
      (tab) => tab.tabIndex == index,
      orElse: () => NavigationTab.home,
    );
  }
}

class NavigationState extends Equatable {
  final NavigationTab currentTab;
  final bool isNavigating;

  const NavigationState({
    required this.currentTab,
    this.isNavigating = false,
  });

  NavigationState copyWith({
    NavigationTab? currentTab,
    bool? isNavigating,
  }) {
    return NavigationState(
      currentTab: currentTab ?? this.currentTab,
      isNavigating: isNavigating ?? this.isNavigating,
    );
  }

  @override
  List<Object?> get props => [currentTab, isNavigating];
}

class NavigationCubit extends Cubit<NavigationState> {
  NavigationCubit() : super(NavigationState(currentTab: NavigationTab.home));

  void changeTab(NavigationTab tab) {
    if (state.currentTab != tab) {
      emit(state.copyWith(currentTab: tab));
    }
  }

  void setNavigating(bool isNavigating) {
    emit(state.copyWith(isNavigating: isNavigating));
  }
}
