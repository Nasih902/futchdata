import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:futchinformation/veriables/veriables.dart';


class Firestoredata {
  Veribles varobj = Veribles();
  Future uploadDatatoFirebase() async {
    await FirebaseFirestore.instance.collection("Data").add({
      'internetConnectivityStatus': varobj.internetConnectivityStatus,
      'batteryChargingStatus': varobj.batteryChargingStatus,
      'batteryPercentage': varobj.percentage.toString(),
      'location': varobj.currentplace,
      'timestamp': varobj.timestamp.toString(),
    });
  }
  void firestoreollection(){
     CollectionReference refrs =
                  FirebaseFirestore.instance.collection("Data");
              refrs.add({//balance to add to firestore
                "internetConnectivityStatus":varobj.internetConnectivityStatus.toString(),
                "batteryChargingStatus": varobj.batteryChargingStatus.toString(),
                "currentplace": varobj.currentplace.toString()
              });
  }
}
