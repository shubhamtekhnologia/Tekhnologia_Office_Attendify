import 'dart:async';
import 'dart:convert';

import 'package:attendence110/Features/bloc/attendance/attendance_bloc.dart';
import 'package:attendence110/Features/bloc/attendance/attendance_event.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../LocalDatabase/attendence.dart';
import '../repository/attendence.dart';
import '../repository/deviceinfoapi.dart';


class QRCodeScannerApp extends StatefulWidget {
  @override
  QRCodeScannerAppState createState() => QRCodeScannerAppState();
}

class QRCodeScannerAppState extends State<QRCodeScannerApp> {
  late QRViewController _controller;
  final GlobalKey _qrKey = GlobalKey(debugLabel: 'QR');
  String scannedData = '';
  bool successMessageShown = false;
  // String? deviceId;


  // @override
  // Future<void> initState() async {
  //   String deviceId = await _getDeviceId();
  //   super.initState();
  // }
  void dispose() {
    setState(() {
      _controller.dispose();
    });
    super.dispose();
  }



  static Future<void> syncDataWithServer() async {
    String deviceId = await _getDeviceId();

    SharedPreferences pref = await SharedPreferences.getInstance();
    String? employeeId= pref.getString('employeeId');

    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult != ConnectivityResult.none) {
      final unsyncedAttendance = await DatabaseHelper().getAttendanceForToday(deviceId);
      bool allSuccess = true;

      for (final attendance in unsyncedAttendance) {
        bool success = await AttendanceRepo.sendAttendanceToServer(
          employeeId: employeeId,
          inTime: attendance['inTime'],
          outTime: attendance['outTime'],
        );

        if (success) {
          // If data is successfully synced, delete the attendance from the local database
          await DatabaseHelper().deleteAttendanceById(attendance['deviceId']);
        } else {
          // Handle sync failure
          allSuccess = false;
        }
      }
      if (allSuccess) {
        // Optionally, you can perform actions if all data is successfully synced
      }
    } else {
      // No network connection, you may choose to handle this case differently
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text('QR Code Scanner'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        body: Column(
          children: [
            Expanded(
              flex: 5,
              child: QRView(
                key: _qrKey,
                onQRViewCreated: _onQRViewCreated,
              ),
            ),
            Expanded(
              flex: 1,
              child: Center(
                child: Text('Scanned Data: $scannedData'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) async {
    setState(() {
      _controller = controller;
      _controller.scannedDataStream.listen((scanData) async {
        if (!successMessageShown) {
          setState(() {
            scannedData = scanData.code ?? 'No data found';
          });
          successMessageShown = true;

          await _showSuccessMessage();
          _controller.dispose();

        }
        try {
          // Get device ID
          String deviceId = await _getDeviceId();
          SharedPreferences pref=await SharedPreferences.getInstance();
           String? employeeId=pref.getString('employeeId');

          // Request permission to access device's location
          bool locationPermission = await _requestLocationPermission();
          if (!locationPermission) {
            // Permission denied, show error message
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Error'),
                  content: Text(
                      'User denied permissions to access the device\'s location.'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('OK'),
                    ),
                  ],
                );
              },
            );
            return; // Exit the method
          }

          // Get current location
          Position currentPosition = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high,
          );
          print('Current latitude: ${currentPosition
              .latitude}, longitude: ${currentPosition.longitude}');


          // Check if the scanData is not null and contains latitude and longitude
          if (scanData.code != null && scanData.code!.contains(',')) {
            print('mystep 1');
            // Parse latitude and longitude from the scan data
            List<String> qrDataParts = scanData.code!.split(',');
            // double? qrLatitude = double.tryParse(qrDataParts[0]);
            // double? qrLongitude = double.tryParse(qrDataParts[1]);

            print('mystep 2');
            print(qrDataParts);
            int idx = scanData.code!.indexOf("=");
            List parts_my = [scanData.code!.substring(0,idx).trim(), scanData.code!.substring(idx+1).trim()];

            print('mystep 2 aft');

            print(parts_my);
            // double? qrLongitude_f = double.tryParse(parts_my[1]);
            print('my fresult  $scanData.code!.substring(idx+1).trim()');
            print( scanData.code!.substring(idx+1).trim());
            List<String> qrDataParts_2 =  scanData.code!.substring(idx+1).trim().split(',');
            double? qrLatitude = double.tryParse(qrDataParts_2[0]);
            double? qrLongitude = double.tryParse(qrDataParts_2[1]);
            print(qrDataParts_2[0]);
            print(qrDataParts_2[1]);
            print('mystep 2 aft 2');


            // Compare current location with QR code data
            if (qrLatitude != null &&
                qrLongitude != null &&
                _isWithin100MeterRadius(
                    currentPosition.latitude,
                    currentPosition.longitude,
                    qrLatitude,
                    qrLongitude)) {
              // Location matched, proceed with storing data
              DatabaseHelper dbHelper = DatabaseHelper();
              List<Map<String, dynamic>> result =
              await dbHelper.getAttendanceForToday(deviceId);

              // await DatabaseHelper().deleteAttendanceById(deviceId);

              if (result.isEmpty) {
                // First scan, store in-time
                String inTime = DateTime.now().toString();
                print(inTime);
                await dbHelper.insertAttendance(inTime, '', deviceId);
                print('step 1 $inTime');
                BlocProvider.of<AttendanceBloc>(context).add(
                  AttendanceDataPostEvent(
                    inTime: inTime,
                    outTime: '',
                    employeeId: employeeId,
                  ),
                );
                _controller.dispose();

              } else {

                // Second scan, update out-time
                String outTime = DateTime.now().toString();
                print("shubham$outTime");

                // await dbHelper.insertOutAttendance(result.first['id'], outTime, deviceId);
                await dbHelper.updateOutTime(result.first['id'], outTime);
                print('step 2 $outTime');
                Future.delayed(Duration(seconds: 100));
                BlocProvider.of<AttendanceBloc>(context).add(
                  AttendanceDataPostEvent(
                    inTime: result.first['inTime'],
                    outTime: outTime,
                    employeeId: employeeId,
                  ),
                );
                _controller.dispose();


              }

              // Print locally stored data on console
              List<Map<String, dynamic>> attendanceData =
              await dbHelper.getAllAttendance();
              print('Locally stored attendance data: $attendanceData');


              _controller.dispose();
            } else {
              // Location not matched, show error message
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Error'),
                    content:
                    Text('Location does not match with QR code data.'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('OK'),
                      ),
                    ],
                  );
                },
              );
            }
          } else {
            // Invalid QR code data format, show error message
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Error'),
                  content: Text('Invalid QR code data format.'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('OK'),
                    ),
                  ],
                );
              },
            );
          }
        } catch (e) {
          print('Error: $e');
        }
      });
    });
  }

  static Future<String> _getDeviceId() async {
    Map<String, String> deviceInfo = await DeviceInformation.getDeviceInfo();
    return deviceInfo['deviceId'] ?? '';
  }

  Future<bool> _requestLocationPermission() async {
    // Request permission to access device's location
    LocationPermission permission = await Geolocator.requestPermission();
    return permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse;
  }

  Future<void> _showSuccessMessage() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Success'),
          content: Text('QR Code successfully scanned!'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                // Navigator.pushNamed(context, "home");

                Navigator.pushReplacementNamed(context, "home");

                _controller.dispose();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  bool _isWithin100MeterRadius(
      double currentLat, double currentLong, double qrLatitude, double qrLongitude) {
    double distanceInMeters = Geolocator.distanceBetween(
      currentLat,
      currentLong,
      qrLatitude,
      qrLongitude,
    );
    return distanceInMeters <= 100;
  }
}

//
// import 'dart:async';
// import 'dart:convert';
//
// import 'package:attendence110/Features/bloc/attendance/attendance_bloc.dart';
// import 'package:attendence110/Features/bloc/attendance/attendance_event.dart';
// import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:qr_code_scanner/qr_code_scanner.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
//
// import '../LocalDatabase/attendence.dart';
// import '../repository/attendence.dart';
// import '../repository/deviceinfoapi.dart';
//
//
// class QRCodeScannerApp extends StatefulWidget {
//   @override
//   QRCodeScannerAppState createState() => QRCodeScannerAppState();
// }
//
// class QRCodeScannerAppState extends State<QRCodeScannerApp> {
//   late QRViewController _controller;
//   final GlobalKey _qrKey = GlobalKey(debugLabel: 'QR');
//   String scannedData = '';
//   bool successMessageShown = false;
//   // String? deviceId;
//
//
//   // @override
//   // Future<void> initState() async {
//   //   String deviceId = await _getDeviceId();
//   //   super.initState();
//   // }
//   void dispose() {
//     setState(() {
//       _controller.dispose();
//     });
//     super.dispose();
//   }
//
//
//
//   static Future<void> syncDataWithServer() async {
//     String deviceId = await _getDeviceId();
//
//     SharedPreferences pref = await SharedPreferences.getInstance();
//     String? employeeId= pref.getString('employeeId');
//
//     final connectivityResult = await Connectivity().checkConnectivity();
//     if (connectivityResult != ConnectivityResult.none) {
//       final unsyncedAttendance = await DatabaseHelper().getAttendanceForToday(deviceId);
//       bool allSuccess = true;
//
//       for (final attendance in unsyncedAttendance) {
//         bool success = await AttendanceRepo.sendAttendanceToServer(
//           employeeId: employeeId,
//           inTime: attendance['inTime'],
//           outTime: attendance['outTime'],
//         );
//
//         if (success) {
//           // If data is successfully synced, delete the attendance from the local database
//           await DatabaseHelper().deleteAttendanceById(attendance['deviceId']);
//         } else {
//           // Handle sync failure
//           allSuccess = false;
//         }
//       }
//       if (allSuccess) {
//         // Optionally, you can perform actions if all data is successfully synced
//       }
//     } else {
//       // No network connection, you may choose to handle this case differently
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: Scaffold(
//         appBar: AppBar(
//           title: Text('QR Code Scanner'),
//           leading: IconButton(
//             icon: Icon(Icons.arrow_back),
//             onPressed: () {
//               Navigator.of(context).pop();
//             },
//           ),
//         ),
//         body: Column(
//           children: [
//             Expanded(
//               flex: 5,
//               child: QRView(
//                 key: _qrKey,
//                 onQRViewCreated: _onQRViewCreated,
//               ),
//             ),
//             Expanded(
//               flex: 1,
//               child: Center(
//                 child: Text('Scanned Data: $scannedData'),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   void _onQRViewCreated(QRViewController controller) async {
//     setState(() {
//       _controller = controller;
//       _controller.scannedDataStream.listen((scanData) async {
//         if (!successMessageShown) {
//           setState(() {
//             scannedData = scanData.code ?? 'No data found';
//           });
//           successMessageShown = true;
//
//           await _showSuccessMessage();
//           _controller.dispose();
//
//         }
//         try {
//           // Get device ID
//           String deviceId = await _getDeviceId();
//           SharedPreferences pref=await SharedPreferences.getInstance();
//           String? employeeId=pref.getString('employeeId');
//
//           // Request permission to access device's location
//           bool locationPermission = await _requestLocationPermission();
//           if (!locationPermission) {
//             // Permission denied, show error message
//             showDialog(
//               context: context,
//               builder: (BuildContext context) {
//                 return AlertDialog(
//                   title: Text('Error'),
//                   content: Text(
//                       'User denied permissions to access the device\'s location.'),
//                   actions: <Widget>[
//                     TextButton(
//                       onPressed: () {
//                         Navigator.of(context).pop();
//                       },
//                       child: Text('OK'),
//                     ),
//                   ],
//                 );
//               },
//             );
//             return; // Exit the method
//           }
//
//           // Get current location
//           Position currentPosition = await Geolocator.getCurrentPosition(
//             desiredAccuracy: LocationAccuracy.high,
//           );
//           print('Current latitude: ${currentPosition
//               .latitude}, longitude: ${currentPosition.longitude}');
//
//
//           // Check if the scanData is not null and contains latitude and longitude
//           if (scanData.code != null && scanData.code!.contains(',')) {
//             print('mystep 1');
//             // Parse latitude and longitude from the scan data
//             List<String> qrDataParts = scanData.code!.split(',');
//             // double? qrLatitude = double.tryParse(qrDataParts[0]);
//             // double? qrLongitude = double.tryParse(qrDataParts[1]);
//
//             print('mystep 2');
//             print(qrDataParts);
//             int idx = scanData.code!.indexOf("=");
//             List parts_my = [scanData.code!.substring(0,idx).trim(), scanData.code!.substring(idx+1).trim()];
//
//             print('mystep 2 aft');
//
//             print(parts_my);
//             // double? qrLongitude_f = double.tryParse(parts_my[1]);
//             print('my fresult  $scanData.code!.substring(idx+1).trim()');
//             print( scanData.code!.substring(idx+1).trim());
//             List<String> qrDataParts_2 =  scanData.code!.substring(idx+1).trim().split(',');
//             double? qrLatitude = double.tryParse(qrDataParts_2[0]);
//             double? qrLongitude = double.tryParse(qrDataParts_2[1]);
//             print(qrDataParts_2[0]);
//             print(qrDataParts_2[1]);
//             print('mystep 2 aft 2');
//
//
//             // Compare current location with QR code data
//             if (qrLatitude != null &&
//                 qrLongitude != null &&
//                 _isWithin100MeterRadius(
//                     currentPosition.latitude,
//                     currentPosition.longitude,
//                     qrLatitude,
//                     qrLongitude)) {
//               String inTime = DateTime.now().toString();
//               String outTime = DateTime.now().toString();
//
//
//               BlocProvider.of<AttendanceBloc>(context).add(
//                 AttendanceDataPostEvent(
//                   inTime: inTime,
//                   outTime: outTime,
//                   employeeId: employeeId,
//                 ),
//               );
//               // // Location matched, proceed with storing data
//               // DatabaseHelper dbHelper = DatabaseHelper();
//               // List<Map<String, dynamic>> result =
//               // await dbHelper.getAttendanceForToday(deviceId);
//               //
//               // // await DatabaseHelper().deleteAttendanceById(deviceId);
//               //
//               // if (result.isEmpty) {
//               //   // First scan, store in-time
//               //   String inTime = DateTime.now().toString();
//               //   print(inTime);
//               //   await dbHelper.insertAttendance(inTime, '', deviceId);
//               //   print('step 1 $inTime');
//               //   BlocProvider.of<AttendanceBloc>(context).add(
//               //     AttendanceDataPostEvent(
//               //       inTime: inTime,
//               //       outTime: '',
//               //       employeeId: employeeId,
//               //     ),
//               //   );
//               //   _controller.dispose();
//               //
//               // } else {
//               //
//               //   // Second scan, update out-time
//               //   String outTime = DateTime.now().toString();
//               //   print("shubham$outTime");
//               //
//               //   // await dbHelper.insertOutAttendance(result.first['id'], outTime, deviceId);
//               //   await dbHelper.updateOutTime(result.first['id'], outTime);
//               //   print('step 2 $outTime');
//               //   Future.delayed(Duration(seconds: 100));
//               //   BlocProvider.of<AttendanceBloc>(context).add(
//               //     AttendanceDataPostEvent(
//               //       inTime: result.first['inTime'],
//               //       outTime: outTime,
//               //       employeeId: employeeId,
//               //     ),
//               //   );
//               //   _controller.dispose();
//               //
//               //
//               // }
//               //
//               // // Print locally stored data on console
//               // List<Map<String, dynamic>> attendanceData =
//               // await dbHelper.getAllAttendance();
//               // print('Locally stored attendance data: $attendanceData');
//
//
//               _controller.dispose();
//             } else {
//               // Location not matched, show error message
//               showDialog(
//                 context: context,
//                 builder: (BuildContext context) {
//                   return AlertDialog(
//                     title: Text('Error'),
//                     content:
//                     Text('Location does not match with QR code data.'),
//                     actions: <Widget>[
//                       TextButton(
//                         onPressed: () {
//                           Navigator.of(context).pop();
//                         },
//                         child: Text('OK'),
//                       ),
//                     ],
//                   );
//                 },
//               );
//             }
//           } else {
//             // Invalid QR code data format, show error message
//             showDialog(
//               context: context,
//               builder: (BuildContext context) {
//                 return AlertDialog(
//                   title: Text('Error'),
//                   content: Text('Invalid QR code data format.'),
//                   actions: <Widget>[
//                     TextButton(
//                       onPressed: () {
//                         Navigator.of(context).pop();
//                       },
//                       child: Text('OK'),
//                     ),
//                   ],
//                 );
//               },
//             );
//           }
//         } catch (e) {
//           print('Error: $e');
//         }
//       });
//     });
//   }
//
//   static Future<String> _getDeviceId() async {
//     Map<String, String> deviceInfo = await DeviceInformation.getDeviceInfo();
//     return deviceInfo['deviceId'] ?? '';
//   }
//
//   Future<bool> _requestLocationPermission() async {
//     // Request permission to access device's location
//     LocationPermission permission = await Geolocator.requestPermission();
//     return permission == LocationPermission.always ||
//         permission == LocationPermission.whileInUse;
//   }
//
//   Future<void> _showSuccessMessage() async {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('Success'),
//           content: Text('QR Code successfully scanned!'),
//           actions: <Widget>[
//             TextButton(
//               onPressed: () {
//                 // Navigator.pushNamed(context, "home");
//
//                 Navigator.pushReplacementNamed(context, "home");
//
//                 _controller.dispose();
//               },
//               child: Text('OK'),
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//   bool _isWithin100MeterRadius(
//       double currentLat, double currentLong, double qrLatitude, double qrLongitude) {
//     double distanceInMeters = Geolocator.distanceBetween(
//       currentLat,
//       currentLong,
//       qrLatitude,
//       qrLongitude,
//     );
//     return distanceInMeters <= 100;
//   }
// }
