import 'package:flutter/material.dart';
import 'package:khalfan_center/services/firebase_service.dart';
import 'package:khalfan_center/screens/parent/announcement_detail_screen.dart';
import 'package:intl/intl.dart';

class AnnouncementsScreen extends StatefulWidget {
  final FirebaseService firebaseService;
  
  const AnnouncementsScreen({
    Key? key,
    required this.firebaseService,
  }) : super(key: key);

  @override
  State<AnnouncementsScreen> createState() => _AnnouncementsScreenState();
}

class _AnnouncementsScreenState extends State<AnnouncementsScreen> {
  List<Map<String, dynamic>> _announcements = [];
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadAnnouncements();
  }

  Future<void> _loadAnnouncements() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      // استرجاع جميع الإعلانات للآباء
      final announcements = await widget.firebaseService.getAnnouncementsForAudience('أولياء الأمور');
      announcements.sort((a, b) {
        final dateA = a['date'] as DateTime;
        final dateB = b['date'] as DateTime;
        return dateB.compareTo(dateA); // ترتيب تنازلي (الأحدث أولاً)
      });

      setState(() {
        _announcements = announcements;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'حدث خطأ أثناء تحميل الإعلانات: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الإعلانات'),
        centerTitle: true,
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
              onPressed: _loadAnnouncements,
              child: const Text('إعادة المحاولة'),
            ),
          ],
        ),
      );
    }

    if (_announcements.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.campaign_outlined, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'لا توجد إعلانات حالياً',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadAnnouncements,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _announcements.length,
        itemBuilder: (context, index) {
          final announcement = _announcements[index];
          final dateFormat = DateFormat('dd/MM/yyyy');
          final date = announcement['date'] as DateTime;
          final formattedDate = dateFormat.format(date);
          final priority = announcement['priority'] as String;
          
          // تحديد لون الإعلان بناءً على الأولوية
          Color priorityColor;
          switch (priority) {
            case 'مهم':
              priorityColor = Colors.red[700]!;
              break;
            case 'متوسط':
              priorityColor = Colors.orange[700]!;
              break;
            default:
              priorityColor = Colors.blue[700]!;
          }

          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: InkWell(
              onTap: () {
                // عند النقر على الإعلان، يتم فتح صفحة التفاصيل
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AnnouncementDetailScreen(
                      announcement: announcement,
                    ),
                  ),
                );
              },
              borderRadius: BorderRadius.circular(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // العنوان والتاريخ في الأعلى
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: priorityColor.withOpacity(0.1),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.campaign, color: priorityColor),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            announcement['title'] ?? 'بدون عنوان',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: priorityColor,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: priorityColor.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            formattedDate,
                            style: TextStyle(
                              fontSize: 12,
                              color: priorityColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // محتوى الإعلان
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      announcement['content'] ?? '',
                      style: const TextStyle(
                        fontSize: 16,
                        height: 1.5,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  
                  // الفصل بين المحتوى والتذييل
                  const Divider(height: 1),
                  
                  // تذييل مع الشارات (إن وجدت)
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: priorityColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                priority,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: priorityColor,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                announcement['targetAudience'] ?? 'الجميع',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[700],
                                ),
                              ),
                            ),
                          ],
                        ),
                        
                        // زر عرض التفاصيل
                        Text(
                          'عرض التفاصيل',
                          style: TextStyle(
                            color: priorityColor,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
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
    );
  }
}