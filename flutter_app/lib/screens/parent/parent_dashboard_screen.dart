import 'package:flutter/material.dart';
import 'package:khalfan_center/models/student_model.dart';
import 'package:khalfan_center/services/auth_service.dart';
import 'package:khalfan_center/services/firebase_service.dart';
import 'package:khalfan_center/widgets/admin/feature_grid_item.dart';
import 'package:khalfan_center/widgets/parent/student_summary_card.dart';
import 'package:khalfan_center/screens/parent/announcements_screen.dart';
import 'package:khalfan_center/screens/parent/announcement_detail_screen.dart';

class ParentDashboardScreen extends StatefulWidget {
  final AuthService authService;
  final FirebaseService firebaseService;
  final String parentId;
  
  const ParentDashboardScreen({
    Key? key,
    required this.authService,
    required this.firebaseService,
    required this.parentId,
  }) : super(key: key);

  @override
  State<ParentDashboardScreen> createState() => _ParentDashboardScreenState();
}

class _ParentDashboardScreenState extends State<ParentDashboardScreen> {
  List<StudentModel> _children = [];
  List<Map<String, dynamic>> _announcements = [];
  bool _isLoading = true;
  String _errorMessage = '';
  
  @override
  void initState() {
    super.initState();
    _loadParentData();
  }
  
  Future<void> _loadParentData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });
    
    try {
      // استرجاع معلومات أبناء ولي الأمر
      final children = await widget.firebaseService.getStudentsForParent(widget.parentId);
      
      // استرجاع آخر الإعلانات
      final announcements = await widget.firebaseService.getAnnouncementsForAudience('أولياء الأمور');
      
      setState(() {
        _children = children;
        _announcements = announcements;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'حدث خطأ أثناء تحميل البيانات: $e';
        _isLoading = false;
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الصفحة الرئيسية لولي الأمر'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              try {
                await widget.authService.signOut();
                if (mounted) {
                  Navigator.of(context).pop();
                }
              } catch (e) {
                print('Error signing out: $e');
              }
            },
          ),
        ],
      ),
      body: _buildBody(),
    );
  }
  
  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    
    if (_errorMessage.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_errorMessage, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadParentData,
              child: const Text('إعادة المحاولة'),
            ),
          ],
        ),
      );
    }
    
    return RefreshIndicator(
      onRefresh: _loadParentData,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome message
            const Text(
              'مرحباً بك في تطبيق ولي الأمر',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'مركز خلفان لتحفيظ القرآن الكريم',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 24),
            
            // Quick stats
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(Icons.people, size: 32, color: Colors.blue[700]),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'عدد الأبناء المسجلين',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${_children.length} طالب',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[700],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            
            // Features grid
            const Text(
              'الميزات المتاحة',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            GridView.count(
              crossAxisCount: 3,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.0,
              children: [
                FeatureGridItem(
                  title: 'التقارير',
                  icon: Icons.summarize,
                  color: Colors.blue,
                  onTap: () {
                    // سيتم تنفيذه لاحقًا
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('قريبًا: التقارير'),
                      ),
                    );
                  },
                ),
                FeatureGridItem(
                  title: 'الحضور',
                  icon: Icons.fact_check,
                  color: Colors.green,
                  onTap: () {
                    // سيتم تنفيذه لاحقًا
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('قريبًا: سجل الحضور'),
                      ),
                    );
                  },
                ),
                FeatureGridItem(
                  title: 'الإعلانات',
                  icon: Icons.campaign,
                  color: Colors.orange,
                  onTap: () {
                    // فتح صفحة الإعلانات
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AnnouncementsScreen(
                          firebaseService: widget.firebaseService,
                        ),
                      ),
                    );
                  },
                ),
                FeatureGridItem(
                  title: 'المنهج',
                  icon: Icons.menu_book,
                  color: Colors.purple,
                  onTap: () {
                    // سيتم تنفيذه لاحقًا
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('قريبًا: المنهج'),
                      ),
                    );
                  },
                ),
                FeatureGridItem(
                  title: 'التواصل',
                  icon: Icons.message,
                  color: Colors.pink,
                  onTap: () {
                    // سيتم تنفيذه لاحقًا
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('قريبًا: التواصل'),
                      ),
                    );
                  },
                ),
                FeatureGridItem(
                  title: 'الملف الشخصي',
                  icon: Icons.person,
                  color: Colors.teal,
                  onTap: () {
                    // سيتم تنفيذه لاحقًا
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('قريبًا: الملف الشخصي'),
                      ),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 32),
            
            // Children section
            const Text(
              'أبنائي',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            if (_children.isEmpty)
              const Center(
                child: Text('لا يوجد أبناء مسجلين حاليًا'),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _children.length,
                itemBuilder: (context, index) {
                  final student = _children[index];
                  return StudentSummaryCard(
                    student: student,
                    onTap: () {
                      // Open student details
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('قريبًا: تفاصيل الطالب'),
                        ),
                      );
                    },
                  );
                },
              ),
            
            const SizedBox(height: 32),
            
            // Latest announcements section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'آخر الإعلانات',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // Navigate to all announcements
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AnnouncementsScreen(
                          firebaseService: widget.firebaseService,
                        ),
                      ),
                    );
                  },
                  child: const Text('عرض الكل'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (_announcements.isEmpty)
              const Center(
                child: Text('لا توجد إعلانات جديدة'),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _announcements.length > 2 ? 2 : _announcements.length, // Show only 2 recent
                itemBuilder: (context, index) {
                  final announcement = _announcements[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      title: Text(
                        announcement['title'] ?? 'بدون عنوان',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        announcement['content'] ?? '',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      leading: CircleAvatar(
                        backgroundColor: Colors.orange[100],
                        child: Icon(
                          Icons.campaign,
                          color: Colors.orange[800],
                        ),
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {
                        // Navigate directly to announcement detail screen
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AnnouncementDetailScreen(
                              announcement: announcement,
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}