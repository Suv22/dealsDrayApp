import 'dart:convert';

import 'package:dealsdrayapp/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final email = TextEditingController();
  final password = TextEditingController();
  final referalCode = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Future<void> logInWithPhoneNumber(String phoneNumber) async {
    // const String apiUrl = 'http://devapiv4.dealsdray.com/api/v2/user/otp';
  var prefs = await SharedPreferences.getInstance();
    String deviceId = prefs.getString("otp").toString();
    print(deviceId);
    try {
      final response = await http.post(
        Uri.parse("http://devapiv4.dealsdray.com/api/v2/user/email/referral"),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "email": email,
          "password": password,
          "referralCode": referalCode,
          "userId": deviceId
        }),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        String message = responseData["data"]["message"];
        print('Login successful: $responseData');
        if (message == "OTP send successfully ") {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => const LogInScreen(),
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
                const SizedBox(
                  height: 10,
                ),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Let's Begin!",
                    style: TextStyle(
                        fontSize: 30,
                        color: Color.fromARGB(255, 72, 72, 72),
                        fontWeight: FontWeight.w700),
                  ),
                ),
                SizedBox(
                  height: scrHeight / 30,
                ),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Please enter your credentials to prceed",
                    style: TextStyle(
                        fontSize: 17,
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
                        controller: email,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          hintText: "Your Email",
                          hintStyle: TextStyle(
                            color: Color.fromARGB(255, 186, 186, 186),
                          ),
                        ),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Field can't be empty";
                          }
                          if (value.length != 10) {
                            return "Please enter a valid Email Address";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: password,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          hintText: "Create Password",
                          suffixIcon: Icon(Icons.remove_red_eye,
                              color: Color.fromARGB(255, 186, 186, 186)),
                          hintStyle: TextStyle(
                            color: Color.fromARGB(255, 186, 186, 186),
                          ),
                        ),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Field can't be empty";
                          }
                          if (value.length != 7) {
                            return "Password Length must be 7";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: referalCode,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          hintText: "Referral Code(Optional)",
                          hintStyle: TextStyle(
                            color: Color.fromARGB(255, 186, 186, 186),
                          ),
                        ),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Field can't be empty";
                          }
                          if (value.length != 10) {
                            return "Please enter a valid Email Address";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const SizedBox(
                        height: 45,
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: SizedBox(
                            width: scrWidth / 7,
                            height: scrHeight / 11.9,
                            child: FloatingActionButton(
                                shape: const RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                onPressed: () {},
                                backgroundColor:
                                    const Color.fromARGB(255, 206, 37, 25),
                                child: const Icon(
                                  Icons.arrow_forward,
                                  color: Colors.white,
                                  size: 30,
                                ))),
                      ),
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
