import 'dart:async';

import 'package:dealsdrayapp/screens/Home_screen.dart';
import 'package:dealsdrayapp/screens/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OtpVerifyScreen extends StatefulWidget {
  const OtpVerifyScreen({super.key});

  @override
  State<OtpVerifyScreen> createState() => _OtpVerifyScreenState();
}

class _OtpVerifyScreenState extends State<OtpVerifyScreen> {
  late Timer _timer;
  int _start = 120;
  String phoneNumber = '';
  @override
  void initState() {
    super.initState();
    startTimer();
    getPhoneNumber();
  }

  getPhoneNumber() async {
    var prefs = await SharedPreferences.getInstance();
    phoneNumber = prefs.getString("number").toString();
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_start > 0) {
        setState(() {
          _start--;
        });
      } else {
        _timer.cancel();
      }
    });
  }

  String get timerText {
    int minutes = _start ~/ 60;
    int seconds = _start % 60;
    return '${minutes.toString().padLeft(2, '0')} : ${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    double scrHeight = MediaQuery.of(context).size.height;
    double scrWidth = MediaQuery.of(context).size.width;
    return GestureDetector(
        child: Scaffold(
            body: Stack(children: [
      Image.asset("assets/otpImage.png"),
      ListView(children: [
        Padding(
          padding: EdgeInsets.only(left: 20, right: 20, top: scrHeight / 4),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(15, 30, 15, 50),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 40,
                ),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "OTP Verification",
                    style: TextStyle(
                        fontSize: 33,
                        color: Color.fromARGB(255, 72, 72, 72),
                        fontWeight: FontWeight.w700),
                  ),
                ),
                SizedBox(
                  height: scrHeight / 40,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "We have sent a unique OTP number \nto your mobile number +91$phoneNumber",
                    style: const TextStyle(
                        fontSize: 16,
                        color: Color.fromARGB(255, 184, 183, 183),
                        fontWeight: FontWeight.w500),
                  ),
                ),
                SizedBox(
                  height: scrHeight / 15,
                ),
                OtpTextField(
                  fieldWidth: 45,
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  numberOfFields: 4,
                  showFieldAsBox: true,
                  enabledBorderColor: const Color.fromARGB(255, 151, 151, 151),
                  borderWidth: 1,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  onCodeChanged: (String code) {},
                  onSubmit: (String verificationCode) {
                    // showDialog(
                    //     context: context,
                    //     builder: (context) {
                    //       return const AlertDialog(
                    //           shape: Border.symmetric(
                    //               horizontal: BorderSide(color: Colors.black)),
                    //           title: Text("Verifying Code"),
                    //           content: CircularProgressIndicator(
                    //             backgroundColor:
                    //                 Color.fromARGB(255, 206, 37, 25),
                    //             color: Colors.white,
                    //             strokeWidth: 5,
                    //           ));
                    //     });
                    //     Navigator.of(context).pop(context);

                      Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                          builder: (context) => const MainScreen()),
                    );
                    
                  }, // end onSubmit
                ),
                SizedBox(
                  height: scrHeight / 50,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        timerText,
                        style: const TextStyle(
                            fontSize: 19,
                            color: Color.fromARGB(255, 79, 79, 79),
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                    const Text(
                      "SEND AGAIN",
                      style: TextStyle(
                        fontSize: 15,
                        color: Color.fromARGB(255, 160, 159, 159),
                        fontWeight: FontWeight.w700,
                        decoration: TextDecoration.underline,
                        decorationColor: Color.fromARGB(255, 160, 159, 159),
                        decorationThickness: 1,
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ]),
    ])));
  }
}
