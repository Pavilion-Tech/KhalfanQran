import 'package:equatable/equatable.dart';
import 'package:khalfan_center/models/attendance_model.dart';
import 'package:khalfan_center/models/quran_progress_model.dart';
import 'package:khalfan_center/models/request_model.dart';

abstract class StudentEvent extends Equatable {
  const StudentEvent();

  @override
  List<Object?> get props => [];
}

class LoadStudentDetailsEvent extends StudentEvent {
  final String studentId;

  const LoadStudentDetailsEvent({
    required this.studentId,
  });

  @override
  List<Object> get props => [studentId];
}

class LoadStudentsByParentEvent extends StudentEvent {
  final String parentId;

  const LoadStudentsByParentEvent({
    required this.parentId,
  });

  @override
  List<Object> get props => [parentId];
}

class LoadStudentsByTeacherEvent extends StudentEvent {
  final String teacherId;

  const LoadStudentsByTeacherEvent({
    required this.teacherId,
  });

  @override
  List<Object> get props => [teacherId];
}

class LoadStudentProgressEvent extends StudentEvent {
  final String studentId;

  const LoadStudentProgressEvent({
    required this.studentId,
  });

  @override
  List<Object> get props => [studentId];
}

class LoadStudentAttendanceEvent extends StudentEvent {
  final String studentId;
  final DateTime? startDate;
  final DateTime? endDate;

  const LoadStudentAttendanceEvent({
    required this.studentId,
    this.startDate,
    this.endDate,
  });

  @override
  List<Object?> get props => [studentId, startDate, endDate];
}

class LoadStudentDocumentsEvent extends StudentEvent {
  final String studentId;

  const LoadStudentDocumentsEvent({
    required this.studentId,
  });

  @override
  List<Object> get props => [studentId];
}

class LoadStudentRequestsEvent extends StudentEvent {
  final String studentId;

  const LoadStudentRequestsEvent({
    required this.studentId,
  });

  @override
  List<Object> get props => [studentId];
}

class AddStudentProgressEvent extends StudentEvent {
  final QuranProgressModel progress;

  const AddStudentProgressEvent({
    required this.progress,
  });

  @override
  List<Object> get props => [progress];
}

class MarkStudentAttendanceEvent extends StudentEvent {
  final AttendanceModel attendance;

  const MarkStudentAttendanceEvent({
    required this.attendance,
  });

  @override
  List<Object> get props => [attendance];
}

class AddStudentRequestEvent extends StudentEvent {
  final RequestModel request;

  const AddStudentRequestEvent({
    required this.request,
  });

  @override
  List<Object> get props => [request];
}
