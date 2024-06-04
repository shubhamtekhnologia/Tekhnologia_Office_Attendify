// To parse this JSON data, do
//
//     final employeeData = employeeDataFromJson(jsonString);

import 'dart:convert';

List<EmployeeData> employeeDataFromJson(String str) => List<EmployeeData>.from(json.decode(str).map((x) => EmployeeData.fromJson(x)));

String employeeDataToJson(List<EmployeeData> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class EmployeeData {
  int empId;
  String deviceid;
  DateTime intime;
  DateTime outime;

  EmployeeData({
    required this.empId,
    required this.deviceid,
    required this.intime,
    required this.outime,
  });

  factory EmployeeData.fromJson(Map<String, dynamic> json) => EmployeeData(
    empId: json["emp_id"],
    deviceid: json["deviceid"],
    intime: DateTime.parse(json["intime"]),
    outime: DateTime.parse(json["outime"]),
  );

  Map<String, dynamic> toJson() => {
    "emp_id": empId,
    "deviceid": deviceid,
    "intime": intime.toIso8601String(),
    "outime": outime.toIso8601String(),
  };
}