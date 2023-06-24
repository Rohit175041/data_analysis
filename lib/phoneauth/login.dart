import 'package:data_analysis/HomePage/ListFolder/DataList.dart';
import 'package:flutter/material.dart';
// import 'package:geotemp/HomePage/ListFolder/DataList.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class MyPhone extends StatefulWidget {
  const MyPhone({Key? key}) : super(key: key);
  static String verify = " ";
  @override
  State<MyPhone> createState() => _MyPhoneState();
}

class _MyPhoneState extends State<MyPhone> {
  TextEditingController countryController = TextEditingController();
  String phoneNumber = " ";
  final storage = const FlutterSecureStorage();
  String OTPcode = " ";
  int ChangeScreen = 0;

  final FirebaseAuth auth = FirebaseAuth.instance;
  @override
  void initState() {
    countryController.text = "+91";
    super.initState();
  }

  Future<void> sendOTP() async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: countryController.text + phoneNumber,
      timeout: const Duration(seconds: 60),
      verificationCompleted: (PhoneAuthCredential credential) {
        // showSnackBarText("Auth Completed!");
        print("Auth completed");
      },
      verificationFailed: (FirebaseAuthException e) {
        showSnackBarText("Auth Failed!");
      },
      codeSent: (String verificationId, int? resendToken) {
        showSnackBar(Colors.green, "OTP send");
        print(resendToken);
        MyPhone.verify = verificationId;
        setState(() {
          ChangeScreen = 1;
        });
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        showSnackBar(Colors.red, "Timeout");
      },
    );
  }

  Future<void> verifyOTP() async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: MyPhone.verify, smsCode: OTPcode);
      UserCredential userCredential =
          await auth.signInWithCredential(credential);
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const DataList(),
        ),
      );
      print(userCredential.user?.uid);
      await storage.write(key: 'uid', value: userCredential.user?.uid);
    } catch (e) {
      print("Wrong Otp");
      showSnackBar(Colors.red, "Wrong OTP");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Container(
              color: Colors.white30,
              margin: const EdgeInsets.only(left: 25, right: 25),
              alignment: Alignment.center,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                        height: 160,
                        width: 160,
                        child: Lottie.asset('img/cycle.json')),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      "Phone Verification",
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      "We need to register your phone without getting started!",
                      style: TextStyle(
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ChangeScreen == 0 ? phonescreen() : otpScreen()
                  ],
                ),
              ))),
    );
  }

  void showSnackBarText(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
      ),
    );
  }

  Widget phonescreen() {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
              border: Border.all(width: 1, color: Colors.grey),
              borderRadius: BorderRadius.circular(10)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                width: 10,
              ),
              SizedBox(
                width: 40,
                child: TextField(
                  controller: countryController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                  ),
                ),
              ),
              const Text(
                "|",
                style: TextStyle(fontSize: 33, color: Colors.grey),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                  child: Center(
                child: TextField(
                  onChanged: (value) {
                    phoneNumber = value;
                  },
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: "Phone",
                  ),
                ),
              ))
            ],
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        SizedBox(
          width: double.infinity,
          height: 40,
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade600,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10))),
              onPressed: () async {
                if (phoneNumber.length == 10) {
                  sendOTP();
                  print(MyPhone.verify);
                  print(phoneNumber);
                } else {
                  showSnackBar(Colors.red, "Enter valid number");
                  // showSnackBarText("Enter Valid number");
                }
              },
              child: const Text("Send the code ")),
        )
      ],
    );
  }

  Widget otpScreen() {
    return Column(
      children: [
        PinCodeTextField(
          keyboardType: TextInputType.phone,
          appContext: context,
          length: 6,
          onChanged: (value) {
            setState(() {
              OTPcode = value;
            });
          },
          pinTheme: PinTheme(
            activeColor: Colors.black,
            selectedColor: Colors.red,
            inactiveColor: Colors.black26,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        SizedBox(
          width: double.infinity,
          height: 45,
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade600,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10))),
              onPressed: () async {
                verifyOTP();
              },
              child: const Text("Verify Phone Number")),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
                onPressed: () {
                  setState(() {
                    ChangeScreen = 0;
                  });
                },
                child: const Text(
                  "Edit Phone Number ?",
                  style: TextStyle(color: Colors.blue),
                )),
            TextButton(
                onPressed: () {
                  setState(() {
                    ChangeScreen = 0;
                  });
                  sendOTP();
                },
                child: const Text(
                  "resend OTP",
                  style: TextStyle(color: Colors.blue),
                )),
          ],
        ),
        const SizedBox(height: 5)
      ],
    );
  }

  void showSnackBar(dynamic color, String text) {
    var snackBar = SnackBar(
        backgroundColor: color,
        duration: const Duration(seconds: 1),
        content: Text(text));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
