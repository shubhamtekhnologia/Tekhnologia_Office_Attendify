import 'package:attendence110/Features/screens/qrcodeScanner.dart';
import 'package:flutter/material.dart';
import '../LocalDatabase/attendence.dart';

class AttendanceScreen extends StatefulWidget {
  @override
  _AttendanceScreenState createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  late Future<List<Map<String, dynamic>>> _attendanceData;

  @override
  void initState() {
    super.initState();
    _attendanceData = DatabaseHelper().getAllAttendance();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Offline Attendance Records'),
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              _deleteAllAttendance(context);
            },
          ),
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              QRCodeScannerAppState.syncDataWithServer();
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _attendanceData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            List<Map<String, dynamic>> data = snapshot.data!;
            return ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                Map<String, dynamic> record = data[index];
                return ListTile(
                  title: Text('In Time: ${record['inTime']}'),
                  subtitle: Text('Out Time: ${record['outTime'] ?? 'N/A'}'),
                  // You can add more fields here if needed
                  // Example: Device ID: ${record['deviceId']}
                );
              },
            );
          }
        },
      ),
    );
  }

  Future<void> _deleteAllAttendance(BuildContext context) async {
    await DatabaseHelper().deleteAllAttendance();
    setState(() {
      _attendanceData = DatabaseHelper().getAllAttendance();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('All attendance records deleted'),
      ),
    );
  }
}
