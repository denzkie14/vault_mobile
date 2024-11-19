import 'package:get/get.dart';

class DashboardController extends GetxController {
  var toggleButtonIndex = 0.obs;
  List<bool> isSelected = [true, false, false];

  updateButtonIndex(int index) {
    toggleButtonIndex(index);
  }
}
