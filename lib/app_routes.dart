import 'package:attendence110/Features/screens/otpScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'Features/screens/all_employees.dart';
import 'Features/screens/local_attendance_data.dart';
import 'Features/screens/home_screen.dart';
import 'Features/screens/leaveScreen.dart';
import 'Features/screens/loginScreen.dart';
import 'Features/screens/qrGenerator.dart';
import 'Features/screens/qrcodeScanner.dart';

class AppRoutes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case 'home':
        return MaterialPageRoute(builder: (_) => HomeScreen());
    // Add more routes as needed
      case 'login':
        return MaterialPageRoute(builder: (_) => LoginScreen());
    // Add more routes as needed
      case 'Scanner':
        return MaterialPageRoute(builder: (_) => QRCodeScannerApp());
    // Add more routes as needed
      case 'otp':
        return MaterialPageRoute(builder: (_) => OtpScreen());
    // Add more routes as needed
      case 'leave':
        return MaterialPageRoute(builder: (_) => Leave_Screen());
    // Add more routes as needed
      case 'allEmployees':
        return MaterialPageRoute(builder: (_) => AllEmployee());
    // Add more routes as needed
        case 'localAttendance':
        return MaterialPageRoute(builder: (_) => AttendanceScreen());
    // Add more routes as needed
    //   case 'entryGate':
    //     return MaterialPageRoute(builder: (_) => QRCodeGenerator(latitude: 40.7128, longitude: 74.0060,));
    // // Add more routes as needed
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}