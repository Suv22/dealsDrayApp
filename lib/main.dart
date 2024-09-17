import 'package:dealsdrayapp/api_repos/deviceinfo_repo.dart';
import 'package:dealsdrayapp/blocs/device_info_bloc/deviceinfo_bloc.dart';
import 'package:dealsdrayapp/screens/main_screen.dart';
import 'package:dealsdrayapp/screens/login_screen.dart';
import 'package:dealsdrayapp/screens/otp_screen.dart';
import 'package:dealsdrayapp/screens/register_screen.dart';
import 'package:dealsdrayapp/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyApp()
   ) );
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final PostDeviceInfoRepo postDeviceInfoRepo = PostDeviceInfoRepo();
    
    return MultiBlocProvider(
      providers: [
        BlocProvider<DeviceInfoBloc>(
          create: (context) => DeviceInfoBloc(postDeviceInfoRepo: postDeviceInfoRepo),
        ),
       
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SplashScreen()),
      );
  }
}