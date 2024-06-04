

import 'dart:convert';

import 'package:attendence110/Features/repository/attendence.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Leave_Screen extends StatefulWidget {
  const Leave_Screen({Key? key}) : super(key: key);

  @override
  State<Leave_Screen> createState() => _Leave_ScreenState();
}

class _Leave_ScreenState extends State<Leave_Screen> {

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
        appBar: AppBar(title: Text('Leave',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 30),),
          automaticallyImplyLeading: false,
          bottom:TabBar(
              tabs:<Widget>[
                Tab(
                  child:Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Text( "Apply Leave",style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),),
                      )
                    ],
                  ) ,
                  //icon: Icon(Icons.person_off,size: 30,color: Colors.white,),
                ),
                Tab(
                  child: Text('Status',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: Colors.white),),
                ),
              ]),
          centerTitle: true,
          backgroundColor: Color(0xFFFF2A48),
        ),

        body:TabBarView(
            children: [
              LeaveApplication(),
              LeaveStatus(),
            ]
        )
      ),
    );
  }
}

//***************************************************************************************************************************************************//




class LeaveStatus extends StatefulWidget {
  @override
  _LeaveStatusState createState() => _LeaveStatusState();
}

class _LeaveStatusState extends State<LeaveStatus> {
  List< dynamic> leaveApplications = [];
  bool isLoading = true;


  @override
  void initState() {
    super.initState();
    _loadLeaveApplications();
  }
  Future<void> _loadLeaveApplications() async {
    setState(() {
      isLoading = true;
    });
    leaveApplications = await AttendanceRepo.fetchLeaveApplicationsStatus();
    setState(() {
      isLoading = false;
    });
  }

  // Future<void> fetchLeaveApplications() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String? employeeId = prefs.getString('employeeId');
  //
  //   if (employeeId != null) {
  //     try {
  //       final url = 'http://theprtechnologies.com/attendance_app/api/leave-applications';
  //       final response = await http.post(
  //         Uri.parse(url),
  //         headers: {'Content-Type': 'application/json'},
  //         body: jsonEncode({"employee_id": employeeId}),
  //       );
  //
  //       if (response.statusCode == 200) {
  //         setState(() {
  //           leaveApplications = jsonDecode(response.body);
  //           isLoading = false;
  //         });
  //       } else {
  //         throw Exception('Failed to fetch leave applications: ${response.statusCode}');
  //       }
  //     } catch (e) {
  //       print('Error fetching leave applications: $e');
  //       setState(() {
  //         isLoading = false;
  //       });
  //     }
  //   } else {
  //     print('Employee ID not found. Please log in first.');
  //     setState(() {
  //       isLoading = false;
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _loadLeaveApplications,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 0),
              child: Container(
                height: mediaQuery.size.height * 0.06,
                width: mediaQuery.size.width * 1,
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 1,
                      spreadRadius: 1,
                      color: Colors.grey.shade400,
                      offset: Offset(1, 1),
                    )
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 15),
                      child: Text("Date",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 20)),
                    ),
                    // Text("Clock In",
                    //     style: TextStyle(
                    //         color: Colors.black,
                    //         fontWeight: FontWeight.w600,
                    //         fontSize: 15)),
                    // Text("Clock Out",
                    //     style: TextStyle(
                    //         color: Colors.black,
                    //         fontWeight: FontWeight.w600,
                    //         fontSize: 15)),
                    Padding(
                      padding: const EdgeInsets.only(right: 15),
                      child: Text("Status",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 20)),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: isLoading
                  ? Center(
                child: CircularProgressIndicator(),
              )
                  : leaveApplications.isEmpty
                  ? Center(
                child: Text('No leave applications found.'),
              )
                  : ListView.builder(
                itemCount: leaveApplications.length,
                itemBuilder: (context, index) {
                  final application = leaveApplications[index];
                  var data = application['status'];
                  return Container(
                    padding: EdgeInsets.all(8.0),
                    margin: EdgeInsets.symmetric(vertical: 4.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text('From : ${application['lva_from_date']}'),
                            Text('To : ${application['lva_to_date']}'),
                          ],
                        ),
                        Text('${data}',style: TextStyle(color: Colors.black,fontWeight: FontWeight.w700),),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
// Widget build(BuildContext context) {
//   return Scaffold(
//     // appBar: AppBar(
//     //   title: Text('Leave Applications'),
//     // ),
//     body: isLoading
//         ? Center(
//       child: CircularProgressIndicator(),
//     )
//         : leaveApplications.isEmpty
//         ? Center(
//       child: Text('No leave applications found.'),
//     )
//         : ListView.builder(
//       itemCount: leaveApplications.length,
//       itemBuilder: (context, index) {
//         final application = leaveApplications[index];
//         return Container(
//           padding: EdgeInsets.all(8.0),
//           margin: EdgeInsets.symmetric(vertical: 4.0),
//           decoration: BoxDecoration(
//             border: Border.all(color: Colors.grey),
//             borderRadius: BorderRadius.circular(8.0),
//           ),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text('Date: ${application['lva_from_date']}'),
//               Text('Type: ${application['lva_lv_type']}'),
//               Text('Status: ${application['status']}'),
//             ],
//           ),
//         );
//       },
//     ),
//   );
// }
}




//***************************************************************************************************************************************************//


class LeaveApplication extends StatefulWidget {
  const LeaveApplication({super.key});

  @override
  State<LeaveApplication> createState() => _LeaveApplicationState();
}
class _LeaveApplicationState extends State<LeaveApplication> {
  String? selectedLeaveType;// Default selected leave type
  String? selectedDayType;
  DateTime? fromDate;
  DateTime? toDate;
  TextEditingController reasonController = TextEditingController();


  // Future<void> _selectDate(BuildContext context, bool isFromDate) async {
  //   final DateTime? picked = await showDatePicker(
  //     context: context,
  //     firstDate: DateTime(2000),
  //     lastDate: DateTime(2101),
  //   );
  //
  //   if (picked != null) {
  //     setState(() {
  //       if (isFromDate) {
  //         fromDate = picked;
  //       } else {
  //         toDate = picked;
  //       }
  //     });
  //   }
  // }
  Future<void> _selectDate(BuildContext context, bool isFromDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(), // Set initial date to current date
      firstDate: DateTime.now(), // Set first date selectable to current date
      lastDate: DateTime(2101),
    );

    if (picked != null) {
      if (!isFromDate && fromDate != null && picked.isBefore(fromDate!)) {
        // If selecting "To" date and it's before the selected "From" date
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('To date smaller that From date'),
          ),
        );
      } else {
        setState(() {
          if (isFromDate) {
            fromDate = picked;
          } else {
            toDate = picked;
          }
        });
      }
    }
  }



  Future<void> _submitLeave() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? employeeId = prefs.getString('employeeId');
    String? firm_id = prefs.getString('firm_id');
    print(firm_id);

    if (employeeId != null) {
      try {
        Map<String, dynamic> leaveData={
          "lva_emp_id": employeeId,
          "firm_id":firm_id,
          "lva_from_date": fromDate.toString(),
          "lva_to_date": toDate.toString(),
          "lva_lv_type": selectedLeaveType,
          "lva_daytype": selectedDayType,
          "lva_reason": reasonController.text
        };
        final response = await http.post(
          Uri.parse('http://theprtechnologies.com/attendance_new/api/leave-applications-store'), // Replace with your server endpoint
          // Uri.parse('http://192.168.1.73:8000/api/leave-applications-store'), // Replace with your server endpoint
          headers: <String, String>{
            'Content-Type': 'application/json',
          },

          body: jsonEncode(leaveData),
        );
      print("#####$response.body");
      print("@@@@@@$leaveData");

        if (response.statusCode == 201) {
          // Handle success
          // Show a success message or navigate to another screen
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Your leave application is sent'),
            ),
          );
          print("test2");
          reasonController.clear();
          setState(() {
            selectedLeaveType = null;
            selectedDayType = null;
            fromDate = null;
            toDate = null;
          });

          print('Leave application submitted successfully$response.statusCode');
        } else {
          print("test3");
          // Handle other status codes
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Your leave application is not sent'),
            ),
          );
          print('Leave application is not submitted $response.statusCode');
        }
      } catch (e) {
        print('Error submitting leave application: $e');
      }
    } else {
      print('Employee ID not found. Please log in first.');
    }
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Padding(
                //   padding: const EdgeInsets.only(left: 10, top: 10),
                //   child: Text(
                //     'Leave Application',
                //     style: TextStyle(
                //       color: Color(0xFF232323),
                //       fontSize: 20,
                //     ),
                //   ),
                // ),
                // Divider(
                //   color: Color(0xff000000),
                //   thickness: 1,
                // ),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Container(
                    child: Column(
                      children: [
                        SizedBox(height: 20),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Leave Type',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                            ),
                          ),
                        ),
                        DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: selectedLeaveType == null ? 'Select Leave Type' : null,
                          ),
                          value: selectedLeaveType,
                          items: [
                            DropdownMenuItem(
                              value: 'Paid',
                              child: Text('Paid'),
                            ),
                            DropdownMenuItem(
                              value: 'Unpaid',
                              child: Text('Unpaid'),
                            ),
                            // DropdownMenuItem(
                            //   value: 'comp-off',
                            //   child: Text('Compensatory Off (comp-off)'),
                            // ),
                          ],
                          onChanged: (value) {
                            setState(() {
                              selectedLeaveType = value!;
                            });
                          },
                        ),
                        SizedBox(height: 20),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Date',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                readOnly: true,
                                decoration: InputDecoration(
                                  hintText: 'From',
                                  border: OutlineInputBorder(),
                                  suffixIcon: IconButton(
                                    icon: Icon(Icons.calendar_today),
                                    onPressed: () {
                                      _selectDate(context, true);
                                    },
                                  ),
                                ),
                                controller: TextEditingController(
                                  text: fromDate != null ? '${fromDate!.day}/${fromDate!.month}/${fromDate!.year}' : '',
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: TextField(
                                readOnly: true,
                                decoration: InputDecoration(
                                  hintText: 'To',
                                  border: OutlineInputBorder(),
                                  suffixIcon: IconButton(
                                    icon: Icon(Icons.calendar_today),
                                    onPressed: () {
                                      _selectDate(context, false);
                                    },
                                  ),
                                ),
                                controller: TextEditingController(
                                  text: toDate != null ? '${toDate!.day}/${toDate!.month}/${toDate!.year}' : '',
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),

                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Day',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                            ),
                          ),
                        ),
                        DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: selectedDayType == null ? 'Select Day Type' : null,
                          ),
                          value: selectedDayType,
                          items: [
                            DropdownMenuItem(
                              value: 'Full Day',
                              child: Text('Full Day'),
                            ),
                            DropdownMenuItem(
                              value: 'Half Day',
                              child: Text('Half Day'),
                            ),
                          ],
                          onChanged: (value) {
                            setState(() {
                              selectedDayType = value!;
                            });
                          },
                        ),
                        SizedBox(height: 20),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Reason For Leave',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                            ),
                          ),
                        ),
                        TextField(
                          controller: reasonController,
                          decoration: InputDecoration(
                            hintText: 'Type a reason',
                            border: OutlineInputBorder(),
                          ),
                          maxLines: 5,
                        ),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            MaterialButton(
                              onPressed: (){
                                _submitLeave();
                                // reasonController.clear();
                                // setState(() {
                                //   selectedLeaveType = null;
                                //   selectedDayType=null;
                                //   fromDate=null;
                                //   toDate=null;
                                // });
                              },
                              child: Text('Submit',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,),),
                              color: Color(0xFFFF2A48),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5)
                              ),
                            ),
                            SizedBox(width: 10,),
                            MaterialButton(
                              onPressed: (){
                                Navigator.pushReplacementNamed(context, 'home');

                              },
                              child: Text('Cancel',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                              color: Color(0xFFFF2A48),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5)
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
