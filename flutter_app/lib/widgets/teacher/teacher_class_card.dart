import 'package:flutter/material.dart';

class TeacherClassCard extends StatelessWidget {
  final Map<String, dynamic> classData;
  final VoidCallback onTap;

  const TeacherClassCard({
    Key? key,
    required this.classData,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with title and status badge
              Row(
                children: [
                  Expanded(
                    child: Text(
                      classData['name'] ?? 'حلقة بلا اسم',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: classData['status'] == 'نشط'
                          ? Colors.green[100]
                          : Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      classData['status'] ?? 'غير معروف',
                      style: TextStyle(
                        fontSize: 12,
                        color: classData['status'] == 'نشط'
                            ? Colors.green[800]
                            : Colors.grey[700],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              
              // Class details
              Row(
                children: [
                  _buildDetailItem(
                    Icons.location_on,
                    'المكان',
                    classData['location'] ?? 'غير محدد',
                  ),
                  const SizedBox(width: 24),
                  _buildDetailItem(
                    Icons.access_time,
                    'الوقت',
                    classData['time'] ?? 'غير محدد',
                  ),
                ],
              ),
              const SizedBox(height: 12),
              
              Row(
                children: [
                  _buildDetailItem(
                    Icons.people,
                    'عدد الطلاب',
                    '${classData['currentStudents'] ?? 0} / ${classData['maxStudents'] ?? 0}',
                  ),
                  const SizedBox(width: 24),
                  _buildDetailItem(
                    Icons.grade,
                    'المستوى',
                    classData['level'] ?? 'غير محدد',
                  ),
                ],
              ),
              const SizedBox(height: 16),
              
              // Days section
              if (classData['days'] != null && classData['days'] is List) ...[
                const Text(
                  'أيام الحلقة:',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: (classData['days'] as List).map<Widget>((day) {
                    return Chip(
                      label: Text(day.toString()),
                      backgroundColor: Colors.blue[50],
                      labelStyle: TextStyle(
                        fontSize: 12,
                        color: Colors.blue[800],
                      ),
                      padding: EdgeInsets.zero,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    );
                  }).toList(),
                ),
              ],
              
              const SizedBox(height: 8),
              
              // Action buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton.icon(
                    onPressed: () {
                      // Navigate to attendance screen for this class
                    },
                    icon: const Icon(Icons.fact_check, size: 18),
                    label: const Text('تسجيل الحضور'),
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  OutlinedButton.icon(
                    onPressed: () {
                      // Navigate to class details screen
                      onTap();
                    },
                    icon: const Icon(Icons.info_outline, size: 18),
                    label: const Text('التفاصيل'),
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailItem(IconData icon, String label, String value) {
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
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}