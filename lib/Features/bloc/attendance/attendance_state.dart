

abstract class AttendanceState {}

class AttendanceIntialState extends AttendanceState {}

class AttendanceLoadingState extends AttendanceState {}

class AttendanceSuccessfulState extends AttendanceState {



}

class AttendanceFailedFetchState extends AttendanceState {
  final String fetcherror;

  AttendanceFailedFetchState({required this.fetcherror});
}
