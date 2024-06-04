
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../repository/deviceinfoapi.dart';

class AllEmployee extends StatefulWidget {
  const AllEmployee({Key? key}) : super(key: key);

  @override
  State<AllEmployee> createState() => _AllEmployeeState();
}

class _AllEmployeeState extends State<AllEmployee> {
  List<dynamic>? employeesData = []  ;
  DateTime? selectedDate;

  @override
  void initState() {
    super.initState();

    selectedDate = DateTime.now();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      String? firm_id= pref.getString('firm_id');
      print('###$firm_id');
      final response = await http.post(
        Uri.parse('http://theprtechnologies.com/attendance_new/api/employees'),
        // Uri.parse('http://192.168.1.73:8000/api/employees'),
        body: jsonEncode({"date": selectedDate?.toString().substring(0, 10),"firm_id": firm_id}),
        headers: {
          "Content-Type": "application/json",
        },
      );
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        setState(() {
          print(jsonData['attendance_for_employees']);
          employeesData =jsonData['attendance_for_employees'];

        });
      } else {
        print('Failed to fetch data: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching data: $error');
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
      fetchData();
    }
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "All Employee",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Color(0xFFFF2A48),
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: Icon(Icons.calendar_today, color: Colors.white),
            onPressed: () {
              _selectDate(context);
            },
          ),
        ],
      ),
      body: employeesData!.isEmpty
          ? Center(
        child: Text('No data available'),
      )
          : selectedDate == null
          ? filterEmployeesByDate(selectedDate!).isEmpty
          ? Center(
        child: Text('No data available for the selected date'),
      )
          : Container(
        height:mediaQuery.size.height*1,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount:employeesData!.length,
          itemBuilder: (context, index) {
            final employee = employeesData![index];
            print('employe  $employeesData![index]');
            return buildEmployeeItem(employee);
          },
        ),
      )
          : ListView.builder(
        itemCount: employeesData!.length,
        itemBuilder: (context, index) {
          final employee = employeesData![index];
          return buildEmployeeItem(employee);
        },
      ),
    );
  }

  List<dynamic> filterEmployeesByDate(DateTime selectedDate) {
    return employeesData!.where((employee) {
      var inTime = employee['intime'];
      if (inTime != null) {
        DateTime parsedInTime = DateTime.parse(inTime);
        return parsedInTime.year == selectedDate.year &&
            parsedInTime.month == selectedDate.month &&
            parsedInTime.day == selectedDate.day;
      }
      return false;
    }).toList();
  }

  Widget buildEmployeeItem(dynamic employee) {
    Color borderColor = employee['intime'] != null ? Colors.green : Colors.red;
    print(employee['intime']);
    // Parse intime and outime strings to DateTime objects
    DateTime? intime = employee['intime'] != null
        ? DateFormat("yyyy-MM-dd HH:mm:ss").parse(employee['intime'])
        : null;
    DateTime? outime = employee['outime'] != null
        ? DateFormat("yyyy-MM-dd HH:mm:ss").parse(employee['outime'])
        : null;

    // Calculate total hours and remaining minutes
    int totalHours = 0;
    int remainingMinutes = 0;
    if (intime != null && outime != null) {
      Duration difference = outime.difference(intime);
      totalHours = difference.inHours;
      remainingMinutes = difference.inMinutes.remainder(60);
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5,vertical: 5),
      child: Container(
        height: 68,
        // margin: EdgeInsets.symmetric(vertical: 4.0),
        decoration: BoxDecoration(
          border: Border(
            right: BorderSide(color:borderColor,width: 1),
            top: BorderSide(color: borderColor,width: 1),
            bottom: BorderSide(color: borderColor,width: 1),
            left: BorderSide(color:borderColor,width: 8),
          ),
          borderRadius: BorderRadius.only(topRight: Radius.circular(8),bottomRight: Radius.circular(8),
              topLeft: Radius.circular(8),bottomLeft: Radius.circular(8)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 1,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 10,top: 10),
                      child: Text('${employee['emp_name']}',style: TextStyle(fontWeight: FontWeight.bold),),
                    ),
                    SizedBox(height: 4.0),
                    // Padding(
                    //   padding: EdgeInsets.only(left: 10),
                    //   child: Text('${employee['emp_id']}'),
                    // ),
                  ],
                ),
              ),
            ),
            SizedBox(width: 5.0),
            Expanded(
              flex: 1,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 10,top: 10),
                      child: Text(
                        'Total Hours',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ), // Replace with your actual timing text
                    SizedBox(height: 3,),
                    Text('$totalHours h & $remainingMinutes m'),
                  ],
                ),
              ),
            ),

            SizedBox(width: 12.0),
            Expanded(
              flex: 1,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 10,top: 10),
                      child:
                      Text(
                        'In: ${intime?.hour ?? ''}:${intime?.minute ?? ''} ${intime != null && intime.hour < 12 ? 'AM' : 'PM'}',
                      ),
                    ),
                    SizedBox(height: 4.0),
                    Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Text(
                        'Out: ${outime?.hour ?? ''}:${outime?.minute ?? ''} ${outime != null && outime.hour < 12 ? 'AM' : 'PM'}',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:intl/intl.dart';
//
// class AllEmployee extends StatefulWidget {
//   const AllEmployee({Key? key}) : super(key: key);
//
//   @override
//   State<AllEmployee> createState() => _AllEmployeeState();
// }
//
// class _AllEmployeeState extends State<AllEmployee> {
//   List<dynamic> employeesData = [];
//   DateTime? selectedDate;
//   bool isLoading = false; // Add a loading indicator
//
//   @override
//   void initState() {
//     super.initState();
//     selectedDate = DateTime.now();
//     fetchData();
//   }
//
//   Future<void> fetchData() async {
//     setState(() {
//       isLoading = true; // Set loading indicator to true
//     });
//
//     try {
//       SharedPreferences pref = await SharedPreferences.getInstance();
//       String? firm_id = pref.getString('firm_id');
//       final response = await http.post(
//         Uri.parse('http://192.168.1.73:8000/api/employees'),
//         body: jsonEncode({
//           "date": selectedDate?.toString().substring(0, 10),
//           "firm_id": firm_id
//         }),
//         headers: {
//           "Content-Type": "application/json",
//         },
//       );
//
//       if (response.statusCode == 200) {
//         final jsonData = jsonDecode(response.body);
//         setState(() {
//           employeesData = jsonData['attendance_for_all_employees'];
//         });
//       } else {
//         print('Failed to fetch data: ${response.statusCode}');
//       }
//     } catch (error) {
//       print('Error fetching data: $error');
//     } finally {
//       setState(() {
//         isLoading = false; // Set loading indicator to false
//       });
//     }
//   }
//
//   Future<void> _selectDate(BuildContext context) async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: selectedDate ?? DateTime.now(),
//       firstDate: DateTime(2000),
//       lastDate: DateTime(2101),
//     );
//
//     if (picked != null && picked != selectedDate) {
//       setState(() {
//         selectedDate = picked;
//       });
//       fetchData();
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     var mediaQuery = MediaQuery.of(context);
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           "All Employee",
//           style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//         ),
//         centerTitle: true,
//         backgroundColor: Color(0xFFFF2A48),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.calendar_today, color: Colors.white),
//             onPressed: () {
//               _selectDate(context);
//             },
//           ),
//         ],
//       ),
//       body: isLoading
//           ? Center(
//         child: CircularProgressIndicator(), // Show loading indicator
//       )
//           : employeesData.isEmpty
//           ? Center(
//         child: Text('No data available'),
//       )
//           : selectedDate == null
//           ? filterEmployeesByDate(selectedDate!).isEmpty
//           ? Center(
//         child: Text(
//             'No data available for the selected date'),
//       )
//           : Container(
//         height: mediaQuery.size.height * 1,
//         child: ListView.builder(
//           shrinkWrap: true,
//           itemCount: employeesData.length,
//           itemBuilder: (context, index) {
//             final employee = employeesData[index];
//             return buildEmployeeItem(employee);
//           },
//         ),
//       )
//           : ListView.builder(
//         itemCount: employeesData.length,
//         itemBuilder: (context, index) {
//           final employee = employeesData[index];
//           return buildEmployeeItem(employee);
//         },
//       ),
//     );
//   }
//
//   List<dynamic> filterEmployeesByDate(DateTime selectedDate) {
//     return employeesData.where((employee) {
//       var inTime = employee['intime'];
//       if (inTime != null) {
//         DateTime parsedInTime = DateTime.parse(inTime);
//         return parsedInTime.year == selectedDate.year &&
//             parsedInTime.month == selectedDate.month &&
//             parsedInTime.day == selectedDate.day;
//       }
//       return false;
//     }).toList();
//   }
//
//   Widget buildEmployeeItem(dynamic employee) {
//     Color borderColor =
//     employee['intime'] != null ? Colors.green : Colors.red;
//     // Parse intime and outime strings to DateTime objects
//     DateTime? intime = employee['intime'] != null
//         ? DateFormat("yyyy-MM-dd HH:mm:ss").parse(employee['intime'])
//         : null;
//     DateTime? outime = employee['outime'] != null
//         ? DateFormat("yyyy-MM-dd HH:mm:ss").parse(employee['outime'])
//         : null;
//
//     // Calculate total hours and remaining minutes
//     int totalHours = 0;
//     int remainingMinutes = 0;
//     if (intime != null && outime != null) {
//       Duration difference = outime.difference(intime);
//       totalHours = difference.inHours;
//       remainingMinutes = difference.inMinutes.remainder(60);
//     }
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
//       child: Container(
//         height: 68,
//         // margin: EdgeInsets.symmetric(vertical: 4.0),
//         decoration: BoxDecoration(
//           border: Border(
//             right: BorderSide(color: borderColor, width: 1),
//             top: BorderSide(color: borderColor, width: 1),
//             bottom: BorderSide(color: borderColor, width: 1),
//             left: BorderSide(color: borderColor, width: 8),
//           ),
//           borderRadius: BorderRadius.only(
//             topRight: Radius.circular(8),
//             bottomRight: Radius.circular(8),
//             topLeft: Radius.circular(8),
//             bottomLeft: Radius.circular(8),
//           ),
//         ),
//         child: Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Expanded(
//               flex: 1,
//               child: SingleChildScrollView(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Padding(
//                       padding: EdgeInsets.only(left: 10, top: 10),
//                       child: Text(
//                         '${employee['emp_name']}',
//                         style: TextStyle(fontWeight: FontWeight.bold),
//                       ),
//                     ),
//                     SizedBox(height: 4.0),
//                     // Padding(
//                     //   padding: EdgeInsets.only(left: 10),
//                     //   child: Text('${employee['emp_id']}'),
//                     // ),
//                   ],
//                 ),
//               ),
//             ),
//             SizedBox(width: 5.0),
//             Expanded(
//               flex: 1,
//               child: SingleChildScrollView(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     Padding(
//                       padding: EdgeInsets.only(left: 10, top: 10),
//                       child: Text(
//                         'Total Hours',
//                         style: TextStyle(fontWeight: FontWeight.bold),
//                       ),
//                     ), // Replace with your actual timing text
//                     SizedBox(height: 3),
//                     Text('$totalHours h & $remainingMinutes m'),
//                   ],
//                 ),
//               ),
//             ),
//             SizedBox(width: 12.0),
//             Expanded(
//               flex: 1,
//               child: SingleChildScrollView(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Padding(
//                       padding: EdgeInsets.only(left: 10, top: 10),
//                       child: Text(
//                         'In: ${intime?.hour ?? ''}:${intime?.minute ?? ''} ${intime != null && intime.hour < 12 ? 'AM' : 'PM'}',
//                       ),
//                     ),
//                     SizedBox(height: 4.0),
//                     Padding(
//                       padding: EdgeInsets.only(left: 10),
//                       child: Text(
//                         'Out: ${outime?.hour ?? ''}:${outime?.minute ?? ''} ${outime != null && outime.hour < 12 ? 'AM' : 'PM'}',
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
