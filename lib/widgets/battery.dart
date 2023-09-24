import 'package:battery_plus/battery_plus.dart';
import 'package:flutter/material.dart';
import 'package:futchinformation/style/textstyle.dart';

Widget buildBattery(BatteryState state) {
    switch (state) {
      case BatteryState.full:
        return  Text("Battery is Full",style: stylee);
      case BatteryState.charging:
        return  Text("Battery is charging",style: stylee);
      case BatteryState.discharging:
      default:
        return  Text("Battery is discharge",style: stylee);
    }
  }