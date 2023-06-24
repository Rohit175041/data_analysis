import 'package:flutter/material.dart';
import 'package:http/http.dart'as http;
import 'package:lottie/lottie.dart';
// import 'package:simple_animations/simple_animations.dart';
import 'dart:convert';

enum AnimationType { opacity, translateY }

class DeviceConnection extends StatefulWidget {
  const DeviceConnection({Key? key}) : super(key: key);

  @override
  State<DeviceConnection> createState() => _DeviceConnectionState();
}

class _DeviceConnectionState extends State<DeviceConnection> {
  final TextEditingController name1 = TextEditingController();
  final TextEditingController password1 = TextEditingController();
  int x=1;
  bool hidePassword = true;
  var formKey = GlobalKey<FormState>();

  void  createUser() async{
    const  url ="https://temp-8ec02-default-rtdb.firebaseio.com/TempDateData.json/Device_id/Device_id.json";
   // const url="https://geotemp-62b52-default-rtdb.asia-southeast1.firebasedatabase.app/data/name1.json";
    try{
     final response = await http.put(Uri.parse(url),
       body: json.encode({"name":name1.text,"password":password1.text }),
     );
     print(response.body);
     if(response.statusCode==201){
       showSnackBar(Colors.green,"Submit");
     }
    }
   catch (e){
      print(e);
    }
   }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [Colors.black12,Colors.white],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter
            )
        ),
        child: Column(
          children: [
            Container(
              height: 140,
                width: 300,
                margin: const EdgeInsets.only(top: 80),
                child: Lottie.asset("img/Loading.json",fit: BoxFit.fill)
                ),
            Expanded(
              child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(50),
                          topRight: Radius.circular(50))),
                  margin: const EdgeInsets.only(top: 10),
                  child: SingleChildScrollView(
                    child: Form(
                      key: formKey,
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 6,
                          ),
                          Container(
                            // color: Colors.red,
                              alignment: Alignment.topLeft,
                              margin: const EdgeInsets.only(left: 22, bottom: 0),
                              child:
                                const Center(
                                  child: Text(
                                    " Network",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                        fontSize: 30,
                                        color: Colors.black87,
                                        letterSpacing: 2,
                                        fontStyle: FontStyle.italic),
                                  ),
                                ),
                              ),
                            Container(
                                width: double.infinity,
                                height: 70,
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 20),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 5),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.black12, width: 1),
                                    boxShadow: const [
                                      BoxShadow(
                                          color: Colors.black12,
                                          blurRadius: 10,
                                          offset: Offset(1, 1)),
                                    ],
                                    color: Colors.white,
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(20))),
                                child: nameBox(),
                            ),
                            Container(
                                width: double.infinity,
                                height: 70,
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 20),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 5),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.black12, width: 1),
                                    boxShadow: const [
                                      BoxShadow(
                                          color: Colors.black12,
                                          blurRadius: 10,
                                          offset: Offset(1, 1)),
                                    ],
                                    color: Colors.white,
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(20))),
                                child :passwordBox(),
                            ),
                          const SizedBox(
                            height: 10,
                          ),
                            ElevatedButton(

                              onPressed: (){
                                submitbutton();
                              },
                              style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.white, shadowColor: Colors.black12,
                                  elevation: 1,
                                  padding: EdgeInsets.zero,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20))),
                              child: Ink(
                                decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                        colors: [Colors.white,Colors.white],
                                        begin: Alignment.bottomCenter,
                                        end: Alignment.topCenter
                                    ),
                                    borderRadius: BorderRadius.circular(20)),
                                child: Container(
                                  // width: 300,
                                  height: 100,
                                  alignment: Alignment.center,
                                  child: const Text("submit",style: TextStyle(color: Colors.black),),
                                  // child: Lottie.asset("img/press.json",width:200,fit: BoxFit.fill),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  )),
            )
          ],
        ),
      ),
    );
  }
  void  showSnackBar(dynamic color,String text){
    var snackBar = SnackBar(
      backgroundColor: color,
        duration: const Duration(milliseconds:500),
        content: Text(text));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);

  }

  void submitbutton(){
    final isValid = formKey.currentState!.validate();
    if (!isValid) {
      password1.clear();

      name1.clear();
      showSnackBar(Colors.red,"Not Submit");
      return;
    }
    formKey.currentState!.save();
    createUser();
    showSnackBar(Colors.green,"Submit");
    password1.clear();
    name1.clear();
  }

 Widget passwordBox() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const Icon(Icons.wifi_lock),
        Expanded(
          child: Container(
            margin: const EdgeInsets.only(left: 10),
            child: TextFormField(
              controller:password1,
              obscureText:  hidePassword,
              validator: (password1) => password1!.length < 5
                  ? "Password should be more than 5 characters"
                  : null,
              maxLines: 1,
              cursorColor: Colors.black,
              decoration:  const InputDecoration(
                hintText: "Password",
                hintStyle: TextStyle(
                  color: Colors.black,
                ),
                border: InputBorder.none,
              ),
            ),
          ),
        ),
        IconButton(
          icon: Icon(hidePassword
              ? Icons.visibility_off
              : Icons.visibility),
          onPressed: () {
              setState((){
                hidePassword = !hidePassword;
              });
          },
        ),
      ],
    );
 }

 Widget nameBox(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const Icon(Icons.drive_file_rename_outline_rounded),
        Expanded(
          child: Container(
            margin: const EdgeInsets.only(left: 10),
            child: TextFormField(
              controller:name1,
              validator: (name1) => name1!.length < 5
                  ? "Enter a valid id"
                  : null,
              maxLines: 1,
              cursorColor: Colors.black,
              decoration: const InputDecoration(
                hintText: " Device-id",
                hintStyle: TextStyle(
                  color: Colors.black,
                ),
                border: InputBorder.none,
              ),
            ),
          ),
        ),
      ],
    );
 }
}
