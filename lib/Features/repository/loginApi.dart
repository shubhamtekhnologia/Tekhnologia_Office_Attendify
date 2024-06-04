// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
//
// class LoginAPI {
//   static Future<bool> validateMobileNumber(String mobileNumber) async {
//     // Replace the URL with your server endpoint
//     final String url = 'http://192.168.31.125:8000/api/login';
//
//
//     try {
//       final response = await http.post(
//         Uri.parse(url),
//         headers: {
//           'Content-Type': 'application/json', // Set the content type to JSON
//         },
//         body: jsonEncode({'mobile': mobileNumber}),
//       );
//
//       if (response.statusCode == 200) {
//         print(response.body);
//         // Assuming server response will be JSON with a key 'isValid'
//        final data = jsonDecode(response.body);
//        //  SharedPreferences prefs = await SharedPreferences.getInstance();
//        //  await prefs.setString('employeeId', data['emp_id']);
//        //  return data['success'] ?? false;
//         // Ensure emp_id is a string before storing it
//         String? employeeId = data['emp_id'].toString();
//         if (employeeId != null) {
//           // Save employee ID in SharedPreferences
//           SharedPreferences prefs = await SharedPreferences.getInstance();
//           await prefs.setString('employeeId', employeeId);
//           return true;
//         } else {
//           throw Exception('Employee ID is null');
//         }
//       } else {
//         throw Exception('Failed to validate mobile number: ${response.statusCode} ${response.body}');
//       }
//     } catch (e) {
//       throw Exception('Failed to connect to the server: $e');
//     }
//   }
// }
//*****************************************
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:shared_preferences/shared_preferences.dart';

class LoginAPI {
  static Future<bool> validateMobileNumber(String mobileNumber) async {
    // Replace the URL with your server endpoint
    final String url = 'http://theprtechnologies.com/attendance_new/api/login';
    // final String url = 'http://192.168.1.73:8000/api/login';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json', // Set the content type to JSON
        },
        body: jsonEncode({'mobile': mobileNumber}),
      );

      if (response.statusCode == 200) {
        print(response.body);
        // Assuming server response will be JSON with employee details
        final data = jsonDecode(response.body);

        String? employeeId = data['emp_id'].toString();
        String? empName = data['name'].toString();
        String? empEmail = data['email'].toString();
        String? firm_id = data['emp_firm_id'].toString();
        print(firm_id);

        if (employeeId != null && empName != null && empEmail != null && firm_id != null) {
          // Save employee details in SharedPreferences
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('employeeId', employeeId);
          await prefs.setString('empName', empName);
          await prefs.setString('empEmail', empEmail);
          await prefs.setString('firm_id', firm_id, );
          return true;
        } else {
          throw Exception('Employee details are null');
        }
      } else {
        throw Exception('Failed to validate mobile number: ${response.statusCode} ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to connect to the server: $e');
    }
  }
}
