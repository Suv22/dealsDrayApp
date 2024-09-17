import 'package:dealsdrayapp/screens/Home_screen.dart';
import 'package:dealsdrayapp/screens/main_screen.dart';
import 'package:dealsdrayapp/screens/otp_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/services/text_formatter.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LogInScreen extends StatefulWidget {
  const LogInScreen({super.key});

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  final phoneNum = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final bool _isPhoneSelected = true;
  bool phone = true;

  Future<void> logInWithPhoneNumber(String phoneNumber) async {
    // const String apiUrl = 'http://devapiv4.dealsdray.com/api/v2/user/otp';

    var prefs = await SharedPreferences.getInstance();
    String deviceId = prefs.getString("otp").toString();
    print(deviceId);

    try {
      final response = await http.post(
        Uri.parse("http://devapiv4.dealsdray.com/api/v2/user/otp"),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          // "mobileNumber": "9011470243",
          // "deviceId": "62b341aeb0ab5ebe28a758a3"

          "mobileNumber": phoneNumber,
          "deviceId": deviceId
        }),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        String message = responseData["data"]["message"];
        print('Login successful: $responseData');
        if (message == "OTP send successfully ") {
          var prefs = await SharedPreferences.getInstance();
          prefs.setString("number", phoneNum.text);
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => const OtpVerifyScreen(),
          ));
          print(message);
        } else {
          print("===================");
          print(message);
        }
      } else {
        print('Failed to log in: ${response.statusCode}');
      }
    } catch (error) {
      print('Error occurred: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    double scrHeight = MediaQuery.of(context).size.height;
    double scrWidth = MediaQuery.of(context).size.width;

    return GestureDetector(
        child: Scaffold(
            body: Stack(children: [
      Positioned.fill(
          child: Image.asset(
        "assets/logInScreen.png",
        fit: BoxFit.cover,
      )),
      ListView(children: [
        Padding(
          padding: EdgeInsets.only(left: 20, right: 20, top: scrHeight / 4),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(15, 30, 15, 50),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          phone = !phone;
                        });
                        print(phone);
                        // print(onride);
                        if (phone == true) {
                        } else if (phone == false) {}
                      },
                      child: Container(
                        width: scrWidth / 2,
                        height: 40,
                        decoration: const BoxDecoration(
                            color: Color.fromARGB(255, 217, 215, 215),
                            // border: Border.all(
                            //     color: const Color.fromARGB(255, 3, 83, 54)),
                            borderRadius:
                                BorderRadius.all(Radius.circular(30))),
                        child: Stack(children: [
                          const Center(
                            child: Padding(
                              padding: EdgeInsets.only(left: 20, right: 20),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Phone",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color:
                                            Color.fromARGB(255, 122, 121, 121)),
                                  ),
                                  Text(
                                    "Email",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color:
                                            Color.fromARGB(255, 122, 121, 121)),
                                  )
                                ],
                              ),
                            ),
                          ),
                          Align(
                              alignment: phone
                                  ? Alignment.centerLeft
                                  : Alignment.centerRight,
                              child: Container(
                                width: scrWidth * 0.25,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: const Color.fromARGB(255, 220, 43, 4),
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                child: Center(
                                  child: Text(
                                    phone ? 'Phone' : 'Email',
                                    style: TextStyle(
                                      color: phone
                                          ? const Color.fromARGB(
                                              255, 255, 255, 255)
                                          : const Color.fromARGB(
                                              255, 255, 255, 255),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              )),
                        ]),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 40,
                ),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Glad to see you!",
                    style: TextStyle(
                        fontSize: 35,
                        color: Color.fromARGB(255, 72, 72, 72),
                        fontWeight: FontWeight.w700),
                  ),
                ),
                SizedBox(
                  height: scrHeight / 40,
                ),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Please provide your phone number",
                    style: TextStyle(
                        fontSize: 18,
                        color: Color.fromARGB(255, 136, 136, 136),
                        fontWeight: FontWeight.w500),
                  ),
                ),
                SizedBox(
                  height: scrHeight / 15,
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextFormField(
                        controller: phoneNum,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(10),
                        ],
                        decoration: const InputDecoration(
                          hintText: "Phone",
                          hintStyle: TextStyle(
                            color: Color.fromARGB(255, 186, 186, 186),
                          ),
                        ),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Mobile number can't be empty";
                          }
                          if (value.length != 10) {
                            return "Please enter a valid mobile number";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 45,
                      ),
                      SizedBox(
                          width: scrWidth * 2,
                          child: FloatingActionButton(
                            shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(13))),
                            onPressed: () {
                              print("Clicked");
                              logInWithPhoneNumber(phoneNum.text);
                            },
                            backgroundColor:
                                const Color.fromARGB(255, 255, 183, 183),
                            child: const Text(
                              "SEND CODE",
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Color.fromARGB(255, 255, 255, 255)),
                            ),
                          )),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ]),
    ])));
  }
}
