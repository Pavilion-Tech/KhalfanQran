import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:khalfan_center/bloc/auth/auth_bloc.dart';
import 'package:khalfan_center/bloc/student/student_bloc.dart';
import 'package:khalfan_center/config/app_config.dart';
import 'package:khalfan_center/config/routes.dart';
import 'package:khalfan_center/config/themes.dart';
import 'package:khalfan_center/models/news_model.dart';
import 'package:khalfan_center/models/student_model.dart';
import 'package:khalfan_center/services/firebase_service.dart';
import 'package:khalfan_center/widgets/student_card.dart';

class ParentDashboard extends StatefulWidget {
  @override
  _ParentDashboardState createState() => _ParentDashboardState();
}

class _ParentDashboardState extends State<ParentDashboard> {
  final FirebaseService _firebaseService = FirebaseService();
  List<NewsModel> _latestNews = [];
  bool _isLoadingNews = true;
  
  @override
  void initState() {
    super.initState();
    _loadData();
    _loadNews();
  }
  
  void _loadData() {
    final userId = context.read<AuthBloc>().authService.currentUser?.uid;
    if (userId != null) {
      context.read<StudentBloc>().add(LoadStudentsByParentEvent(parentId: userId));
    }
  }
  
  Future<void> _loadNews() async {
    setState(() {
      _isLoadingNews = true;
    });
    
    try {
      _latestNews = await _firebaseService.getLatestNews(3);
      setState(() {
        _isLoadingNews = false;
      });
    } catch (e) {
      setState(() {
        _isLoadingNews = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('فشل في تحميل الأخبار: $e')),
      );
    }
  }
  
  Widget _buildDashboardItem({
    required String title,
    required IconData icon,
    required String route,
    required Color color,
  }) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, route),
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildNewsSection() {
    if (_isLoadingNews) {
      return Center(child: CircularProgressIndicator());
    }
    
    if (_latestNews.isEmpty) {
      return Center(
        child: Text('لا توجد أخبار حالياً'),
      );
    }
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'أحدث الأخبار',
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: () => Navigator.pushNamed(context, AppRoutes.news),
              child: Text('عرض الكل'),
            ),
          ],
        ),
        SizedBox(height: 8),
        SizedBox(
          height: 220,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _latestNews.length,
            itemBuilder: (context, index) {
              final news = _latestNews[index];
              return Container(
                width: 280,
                margin: EdgeInsets.only(right: 16),
                child: Card(
                  clipBehavior: Clip.antiAlias,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (news.imageUrls.isNotEmpty)
                        Image.network(
                          news.imageUrls.first,
                          height: 120,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Container(
                            height: 120,
                            width: double.infinity,
                            color: Colors.grey[300],
                            child: Icon(Icons.image_not_supported, size: 40),
                          ),
                        ),
                      Padding(
                        padding: EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              news.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              news.subtitle,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 14,
                              ),
                            ),
                            SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  news.getRelativeTime(),
                                  style: TextStyle(
                                    color: AppColors.textSecondary,
                                    fontSize: 12,
                                  ),
                                ),
                                Text(
                                  news.getCategoryName(),
                                  style: TextStyle(
                                    color: AppColors.primaryGreen,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        _loadData();
        await _loadNews();
      },
      child: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Students section
            BlocBuilder<StudentBloc, StudentState>(
              builder: (context, state) {
                if (state is StudentLoading) {
                  return Center(child: CircularProgressIndicator());
                } else if (state is StudentError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error_outline, size: 48, color: Colors.red),
                        SizedBox(height: 16),
                        Text(state.message),
                        SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _loadData,
                          child: Text('إعادة المحاولة'),
                        ),
                      ],
                    ),
                  );
                } else if (state is StudentListLoaded) {
                  final students = state.students;
                  
                  if (students.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.person_off, size: 48, color: Colors.grey),
                          SizedBox(height: 16),
                          Text('لا يوجد طلاب مسجلين حالياً'),
                        ],
                      ),
                    );
                  }
                  
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'أبنائي',
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 16),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: students.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: EdgeInsets.only(bottom: 12),
                            child: StudentCard(
                              student: students[index],
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  AppRoutes.studentDetails,
                                  arguments: students[index],
                                );
                              },
                            ),
                          );
                        },
                      ),
                    ],
                  );
                }
                return Container();
              },
            ),
            
            SizedBox(height: 24),
            
            // Dashboard items grid
            Text(
              'الخدمات المتاحة',
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            GridView.count(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              children: [
                _buildDashboardItem(
                  title: 'الخطة الدراسية',
                  icon: Icons.menu_book,
                  route: AppRoutes.learningPlan,
                  color: AppColors.primaryGreen,
                ),
                _buildDashboardItem(
                  title: 'متابعة التقدم',
                  icon: Icons.trending_up,
                  route: AppRoutes.progress,
                  color: AppColors.goldAccent,
                ),
                _buildDashboardItem(
                  title: 'الحضور والغياب',
                  icon: Icons.calendar_today,
                  route: AppRoutes.attendance,
                  color: AppColors.secondaryBlue,
                ),
                _buildDashboardItem(
                  title: 'الشهادات',
                  icon: Icons.card_membership,
                  route: AppRoutes.certificates,
                  color: Colors.purple,
                ),
                _buildDashboardItem(
                  title: 'الطلبات',
                  icon: Icons.assignment,
                  route: AppRoutes.requests,
                  color: Colors.orange,
                ),
                _buildDashboardItem(
                  title: 'المستندات',
                  icon: Icons.folder,
                  route: AppRoutes.documents,
                  color: Colors.teal,
                ),
              ],
            ),
            
            SizedBox(height: 24),
            
            // News section
            _buildNewsSection(),
            
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
