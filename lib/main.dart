import 'package:data_analysis/HomePage/ListFolder/DataList.dart';
import 'package:data_analysis/phoneauth/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:geotemp/HomePage/ListFolder/DataList.dart';
// import 'package:geotemp/phoneauth/login.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final storage = const FlutterSecureStorage();
  Future<bool> checkLoginStatus() async {
    String? value = await storage.read(key: 'uid');
    if (value == null) {
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Login',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        debugShowCheckedModeBanner: false,
        // home:DataList()
        // home:MyPhone(),
        home: FutureBuilder(
            future: checkLoginStatus(),
            builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
              if (snapshot.data == false) {
                return const MyPhone();
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Container(
                    color: Colors.white,
                    child: const Center(child: CircularProgressIndicator()));
              }
              return const DataList();
            }));
  }
}

//wait storage.delete(key:'uid');
