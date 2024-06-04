import 'dart:convert';
import 'package:attendence110/Features/repository/attendence.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../LocalDatabase/attendence.dart';
import '../repository/deviceinfoapi.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final dbHelper = DatabaseHelper();// Initialize DatabaseHelper


  List<Map<String, dynamic>> attendanceData = [];
  bool _isLoading = false; // Add a loading indicator state
   String empName = '';
   String empEmail = '';

// Method to retrieve employee details from SharedPreferences
   Future<void>_getEmployeeDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      empName = prefs.getString('empName') ?? 'Name not available';
      empEmail = prefs.getString('empEmail') ?? 'Email not available';
    });
  }


  Future<void> _refreshData() async {
    setState(()  {
      _isLoading = true;
    });

    try {
      final data = await AttendanceRepo.fetchData();
      setState(() {
        attendanceData = List<Map<String, dynamic>>.from(data['data'] ?? []);
        _isLoading = false;
      });
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      print('Error: $error');
    }
  }

  @override
  void initState() {
    super.initState();
    _refreshData();
    _getEmployeeDetails();
    AttendanceRepo.fetchData();
    // fetchData();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Home',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Color(0xFFFF2A48),
        iconTheme: IconThemeData(color: Colors.white), // Set the color of the drawer icon
        actions: [
          IconButton(
            icon: Icon(Icons.data_saver_off,color: Colors.white,), // Add your first icon here
            onPressed: () {
              // Add your onPressed functionality here
              Navigator.pushNamed(context, 'localAttendance');
            },
          ),
          IconButton(
            icon: Icon(Icons.logout,color: Colors.white,), // Add your first icon here
            onPressed: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              await prefs.clear();
              // Navigate to the login screen
              Navigator.pushReplacementNamed(context, 'login');
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                content:Text('You are logout successfully')
              ));

              // Add your onPressed functionality here
            },
          ),
          SizedBox.fromSize(),
        ],
      ),
      drawer:Drawer(
        child: ListView(
          children: <Widget>[
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                color: Color(0xFFFF2A48),
              ),
              currentAccountPicture: CircleAvatar(
                backgroundImage: AssetImage("assets/images/person.jpg"),
              ),
              accountName: Text(
                empName,
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
              ),
              accountEmail: Text(
                empEmail,
                style: TextStyle(color: Colors.white),
              ),

            ),
            ListTile(
              leading: Icon(Icons.login_outlined),
              title: Text('Logout' ,style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black),),
              onTap: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.clear();
                // Navigate to the login screen
                Navigator.pushReplacementNamed(context, 'login');
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content:Text('You are logout successfully')
                    ));
                //Navigator.pop(context);
              },
            ),
          ],
        ),
      ),

      // drawer: Drawer(
      //   child: ListView(
      //       children: <Widget>[
      //         UserAccountsDrawerHeader(
      //           decoration: BoxDecoration(
      //               color: Color(0xFFFF2A48)
      //           ),
      //           accountName: Text('Shubham Dhote',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 20),),
      //           accountEmail: Text('shubhamdhotegmail.com',style: TextStyle(color: Colors.white),),
      //         ),
      //         ListTile(
      //           leading: Icon(Icons.login_outlined),
      //           title: Text('Logout'),
      //           onTap: () {
      //             Navigator.pushReplacementNamed(context, 'login');
      //             //Navigator.pop(context);
      //           },
      //         ),
      //       ]
      //   ),
      // ),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 30, right: 20, left: 20),
                child: Row(
                  children: [
                    Expanded(
                        child:GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, 'allEmployees');
                          },
                          child: Container(
                            height: 80, // Adjusted height to accommodate icon and text
                            child: Card(
                              color: Color(0xFFFF2A48),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.groups, color: Colors.white), // Icon
                                  SizedBox(height: 8), // Spacer
                                  Text(
                                    'All Employees',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: Colors.white),
                                  ), // Text
                                ],
                              ),
                            ),
                          ),
                        )
                    ),
                    Expanded(
                      child:GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, 'leave');
                        },
                      child: Container(
                        height: 80, // Adjusted height to accommodate icon and text
                        child: Card(
                          color: Color(0xFFFF2A48),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.calendar_month, color: Colors.white), // Icon
                              SizedBox(height: 8), // Spacer
                              Text(
                                'Apply for Leave',
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.white),
                              ), // Text
                            ],
                          ),
                        ),
                      ),
                      )
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, 'Scanner');
                        },
                        child: Container(
                          height: 80, // Adjusted height to accommodate icon and text
                          child: Card(
                            color: Color(0xFFFF2A48),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.qr_code_scanner_outlined, color: Colors.white), // Icon
                                SizedBox(height: 8), // Spacer
                                Text(
                                  'Mark Attendence',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
        Expanded(
          child: _isLoading
              ? Center(child: CircularProgressIndicator())
              : attendanceData.isEmpty
              ? Center(child: Text('No data available'))
              : ListView.builder(
            itemCount: attendanceData.length,
            itemBuilder: (context, index) {
              attendanceData.sort((a, b) {
                DateTime aDate = DateTime.parse(a['intime']);
                DateTime bDate = DateTime.parse(b['intime']);
                return bDate.compareTo(aDate);
              });
              final attendance = attendanceData[index];

              // Parse date strings with a specified format
              DateTime? inTime = attendance['intime'] != null ? DateTime.parse(attendance['intime']) : null;
              DateTime? outTime = attendance['outime'] != null ? DateTime.parse(attendance['outime']) : null;

              // Calculate the difference between in time and out time
              Duration difference = outTime != null ? outTime.difference(inTime!) : Duration.zero;

              // Calculate total hours
              int totalHours = difference.inHours;

              // Calculate remaining minutes
              int remainingMinutes = difference.inMinutes.remainder(60);

              return Container(
                padding: EdgeInsets.all(10.0), // Adjust padding as needed
                margin: EdgeInsets.symmetric(vertical: 8.0), // Adjust margin as needed
                decoration: BoxDecoration(
                  color: Colors.white, // Set container background color
                  borderRadius: BorderRadius.circular(8.0), // Add rounded corners
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5), // Add shadow color
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 60, // Adjust width as needed
                      height: 55, // Adjust height as needed
                      child: Card(
                        color: totalHours < 9 ? Color(0xFFFDECEC): Color(0xFFE6EFD3),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5), // Adjust border radius as needed
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '${inTime?.day ?? ''}',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '${inTime != null ? DateFormat('MMMM').format(inTime) : ''}',
                              textAlign: TextAlign.center,
                            ),

                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: 20), // Add spacing between Card and timing texts
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Total Hours',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ), // Replace with your actual timing text
                        SizedBox(height: 3,),
                        Text('$totalHours h & $remainingMinutes m'),
                      ],
                    ),
                    SizedBox(width: 20), // Add spacing between Card and timing texts
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'In Time: ${inTime?.hour ?? ''}:${inTime?.minute ?? ''} ${inTime != null && inTime.hour < 12 ? 'AM' : 'PM'}',
                        ),
                        SizedBox(height: 5,),
                        Text(
                          'Out Time: ${outTime?.hour ?? ''}:${outTime?.minute ?? ''} ${outTime != null && outTime.hour < 12 ? 'AM' : 'PM'}',
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        )
            ],
          ),
        ),
      ),
    );
  }
}