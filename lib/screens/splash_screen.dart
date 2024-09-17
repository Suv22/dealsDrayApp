import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dealsdrayapp/blocs/device_info_bloc/deviceinfo_bloc.dart';
import 'package:dealsdrayapp/blocs/device_info_bloc/deviceinfo_event.dart';
import 'package:dealsdrayapp/screens/login_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  LocationPermission? _locationPermission;


  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _controller.forward();
    checkIfLocationPermissionAllowed();

    navigateToLogIn();
  }


  //get Location Permission
  Future<void> checkIfLocationPermissionAllowed() async {
    _locationPermission = await Geolocator.checkPermission();
    if (_locationPermission == LocationPermission.always) {
      _locationPermission = await Geolocator.requestPermission();
      fetchDeviceInfo();
    }
    if (_locationPermission == LocationPermission.denied) {
      _locationPermission = await Geolocator.requestPermission();
      fetchDeviceInfo();
    }
    if (_locationPermission == LocationPermission.deniedForever) {
      print("error");
    }
  }

  void fetchDeviceInfo() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    Map<String, dynamic> deviceData = {};

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      deviceData = {
        "deviceType": "android",
        "deviceId": androidInfo.id,
        "deviceName": androidInfo.model,
        "deviceOSVersion": androidInfo.version.release,
      };
      deviceData['lat'] = position.latitude;
      deviceData['long'] = position.longitude;
      var prefs = await SharedPreferences.getInstance();
      prefs.setString("otp",androidInfo.id);
     
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      deviceData = {
        "deviceType": "ios",
        "deviceId": iosInfo.identifierForVendor, // Unique ID on iOS
        "deviceName": iosInfo.utsname.machine,
        "deviceOSVersion": iosInfo.systemVersion,
      };
      deviceData['lat'] = position.latitude;
      deviceData['long'] = position.longitude;
    }
    //add IPAddress
    String? ipAddress = await getIpAddress();
    print(ipAddress);
    deviceData['deviceIPAddress'] = ipAddress;

    // add app-specific data
    deviceData['app'] = {
      "version": "1.20.5", // You can set your app version here
      "installTimeStamp": DateTime.now().toIso8601String(),
      "uninstallTimeStamp": DateTime.now().toIso8601String(),
      "downloadTimeStamp": DateTime.now().toIso8601String(),
    };

    print("===============");
    print(deviceData);

    BlocProvider.of<DeviceInfoBloc>(context).add(PostDeviceInfoEvent(deviceData));
  }

//  get IPAddress
  Future<String?> getIpAddress() async {
    try {
      final response =
          await http.get(Uri.parse('https://api.ipify.org?format=json'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['ip'];
      } else {
        print('Failed to get IP address');
        return null;
      }
    } catch (e) {
      print('Error fetching IP address: $e');
      return null;
    }
  }

  void navigateToLogIn() {
    Timer(const Duration(seconds: 4), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LogInScreen()),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Image.asset(
            'assets/splashImg.jpg',
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
