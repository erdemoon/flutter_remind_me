import 'package:get/get.dart';

class Controller extends GetxController{
  var conventionUnit = 'metric'.obs;

  changeUnit(unit){
    conventionUnit = unit;
  }
}
