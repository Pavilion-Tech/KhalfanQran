import 'package:equatable/equatable.dart';
import 'package:khalfan_center/models/attendance_model.dart';
import 'package:khalfan_center/models/document_model.dart';
import 'package:khalfan_center/models/quran_progress_model.dart';
import 'package:khalfan_center/models/request_model.dart';
import 'package:khalfan_center/models/student_model.dart';

abstract class StudentState extends Equatable {
  const StudentState();

  @override
  List<Object?> get props => [];
}

class StudentInitial extends StudentState {}

class StudentLoading extends StudentState {}

class StudentDetailsLoaded extends StudentState {
  final StudentModel student;

  const StudentDetailsLoaded({
    required this.student,
  });

  @override
  List<Object> get props => [student];
}

class StudentListLoaded extends StudentState {
  final List<StudentModel> students;

  const StudentListLoaded({
    required this.students,
  });

  @override
  List<Object> get props => [students];
}

class StudentProgressLoaded extends StudentState {
  final List<QuranProgressModel> progress;

  const StudentProgressLoaded({
    required this.progress,
  });

  @override
  List<Object> get props => [progress];
}

class StudentAttendanceLoaded extends StudentState {
  final List<AttendanceModel> attendance;

  const StudentAttendanceLoaded({
    required this.attendance,
  });

  @override
  List<Object> get props => [attendance];
}

class StudentDocumentsLoaded extends StudentState {
  final List<DocumentModel> documents;

  const StudentDocumentsLoaded({
    required this.documents,
  });

  @override
  List<Object> get props => [documents];
}

class StudentRequestsLoaded extends StudentState {
  final List<RequestModel> requests;

  const StudentRequestsLoaded({
    required this.requests,
  });

  @override
  List<Object> get props => [requests];
}

class StudentError extends StudentState {
  final String message;

  const StudentError({
    required this.message,
  });

  @override
  List<Object> get props => [message];
}
