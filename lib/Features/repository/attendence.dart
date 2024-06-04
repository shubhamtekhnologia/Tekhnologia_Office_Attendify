import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'deviceinfoapi.dart';

class AttendanceRepo {
  static final String baseUrl = "http://theprtechnologies.com/attendance_new";
  // static final String baseUrl = "http://192.168.1.73:8000";

  static Future<bool> Attendance(String inTime, String outTime,String employeeId) async {
    var client = http.Client();
    try {
      final url = Uri.parse('$baseUrl/api/record-attendance');

   print(employeeId);
   print(inTime);
   print(outTime);
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "emp_id":employeeId,
          "inTime":inTime,
          "outTime":outTime
        }),
      );
      print(response.body);
      if (response.statusCode == 200) {
        // Parse the response JSON
        final responseData = jsonDecode(response.body);

        // Check the status field from the response
        if (responseData['status'] == true) {
          // Credentials are valid
          print("Sucess");
          return true;
        } else {
          // Credentials are invalid
          print("Server message: ${responseData['message']}");
          return false;
        }
      } else {
        // Handle non-200 status codes
        print('Server error. Status code: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      // Handle any errors
      print('Error: $e');
      return false;
    } finally {
      client.close();
    }
  }


//******************************************************************************


  static Future<Map<String, dynamic>> fetchData() async {
    SharedPreferences pref= await SharedPreferences.getInstance();
    String? employeeId=pref.getString('employeeId');

    // Map<String, String> deviceInfo = await DeviceInformation.getDeviceInfo();
    final response = await http.post(
      Uri.parse('$baseUrl/api/attendance/listing'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'emp_id':  employeeId ?? 'Unknown',

      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load data');
    }
  }

//******************************************************************************


  static Future<bool> sendAttendanceToServer({
    required String? employeeId,
    required String inTime,
    required String outTime,
  }) async {
    final url = Uri.parse('$baseUrl/api/record-local-data');
    final attendanceData = {
      "attendanceData": [
        {
          "emp_id": employeeId,
          "intime": inTime,
          "outime": outTime
        }
      ]
    };

    final headers = {
      'Content-Type': 'application/json',
    };

    try {
      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(attendanceData),
      );

      if (response.statusCode == 201) {
        print('Data sent to server successfully');
        return true;
      } else {
        print('Failed to send data to server: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Exception while sending data to server: $e');
      return false;
    }
  }

//******************************************************************************

  static Future<List<dynamic>> fetchLeaveApplicationsStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? employeeId = prefs.getString('employeeId');

    List<dynamic> leaveApplications = [];

    if (employeeId != null) {
      try {
        final url = '$baseUrl/api/leave-applications';
        final response = await http.post(
          Uri.parse(url),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({"employee_id": employeeId}),
        );

        if (response.statusCode == 200) {
          leaveApplications = jsonDecode(response.body);
        } else {
          throw Exception('Failed to fetch leave applications: ${response.statusCode}');
        }
      } catch (e) {
        print('Error fetching leave applications: $e');
      }
    } else {
      print('Employee ID not found. Please log in first.');
    }

    return leaveApplications;
  }



//******************************************************************************







}
