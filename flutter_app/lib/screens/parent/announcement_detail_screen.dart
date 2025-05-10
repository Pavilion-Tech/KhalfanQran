import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AnnouncementDetailScreen extends StatelessWidget {
  final Map<String, dynamic> announcement;
  
  const AnnouncementDetailScreen({
    Key? key,
    required this.announcement,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd/MM/yyyy');
    final date = announcement['date'] as DateTime;
    final formattedDate = dateFormat.format(date);
    final priority = announcement['priority'] as String;
    
    // Determinar color basado en la prioridad
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

    return Scaffold(
      appBar: AppBar(
        title: const Text('تفاصيل الإعلان'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header with priority color
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: priorityColor.withOpacity(0.1),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    announcement['title'] ?? 'بدون عنوان',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: priorityColor,
                    ),
                  ),
                  const SizedBox(height: 12),
                  
                  // Date and priority badges
                  Row(
                    children: [
                      Icon(Icons.calendar_today, size: 16, color: priorityColor),
                      const SizedBox(width: 4),
                      Text(
                        formattedDate,
                        style: TextStyle(
                          fontSize: 14,
                          color: priorityColor,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: priorityColor.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              _getPriorityIcon(priority),
                              size: 16,
                              color: priorityColor,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              priority,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: priorityColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            // Content
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'محتوى الإعلان',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    announcement['content'] ?? '',
                    style: const TextStyle(
                      fontSize: 16,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Additional info section
                  const Text(
                    'معلومات إضافية',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildInfoRow('الجمهور المستهدف', announcement['targetAudience'] ?? 'الجميع'),
                  _buildInfoRow('حالة الإعلان', announcement['isActive'] == true ? 'نشط' : 'غير نشط'),
                  
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  IconData _getPriorityIcon(String priority) {
    switch (priority) {
      case 'مهم':
        return Icons.priority_high;
      case 'متوسط':
        return Icons.error_outline;
      default:
        return Icons.info_outline;
    }
  }
  
  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: ',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}