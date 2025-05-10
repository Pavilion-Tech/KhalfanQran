import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:khalfan_center/bloc/student/student_bloc.dart';
import 'package:khalfan_center/config/routes.dart';
import 'package:khalfan_center/config/themes.dart';
import 'package:khalfan_center/models/student_model.dart';
import 'package:khalfan_center/widgets/custom_button.dart';
import 'package:khalfan_center/widgets/progress_card.dart';
import 'package:khalfan_center/widgets/attendance_card.dart';

class StudentDetailsScreen extends StatefulWidget {
  @override
  _StudentDetailsScreenState createState() => _StudentDetailsScreenState();
}

class _StudentDetailsScreenState extends State<StudentDetailsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  StudentModel? _student;
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }
  
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is StudentModel) {
      _student = args;
      _loadStudentData();
    }
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
  
  void _loadStudentData() {
    if (_student != null) {
      context.read<StudentBloc>().add(LoadStudentProgressEvent(studentId: _student!.id));
      context.read<StudentBloc>().add(LoadStudentAttendanceEvent(
        studentId: _student!.id,
        startDate: DateTime.now().subtract(Duration(days: 30)),
      ));
      context.read<StudentBloc>().add(LoadStudentRequestsEvent(studentId: _student!.id));
    }
  }
  
  Widget _buildStudentInfo() {
    if (_student == null) {
      return Center(child: Text('لا توجد بيانات متاحة'));
    }
    
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primaryGreen.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundColor: AppColors.primaryGreen,
            backgroundImage: _student!.profileImageUrl.isNotEmpty
                ? NetworkImage(_student!.profileImageUrl)
                : null,
            child: _student!.profileImageUrl.isEmpty
                ? Icon(Icons.person, size: 50, color: Colors.white)
                : null,
          ),
          SizedBox(height: 16),
          Text(
            _student!.fullName,
            style: Theme.of(context).textTheme.headlineSmall!.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            _student!.circleName ?? 'غير محدد',
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildInfoItem(
                label: 'العمر',
                value: '${_student!.getAge()} سنة',
                icon: Icons.cake,
              ),
              _buildInfoItem(
                label: 'تاريخ التسجيل',
                value: '${_student!.registrationDate.day}/${_student!.registrationDate.month}/${_student!.registrationDate.year}',
                icon: Icons.calendar_today,
              ),
              _buildInfoItem(
                label: 'الجنس',
                value: _student!.gender == 'male' ? 'ذكر' : 'أنثى',
                icon: Icons.person,
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildInfoItem({
    required String label,
    required String value,
    required IconData icon,
  }) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.primaryGreen.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: AppColors.primaryGreen,
            size: 24,
          ),
        ),
        SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
  
  Widget _buildOverviewTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStudentInfo(),
          SizedBox(height: 24),
          
          // Quick Actions
          Text(
            'إجراءات سريعة',
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: CustomButton(
                  text: 'طلب استئذان',
                  icon: Icons.exit_to_app,
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      AppRoutes.requests,
                      arguments: _student,
                    );
                  },
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: CustomButton(
                  text: 'عرض التقدم',
                  icon: Icons.trending_up,
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      AppRoutes.progress,
                      arguments: _student,
                    );
                  },
                ),
              ),
            ],
          ),
          SizedBox(height: 24),
          
          // Recent Progress
          Text(
            'التقدم الأخير',
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16),
          BlocBuilder<StudentBloc, StudentState>(
            builder: (context, state) {
              if (state is StudentProgressLoaded) {
                final progress = state.progress;
                
                if (progress.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 32),
                      child: Text('لا يوجد تقدم مسجل بعد'),
                    ),
                  );
                }
                
                // Show only the 3 most recent progress entries
                final recentProgress = progress.length > 3 
                    ? progress.sublist(0, 3) 
                    : progress;
                    
                return Column(
                  children: recentProgress.map((item) => Padding(
                    padding: EdgeInsets.only(bottom: 12),
                    child: ProgressCard(progress: item),
                  )).toList(),
                );
              }
              
              return Center(child: CircularProgressIndicator());
            },
          ),
          
          // View All Progress Button
          TextButton.icon(
            onPressed: () {
              Navigator.pushNamed(
                context,
                AppRoutes.progress,
                arguments: _student,
              );
            },
            icon: Icon(Icons.arrow_forward),
            label: Text('عرض كل التقدم'),
          ),
          
          SizedBox(height: 24),
          
          // Recent Attendance
          Text(
            'الحضور الأخير',
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16),
          BlocBuilder<StudentBloc, StudentState>(
            builder: (context, state) {
              if (state is StudentAttendanceLoaded) {
                final attendance = state.attendance;
                
                if (attendance.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 32),
                      child: Text('لا يوجد سجل حضور بعد'),
                    ),
                  );
                }
                
                // Show only the 3 most recent attendance entries
                final recentAttendance = attendance.length > 3 
                    ? attendance.sublist(0, 3) 
                    : attendance;
                    
                return Column(
                  children: recentAttendance.map((item) => Padding(
                    padding: EdgeInsets.only(bottom: 12),
                    child: AttendanceCard(attendance: item),
                  )).toList(),
                );
              }
              
              return Center(child: CircularProgressIndicator());
            },
          ),
          
          // View All Attendance Button
          TextButton.icon(
            onPressed: () {
              Navigator.pushNamed(
                context,
                AppRoutes.attendance,
                arguments: _student,
              );
            },
            icon: Icon(Icons.arrow_forward),
            label: Text('عرض كل سجل الحضور'),
          ),
        ],
      ),
    );
  }
  
  Widget _buildProgressTab() {
    return BlocBuilder<StudentBloc, StudentState>(
      builder: (context, state) {
        if (state is StudentProgressLoaded) {
          final progress = state.progress;
          
          if (progress.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.trending_up, size: 48, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('لا يوجد تقدم مسجل بعد'),
                ],
              ),
            );
          }
          
          return ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: progress.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.only(bottom: 12),
                child: ProgressCard(progress: progress[index]),
              );
            },
          );
        }
        
        return Center(child: CircularProgressIndicator());
      },
    );
  }
  
  Widget _buildAttendanceTab() {
    return BlocBuilder<StudentBloc, StudentState>(
      builder: (context, state) {
        if (state is StudentAttendanceLoaded) {
          final attendance = state.attendance;
          
          if (attendance.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.calendar_today, size: 48, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('لا يوجد سجل حضور بعد'),
                ],
              ),
            );
          }
          
          return ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: attendance.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.only(bottom: 12),
                child: AttendanceCard(attendance: attendance[index]),
              );
            },
          );
        }
        
        return Center(child: CircularProgressIndicator());
      },
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_student?.fullName ?? 'تفاصيل الطالب'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'نظرة عامة'),
            Tab(text: 'التقدم'),
            Tab(text: 'الحضور'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildOverviewTab(),
          _buildProgressTab(),
          _buildAttendanceTab(),
        ],
      ),
    );
  }
}
