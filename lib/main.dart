// import 'dart:io';
//
// import 'package:attendence110/Features/bloc/attendance/attendance_bloc.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:attendence110/app_routes.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
//
//
// void main() async {
//   FlutterError.onError = (details) {
//     FlutterError.presentError(details);
//     if (kReleaseMode) exit(1);
//   };
//
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MultiBlocProvider(
//       providers: [
//         BlocProvider(
//             create: (context) =>
//                 AttendanceBloc()), // Replace with your actual BLoC
//
//       ],
//       child: MaterialApp(
//         debugShowCheckedModeBanner: false,
//         onGenerateRoute: AppRoutes.generateRoute,
//         initialRoute: 'login',
//         // home: BottomNavigation(),
//       ),
//     );
//   }
// }


import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import shared_preferences package
import 'Features/bloc/attendance/attendance_bloc.dart';
import 'Features/screens/local_attendance_data.dart';
import 'Features/screens/popup.dart';
import 'app_routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure Flutter's binding is initialized first

  // WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  // FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);// Ensure Flutter's binding is initialized first

  FlutterError.onError = (details) {
    FlutterError.presentError(details);
    if (kReleaseMode) exit(1);
  };

  // Check if the user is already logged in
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
  String initialRoute = isLoggedIn ? 'home' : 'login';

  runApp(MyApp(initialRoute: initialRoute));
  // FlutterNativeSplash.remove();

}

class MyApp extends StatelessWidget {
  final String initialRoute;

  const MyApp({Key? key, required this.initialRoute}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AttendanceBloc(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        onGenerateRoute: AppRoutes.generateRoute,
        initialRoute: initialRoute,
        // home: AttendanceScreen()
      ),
    );
  }
}
