import 'package:flutter/material.dart';
import 'package:khalfan_center/services/firebase_service.dart';

// تعريف نموذج بيانات الإعلان
class Announcement {
  final String id;
  final String title;
  final String content;
  final DateTime date;
  final String? imageUrl;
  final String priority; // عادي، مهم، عاجل
  final bool isActive;
  final String targetAudience; // الجميع، الطلاب، المعلمين، أولياء الأمور

  Announcement({
    required this.id,
    required this.title,
    required this.content,
    required this.date,
    this.imageUrl,
    required this.priority,
    required this.isActive,
    required this.targetAudience,
  });

  Announcement copyWith({
    String? id,
    String? title,
    String? content,
    DateTime? date,
    String? imageUrl,
    String? priority,
    bool? isActive,
    String? targetAudience,
  }) {
    return Announcement(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      date: date ?? this.date,
      imageUrl: imageUrl ?? this.imageUrl,
      priority: priority ?? this.priority,
      isActive: isActive ?? this.isActive,
      targetAudience: targetAudience ?? this.targetAudience,
    );
  }
}

class ManageAnnouncements extends StatefulWidget {
  final FirebaseService? firebaseService;

  const ManageAnnouncements({
    Key? key,
    required this.firebaseService,
  }) : super(key: key);

  @override
  State<ManageAnnouncements> createState() => _ManageAnnouncementsState();
}

class _ManageAnnouncementsState extends State<ManageAnnouncements> {
  bool _isLoading = false;
  List<Announcement> _announcements = [];
  TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _filterPriority = 'الكل';
  String _filterAudience = 'الكل';

  @override
  void initState() {
    super.initState();
    _loadAnnouncements();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadAnnouncements() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // For now, we'll use sample data
      // In full implementation, fetch from Firebase
      await Future.delayed(const Duration(seconds: 1));
      
      final List<Announcement> sampleAnnouncements = [
        Announcement(
          id: 'announcement1',
          title: 'تغيير موعد الاختبار الشهري',
          content: 'نود إعلامكم بتغيير موعد الاختبار الشهري ليكون يوم الثلاثاء القادم بدلاً من يوم الأربعاء. يرجى الاستعداد والحضور في الموعد الجديد.',
          date: DateTime.now().subtract(const Duration(days: 2)),
          priority: 'مهم',
          isActive: true,
          targetAudience: 'الطلاب',
        ),
        Announcement(
          id: 'announcement2',
          title: 'اجتماع أولياء الأمور',
          content: 'سيتم عقد اجتماع أولياء الأمور يوم الخميس القادم الساعة 7 مساءً لمناقشة مستوى الطلاب والإجابة على استفساراتكم.',
          date: DateTime.now().subtract(const Duration(days: 5)),
          imageUrl: 'https://example.com/meeting_image.jpg',
          priority: 'عادي',
          isActive: true,
          targetAudience: 'أولياء الأمور',
        ),
        Announcement(
          id: 'announcement3',
          title: 'تعميم هام بخصوص الحضور',
          content: 'نظراً للظروف الجوية المتوقعة غداً، سيتم تعليق الدراسة ليوم واحد فقط. وسيتم تعويض اليوم في وقت لاحق.',
          date: DateTime.now().subtract(const Duration(hours: 12)),
          priority: 'عاجل',
          isActive: true,
          targetAudience: 'الجميع',
        ),
        Announcement(
          id: 'announcement4',
          title: 'دورة تدريبية للمعلمين',
          content: 'سيتم إقامة دورة تدريبية متخصصة في أساليب التدريس الحديثة للمعلمين خلال الأسبوع القادم. التسجيل إلزامي لجميع المعلمين.',
          date: DateTime.now().subtract(const Duration(days: 3)),
          priority: 'مهم',
          isActive: true,
          targetAudience: 'المعلمين',
        ),
        Announcement(
          id: 'announcement5',
          title: 'الاحتفال باليوم الوطني',
          content: 'بمناسبة اليوم الوطني، سيقيم المركز احتفالاً خاصاً يوم الأربعاء القادم. ندعو الجميع للمشاركة في هذه المناسبة الوطنية العزيزة.',
          date: DateTime.now().subtract(const Duration(days: 7)),
          imageUrl: 'https://example.com/national_day.jpg',
          priority: 'عادي',
          isActive: false,
          targetAudience: 'الجميع',
        ),
      ];
      
      setState(() {
        _announcements = sampleAnnouncements;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading announcements: $e');
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('حدث خطأ أثناء تحميل بيانات الإعلانات: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  List<Announcement> get _filteredAnnouncements {
    List<Announcement> result = _announcements;
    
    // Apply search query filter
    if (_searchQuery.isNotEmpty) {
      result = result
          .where((announcement) =>
              announcement.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              announcement.content.toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();
    }
    
    // Apply priority filter
    if (_filterPriority != 'الكل') {
      result = result.where((announcement) => announcement.priority == _filterPriority).toList();
    }
    
    // Apply audience filter
    if (_filterAudience != 'الكل') {
      result = result
          .where((announcement) => announcement.targetAudience == _filterAudience)
          .toList();
    }
    
    // Sort by date (newest first)
    result.sort((a, b) => b.date.compareTo(a.date));
    
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('إدارة الإعلانات'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'بحث عن إعلان',
                hintText: 'ادخل عنوان أو محتوى الإعلان',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {
                            _searchQuery = '';
                          });
                        },
                      )
                    : null,
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),

          // Filters
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'الأهمية',
                      isDense: true,
                    ),
                    value: _filterPriority,
                    items: const [
                      DropdownMenuItem<String>(
                        value: 'الكل',
                        child: Text('الكل'),
                      ),
                      DropdownMenuItem<String>(
                        value: 'عادي',
                        child: Text('عادي'),
                      ),
                      DropdownMenuItem<String>(
                        value: 'مهم',
                        child: Text('مهم'),
                      ),
                      DropdownMenuItem<String>(
                        value: 'عاجل',
                        child: Text('عاجل'),
                      ),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _filterPriority = value;
                        });
                      }
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'الفئة المستهدفة',
                      isDense: true,
                    ),
                    value: _filterAudience,
                    items: const [
                      DropdownMenuItem<String>(
                        value: 'الكل',
                        child: Text('الكل'),
                      ),
                      DropdownMenuItem<String>(
                        value: 'الجميع',
                        child: Text('الجميع'),
                      ),
                      DropdownMenuItem<String>(
                        value: 'الطلاب',
                        child: Text('الطلاب'),
                      ),
                      DropdownMenuItem<String>(
                        value: 'المعلمين',
                        child: Text('المعلمين'),
                      ),
                      DropdownMenuItem<String>(
                        value: 'أولياء الأمور',
                        child: Text('أولياء الأمور'),
                      ),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _filterAudience = value;
                        });
                      }
                    },
                  ),
                ),
              ],
            ),
          ),

          // Announcement list
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _filteredAnnouncements.isEmpty
                    ? const Center(
                        child: Text(
                          'لا يوجد إعلانات للعرض',
                          style: TextStyle(fontSize: 16),
                        ),
                      )
                    : ListView.builder(
                        itemCount: _filteredAnnouncements.length,
                        itemBuilder: (context, index) {
                          final announcement = _filteredAnnouncements[index];
                          return _buildAnnouncementCard(announcement);
                        },
                      ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddEditAnnouncementDialog(context);
        },
        child: const Icon(Icons.add),
        tooltip: 'إضافة إعلان جديد',
      ),
    );
  }

  Widget _buildAnnouncementCard(Announcement announcement) {
    // Define priority color
    Color priorityColor;
    switch (announcement.priority) {
      case 'عاجل':
        priorityColor = Colors.red;
        break;
      case 'مهم':
        priorityColor = Colors.orange;
        break;
      case 'عادي':
        priorityColor = Colors.blue;
        break;
      default:
        priorityColor = Colors.grey;
    }

    // Define audience icon
    IconData audienceIcon;
    switch (announcement.targetAudience) {
      case 'الطلاب':
        audienceIcon = Icons.school;
        break;
      case 'المعلمين':
        audienceIcon = Icons.person;
        break;
      case 'أولياء الأمور':
        audienceIcon = Icons.people;
        break;
      case 'الجميع':
        audienceIcon = Icons.groups;
        break;
      default:
        audienceIcon = Icons.group;
    }
    
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: announcement.isActive ? null : Colors.grey.shade100,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Indicator for active/inactive
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: announcement.isActive ? Colors.green : Colors.grey,
                  ),
                ),
                const SizedBox(width: 8),
                
                // Priority badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: priorityColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: priorityColor),
                  ),
                  child: Text(
                    announcement.priority,
                    style: TextStyle(
                      color: priorityColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                
                // Audience badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        audienceIcon,
                        size: 12,
                        color: Colors.black87,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        announcement.targetAudience,
                        style: const TextStyle(
                          color: Colors.black87,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                
                const Spacer(),
                
                // Date
                Text(
                  _formatDate(announcement.date),
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            
            // Title
            Text(
              announcement.title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: announcement.isActive ? null : Colors.grey,
              ),
            ),
            const SizedBox(height: 8),
            
            // Content (limited to 3 lines with show more option)
            Text(
              announcement.content,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 14,
                color: announcement.isActive ? null : Colors.grey,
              ),
            ),
            
            // Show more link if content is too long
            if (announcement.content.length > 150)
              TextButton(
                onPressed: () => _showAnnouncementDetailsDialog(context, announcement),
                child: const Text('عرض المزيد'),
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  alignment: Alignment.centerRight,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
              
            const SizedBox(height: 16),
            
            // Action buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Toggle active status
                TextButton.icon(
                  onPressed: () {
                    setState(() {
                      final index = _announcements.indexWhere((a) => a.id == announcement.id);
                      if (index != -1) {
                        _announcements[index] = announcement.copyWith(
                          isActive: !announcement.isActive,
                        );
                      }
                    });
                  },
                  icon: Icon(
                    announcement.isActive ? Icons.visibility_off : Icons.visibility,
                    size: 18,
                  ),
                  label: Text(announcement.isActive ? 'إخفاء' : 'إظهار'),
                ),
                const SizedBox(width: 8),
                
                // Edit button
                TextButton.icon(
                  onPressed: () {
                    _showAddEditAnnouncementDialog(context, announcement: announcement);
                  },
                  icon: const Icon(Icons.edit, size: 18),
                  label: const Text('تعديل'),
                ),
                const SizedBox(width: 8),
                
                // Delete button
                TextButton.icon(
                  onPressed: () {
                    _showDeleteConfirmationDialog(context, announcement);
                  },
                  icon: const Icon(Icons.delete, size: 18, color: Colors.red),
                  label: const Text(
                    'حذف',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final difference = DateTime.now().difference(date);
    
    if (difference.inDays > 0) {
      return 'منذ ${difference.inDays} يوم';
    } else if (difference.inHours > 0) {
      return 'منذ ${difference.inHours} ساعة';
    } else if (difference.inMinutes > 0) {
      return 'منذ ${difference.inMinutes} دقيقة';
    } else {
      return 'الآن';
    }
  }

  void _showAnnouncementDetailsDialog(BuildContext context, Announcement announcement) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(announcement.title),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _formatDate(announcement.date),
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 16),
              // Display image if available
              if (announcement.imageUrl != null) ...[
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    announcement.imageUrl!,
                    width: double.infinity,
                    height: 200,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: double.infinity,
                        height: 200,
                        color: Colors.grey.shade300,
                        child: const Icon(
                          Icons.broken_image,
                          color: Colors.white,
                          size: 40,
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
              ],
              Text(announcement.content),
              const SizedBox(height: 16),
              Row(
                children: [
                  // Priority badge
                  _buildInfoBadge(
                    label: 'الأهمية',
                    value: announcement.priority,
                    color: announcement.priority == 'عاجل'
                        ? Colors.red
                        : announcement.priority == 'مهم'
                            ? Colors.orange
                            : Colors.blue,
                  ),
                  const SizedBox(width: 8),
                  // Target audience badge
                  _buildInfoBadge(
                    label: 'الفئة المستهدفة',
                    value: announcement.targetAudience,
                    color: Colors.grey,
                  ),
                ],
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('إغلاق'),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoBadge({
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: color),
          ),
          child: Text(
            value,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }

  void _showAddEditAnnouncementDialog(BuildContext context, {Announcement? announcement}) {
    final isEditing = announcement != null;
    final titleController = TextEditingController(text: isEditing ? announcement.title : '');
    final contentController = TextEditingController(text: isEditing ? announcement.content : '');
    final imageUrlController = TextEditingController(
        text: isEditing ? announcement.imageUrl ?? '' : '');
    
    String selectedPriority = isEditing ? announcement.priority : 'عادي';
    String selectedAudience = isEditing ? announcement.targetAudience : 'الجميع';
    bool isActive = isEditing ? announcement.isActive : true;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(isEditing ? 'تعديل إعلان' : 'إضافة إعلان جديد'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: 'عنوان الإعلان',
                    hintText: 'ادخل عنوان الإعلان',
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: contentController,
                  decoration: const InputDecoration(
                    labelText: 'محتوى الإعلان',
                    hintText: 'ادخل محتوى الإعلان',
                    alignLabelWithHint: true,
                  ),
                  maxLines: 5,
                  textAlign: TextAlign.start,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: imageUrlController,
                  decoration: const InputDecoration(
                    labelText: 'رابط الصورة (اختياري)',
                    hintText: 'ادخل رابط الصورة',
                  ),
                ),
                const SizedBox(height: 16),
                // Priority dropdown
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'الأهمية',
                  ),
                  value: selectedPriority,
                  items: const [
                    DropdownMenuItem<String>(
                      value: 'عادي',
                      child: Text('عادي'),
                    ),
                    DropdownMenuItem<String>(
                      value: 'مهم',
                      child: Text('مهم'),
                    ),
                    DropdownMenuItem<String>(
                      value: 'عاجل',
                      child: Text('عاجل'),
                    ),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        selectedPriority = value;
                      });
                    }
                  },
                ),
                const SizedBox(height: 16),
                // Target audience dropdown
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'الفئة المستهدفة',
                  ),
                  value: selectedAudience,
                  items: const [
                    DropdownMenuItem<String>(
                      value: 'الجميع',
                      child: Text('الجميع'),
                    ),
                    DropdownMenuItem<String>(
                      value: 'الطلاب',
                      child: Text('الطلاب'),
                    ),
                    DropdownMenuItem<String>(
                      value: 'المعلمين',
                      child: Text('المعلمين'),
                    ),
                    DropdownMenuItem<String>(
                      value: 'أولياء الأمور',
                      child: Text('أولياء الأمور'),
                    ),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        selectedAudience = value;
                      });
                    }
                  },
                ),
                const SizedBox(height: 16),
                // Active switch
                Row(
                  children: [
                    const Text('نشط'),
                    const Spacer(),
                    Switch(
                      value: isActive,
                      onChanged: (value) {
                        setState(() {
                          isActive = value;
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('إلغاء'),
            ),
            ElevatedButton(
              onPressed: () {
                // Validate input
                if (titleController.text.isEmpty || contentController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('يرجى ملء العنوان والمحتوى'),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }

                if (isEditing) {
                  // Update existing announcement
                  final updatedAnnouncement = announcement.copyWith(
                    title: titleController.text,
                    content: contentController.text,
                    imageUrl: imageUrlController.text.isEmpty
                        ? null
                        : imageUrlController.text,
                    priority: selectedPriority,
                    isActive: isActive,
                    targetAudience: selectedAudience,
                  );
                  
                  setState(() {
                    final index = _announcements.indexWhere((a) => a.id == announcement.id);
                    if (index != -1) {
                      _announcements[index] = updatedAnnouncement;
                    }
                  });
                  
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('تم تحديث الإعلان بنجاح'),
                    ),
                  );
                } else {
                  // Add new announcement
                  final newAnnouncement = Announcement(
                    id: 'announcement_${DateTime.now().millisecondsSinceEpoch}',
                    title: titleController.text,
                    content: contentController.text,
                    date: DateTime.now(),
                    imageUrl: imageUrlController.text.isEmpty
                        ? null
                        : imageUrlController.text,
                    priority: selectedPriority,
                    isActive: isActive,
                    targetAudience: selectedAudience,
                  );
                  
                  setState(() {
                    _announcements.add(newAnnouncement);
                  });
                  
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('تم إضافة الإعلان بنجاح'),
                    ),
                  );
                }
                
                Navigator.pop(context);
              },
              child: Text(isEditing ? 'تحديث' : 'إضافة'),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, Announcement announcement) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تأكيد الحذف'),
        content: Text('هل أنت متأكد من حذف الإعلان "${announcement.title}"؟'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              // In full implementation, delete from Firebase
              setState(() {
                _announcements.removeWhere((a) => a.id == announcement.id);
              });
              
              Navigator.pop(context);
              
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('تم حذف الإعلان بنجاح'),
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('حذف'),
          ),
        ],
      ),
    );
  }
}