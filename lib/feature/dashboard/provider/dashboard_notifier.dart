import 'package:flutter_riverpod/flutter_riverpod.dart';

class DashboardNotifier extends Notifier<int> {
  @override
  int build() => 0;

  void setIndex(int index) {
    if (state != index) {
      state = index;
    }
  }
}

final dashboardNotifierProvider =
    NotifierProvider.autoDispose<DashboardNotifier, int>(
      DashboardNotifier.new,
    );
