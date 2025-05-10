import 'package:flutter/material.dart';
import 'package:khalfan_center/models/student_model.dart';
import 'package:intl/intl.dart';

class StudentListItem extends StatelessWidget {
  final StudentModel student;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onViewProgress;

  const StudentListItem({
    Key? key,
    required this.student,
    required this.onEdit,
    required this.onDelete,
    required this.onViewProgress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd/MM/yyyy');
    final theme = Theme.of(context);
    
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: student.gender == StudentGender.male
                      ? Colors.blue
                      : Colors.purple,
                  child: Icon(
                    student.gender == StudentGender.male
                        ? Icons.boy
                        : Icons.girl,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        student.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        student.grade,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert),
                  onSelected: (value) {
                    if (value == 'edit') {
                      onEdit();
                    } else if (value == 'delete') {
                      onDelete();
                    } else if (value == 'progress') {
                      onViewProgress();
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          Icon(Icons.edit, size: 20),
                          SizedBox(width: 8),
                          Text('تعديل'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'progress',
                      child: Row(
                        children: [
                          Icon(Icons.trending_up, size: 20, color: Colors.green),
                          SizedBox(width: 8),
                          Text('عرض التقدم'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete, color: Colors.red, size: 20),
                          SizedBox(width: 8),
                          Text('حذف', style: TextStyle(color: Colors.red)),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const Divider(height: 24),
            Row(
              children: [
                _buildInfoItem(
                  Icons.calendar_today, 
                  'تاريخ الميلاد', 
                  dateFormat.format(student.dateOfBirth),
                ),
                const SizedBox(width: 16),
                _buildInfoItem(
                  Icons.date_range, 
                  'تاريخ الانضمام', 
                  dateFormat.format(student.joinDate),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _buildInfoItem(
                  Icons.grade, 
                  'المستوى', 
                  'المستوى ${student.level}',
                ),
                const SizedBox(width: 16),
                _buildInfoItem(
                  Icons.menu_book, 
                  'السور المحفوظة', 
                  '${student.memorizedSurahs.length} سورة',
                ),
              ],
            ),
            const SizedBox(height: 16),
            InkWell(
              onTap: onViewProgress,
              borderRadius: BorderRadius.circular(8),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                decoration: BoxDecoration(
                  color: theme.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: theme.primaryColor.withOpacity(0.3)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.bar_chart,
                      size: 16,
                      color: theme.primaryColor,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'عرض تفاصيل التقدم',
                      style: TextStyle(
                        color: theme.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String label, String value) {
    return Expanded(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: Colors.blue),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}