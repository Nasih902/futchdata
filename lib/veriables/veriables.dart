import 'dart:async';

import 'package:battery_plus/battery_plus.dart';

class Veribles{
 String? internetConnectivityStatus;
  String? batteryChargingStatus;
  DateTime? timestamp;
  Timer? timer;
  int restart = 0;
  var battery = Battery();
  int percentage = 0;
  BatteryState batterystate = BatteryState.full;
  String? currentplace;
}