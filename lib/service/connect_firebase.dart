import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ConnectFirebase {
// Read data from Firebase Realtime Database
  static Future realtimeRead({required String path}) async {
    String url = "https://reshop-a42f1-default-rtdb.firebaseio.com/$path.json";
    try {
      final result = await http.get(Uri.parse(url));
      return json.decode(result.body);
    } catch (e) {
      print("----- cant read any data from real time db! ----- $e");
      print("seystem.out.println()");
    }
  }

// Write data to Firebase Realtime Database
  static Future<void> realtimeWrite(
      {required String path, required Map data, String? uid}) async {
    var user = FirebaseAuth.instance.currentUser;
    var idToken = await user!.getIdToken();
    String url =
        "https://reshop-a42f1-default-rtdb.firebaseio.com/$path/$uid.json?auth=$idToken";
    try {
      final response = await http.put(Uri.parse(url), body: json.encode(data));
      if (response.statusCode == 200) {
        print("----Successfully add data to realtime firebase!----");
      } else {
        print(
            "----Failed to add data to realtime firebase----\n error code: ${response.statusCode} --- \n ${response.reasonPhrase}");
      }
    } catch (e) {
      print("----- cant write data from real time db! ----- $e");
    }
  }
}
