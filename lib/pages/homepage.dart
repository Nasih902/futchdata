// ignore_for_file: avoid_print
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:futchinformation/firebase/firestore.dart';
import 'package:futchinformation/style/textstyle.dart';
import 'package:futchinformation/veriables/veriables.dart';
import 'package:futchinformation/widgets/battery.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage ({super.key});

  @override
  State<HomePage > createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  Veribles varobj = Veribles();
  Firestoredata firestoreobj = Firestoredata();
  @override
  void initState() {
    super.initState();
    savethedata();
    getbatterypersantage();
    varobj.timer = Timer.periodic(const Duration(minutes: 15), (timer) async {
      await captureData();
    });
  }
  void getbatterypersantage() async {
    final level = await varobj.battery.batteryLevel;
    varobj.percentage = level;
    setState(() {});
  }
  void getBatterystate() async {
    varobj.battery.onBatteryStateChanged.listen((state) {
      varobj.batterystate = state;
      setState(() {});
    });
  }

  captureData() async {
    varobj.timestamp = DateTime.now();
  }

  @override
  void dispose() {
    varobj.timer?.cancel();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    Position? position;
    late bool servicesPermission = false;
    late LocationPermission permission;
    Future<Position?> getCurrentPosition() async {
      servicesPermission = await Geolocator.isLocationServiceEnabled();
      if (!servicesPermission) {
        print("Services Error");
      }
      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission == await Geolocator.requestPermission();
      }
      return await Geolocator.getCurrentPosition();
    }

    getheadress() async {
      try {
        List<Placemark> placemark = await placemarkFromCoordinates(
            position!.latitude, position!.longitude);
        Placemark place = placemark[0];
        setState(() {
          varobj.currentplace = "${place.locality}";
        });
      } catch (err) {
        print("An error excaption");
      }
    }

    return StreamBuilder<ConnectivityResult>(
      stream: Connectivity().onConnectivityChanged,
      builder: (context, snapshot) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Data Capture App'),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                snapshot.data == ConnectivityResult.none
                    ?  Text("Please check your internet connection",style: stylee,)
                    :  Text("connection Susscessfull",style: stylee),
                    const SizedBox(height: 30),
                buildBattery(varobj.batterystate),
                const SizedBox(height: 30),
                Text('Battery charge percentage: ${varobj.percentage}',style: stylee),
                const SizedBox(height: 30),
                Text('Location: ${varobj.currentplace}',style: stylee),
                const SizedBox(height: 30),
                Text('Timestamp: ${varobj.timestamp}',style: stylee),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              var prefs = await SharedPreferences.getInstance();
              prefs.setString("internetConnectivityStatus",
                  varobj.internetConnectivityStatus.toString());
              prefs.setString(
                  "batteryChargingStatus",varobj.batteryChargingStatus.toString());
              prefs.setString("currentplace", varobj.currentplace.toString());
              prefs.setString("Batterystate", varobj.batterystate.toString());
              prefs.setString("Timestamp", varobj.timestamp.toString());
              firestoreobj.firestoreollection();
              position = await getCurrentPosition();
              await getheadress();
              await captureData();
              setState(() {
                varobj.internetConnectivityStatus = varobj.internetConnectivityStatus;
                varobj.batteryChargingStatus = varobj.batteryChargingStatus;
                varobj.percentage = varobj.percentage;
                position = position;
                varobj.timestamp = varobj.timestamp;
              });
            },
            child: const Text("DATA"),
          ),
        );
      },
    );
  }
  void savethedata() async {
    var prefs = await SharedPreferences.getInstance();
    prefs.getString("internetConnectivityStatus");
    prefs.getString("batteryChargingStatus");
    prefs.getString("currentplace");
    prefs.getString("Batterystate");
    prefs.getString("Timestamp");
  }
}
