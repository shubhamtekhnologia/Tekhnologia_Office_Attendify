import 'dart:async';

import 'package:attendence110/Features/bloc/attendance/attendance_event.dart';
import 'package:attendence110/Features/bloc/attendance/attendance_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../repository/attendence.dart';

class AttendanceBloc extends Bloc<AttendanceEvent, AttendanceState> {
  AttendanceBloc() : super(AttendanceIntialState()) {
    on<AttendanceDataPostEvent>(attendanceDataPostEvent);
  }

  Future<void> attendanceDataPostEvent(
      AttendanceDataPostEvent event, Emitter< AttendanceState> emit) async {
    try {
         bool sucesss=await AttendanceRepo.Attendance(event.inTime,event.outTime,event.employeeId!);
         if(sucesss){
           emit( AttendanceSuccessfulState());
         }else{
           emit(AttendanceFailedFetchState(fetcherror: 'Attendance not marked'));
         }
    } catch (e) {
      emit( AttendanceFailedFetchState(fetcherror: 'Unable to Fetch'));
    }
  }
}
