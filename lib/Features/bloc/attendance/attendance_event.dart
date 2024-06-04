import 'package:flutter/material.dart';

abstract class AttendanceEvent {}

class AttendanceDataPostEvent extends AttendanceEvent {
  final String inTime;
  final String outTime;
  final String? employeeId;

  AttendanceDataPostEvent({required this.inTime, required this.outTime,required this.employeeId});
}


class AttendanceDataFetchEvent extends AttendanceEvent {
  final String employeeId;

  AttendanceDataFetchEvent({required this.employeeId});
}