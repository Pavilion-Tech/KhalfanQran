import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:khalfan_center/bloc/student/student_event.dart';
import 'package:khalfan_center/bloc/student/student_state.dart';
import 'package:khalfan_center/models/attendance_model.dart';
import 'package:khalfan_center/models/document_model.dart';
import 'package:khalfan_center/models/quran_progress_model.dart';
import 'package:khalfan_center/models/request_model.dart';
import 'package:khalfan_center/models/student_model.dart';
import 'package:khalfan_center/services/firebase_service.dart';

class StudentBloc extends Bloc<StudentEvent, StudentState> {
  final FirebaseService firebaseService;

  StudentBloc({
    required this.firebaseService,
  }) : super(StudentInitial()) {
    on<LoadStudentDetailsEvent>(_onLoadStudentDetails);
    on<LoadStudentsByParentEvent>(_onLoadStudentsByParent);
    on<LoadStudentsByTeacherEvent>(_onLoadStudentsByTeacher);
    on<LoadStudentProgressEvent>(_onLoadStudentProgress);
    on<LoadStudentAttendanceEvent>(_onLoadStudentAttendance);
    on<LoadStudentDocumentsEvent>(_onLoadStudentDocuments);
    on<LoadStudentRequestsEvent>(_onLoadStudentRequests);
    on<AddStudentProgressEvent>(_onAddStudentProgress);
    on<MarkStudentAttendanceEvent>(_onMarkStudentAttendance);
    on<AddStudentRequestEvent>(_onAddStudentRequest);
  }

  FutureOr<void> _onLoadStudentDetails(LoadStudentDetailsEvent event, Emitter<StudentState> emit) async {
    emit(StudentLoading());
    try {
      StudentModel? student = await firebaseService.getStudentById(event.studentId);
      if (student != null) {
        emit(StudentDetailsLoaded(student: student));
      } else {
        emit(const StudentError(message: 'Student not found'));
      }
    } catch (e) {
      emit(StudentError(message: e.toString()));
    }
  }

  FutureOr<void> _onLoadStudentsByParent(LoadStudentsByParentEvent event, Emitter<StudentState> emit) async {
    emit(StudentLoading());
    try {
      List<StudentModel> students = await firebaseService.getStudentsByParentId(event.parentId);
      emit(StudentListLoaded(students: students));
    } catch (e) {
      emit(StudentError(message: e.toString()));
    }
  }

  FutureOr<void> _onLoadStudentsByTeacher(LoadStudentsByTeacherEvent event, Emitter<StudentState> emit) async {
    emit(StudentLoading());
    try {
      List<StudentModel> students = await firebaseService.getStudentsByTeacherId(event.teacherId);
      emit(StudentListLoaded(students: students));
    } catch (e) {
      emit(StudentError(message: e.toString()));
    }
  }

  FutureOr<void> _onLoadStudentProgress(LoadStudentProgressEvent event, Emitter<StudentState> emit) async {
    emit(StudentLoading());
    try {
      List<QuranProgressModel> progress = await firebaseService.getStudentProgress(event.studentId);
      emit(StudentProgressLoaded(progress: progress));
    } catch (e) {
      emit(StudentError(message: e.toString()));
    }
  }

  FutureOr<void> _onLoadStudentAttendance(LoadStudentAttendanceEvent event, Emitter<StudentState> emit) async {
    emit(StudentLoading());
    try {
      List<AttendanceModel> attendance = await firebaseService.getStudentAttendance(
        event.studentId,
        startDate: event.startDate,
        endDate: event.endDate,
      );
      emit(StudentAttendanceLoaded(attendance: attendance));
    } catch (e) {
      emit(StudentError(message: e.toString()));
    }
  }

  FutureOr<void> _onLoadStudentDocuments(LoadStudentDocumentsEvent event, Emitter<StudentState> emit) async {
    emit(StudentLoading());
    try {
      List<DocumentModel> documents = await firebaseService.getStudentDocuments(event.studentId);
      emit(StudentDocumentsLoaded(documents: documents));
    } catch (e) {
      emit(StudentError(message: e.toString()));
    }
  }

  FutureOr<void> _onLoadStudentRequests(LoadStudentRequestsEvent event, Emitter<StudentState> emit) async {
    emit(StudentLoading());
    try {
      List<RequestModel> requests = await firebaseService.getRequestsByStudentId(event.studentId);
      emit(StudentRequestsLoaded(requests: requests));
    } catch (e) {
      emit(StudentError(message: e.toString()));
    }
  }

  FutureOr<void> _onAddStudentProgress(AddStudentProgressEvent event, Emitter<StudentState> emit) async {
    emit(StudentLoading());
    try {
      await firebaseService.addProgress(event.progress);
      List<QuranProgressModel> progress = await firebaseService.getStudentProgress(event.progress.studentId);
      emit(StudentProgressLoaded(progress: progress));
    } catch (e) {
      emit(StudentError(message: e.toString()));
    }
  }

  FutureOr<void> _onMarkStudentAttendance(MarkStudentAttendanceEvent event, Emitter<StudentState> emit) async {
    emit(StudentLoading());
    try {
      await firebaseService.markAttendance(event.attendance);
      List<AttendanceModel> attendance = await firebaseService.getStudentAttendance(
        event.attendance.studentId,
        startDate: DateTime.now().subtract(const Duration(days: 30)),
      );
      emit(StudentAttendanceLoaded(attendance: attendance));
    } catch (e) {
      emit(StudentError(message: e.toString()));
    }
  }

  FutureOr<void> _onAddStudentRequest(AddStudentRequestEvent event, Emitter<StudentState> emit) async {
    emit(StudentLoading());
    try {
      await firebaseService.addRequest(event.request);
      List<RequestModel> requests = await firebaseService.getRequestsByStudentId(event.request.studentId);
      emit(StudentRequestsLoaded(requests: requests));
    } catch (e) {
      emit(StudentError(message: e.toString()));
    }
  }
}
