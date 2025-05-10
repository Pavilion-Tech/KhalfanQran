import 'package:flutter/material.dart';
import 'package:khalfan_center/models/student_model.dart';
import 'package:intl/intl.dart';

class StudentSummaryCard extends StatelessWidget {
  final StudentModel student;
  final VoidCallback onTap;

  const StudentSummaryCard({
    Key? key,
    required this.student,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dateFormatter = DateFormat('dd/MM/yyyy');
    
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
              // Header with name and icon
              Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: student.gender == StudentGender.male
                        ? Colors.blue[100]
                        : Colors.pink[100],
                    child: Icon(
                      student.gender == StudentGender.male
                          ? Icons.boy
                          : Icons.girl,
                      color: student.gender == StudentGender.male
                          ? Colors.blue[700]
                          : Colors.pink[700],
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
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green[100],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'المستوى ${student.level}',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.green[800],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 16),
              
              // Progress summary
              const Text(
                'ملخص التقدم:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              
              // Progress metrics
              Row(
                children: [
                  _buildProgressMetric(
                    'السور المحفوظة',
                    '${student.memorizedSurahs.length}',
                    '114',
                    Colors.green,
                  ),
                  const SizedBox(width: 16),
                  _buildProgressMetric(
                    'الحضور الشهري',
                    '18', // هذه بيانات مؤقتة، سيتم استبدالها بالبيانات الفعلية
                    '22',
                    Colors.blue,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              
              // Action buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton.icon(
                    onPressed: () {
                      // Navigate to attendance report
                    },
                    icon: const Icon(Icons.calendar_today, size: 18),
                    label: const Text('سجل الحضور'),
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton.icon(
                    onPressed: onTap,
                    icon: const Icon(Icons.analytics, size: 18),
                    label: const Text('تقارير التقدم'),
                    style: ElevatedButton.styleFrom(
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
  
  Widget _buildProgressMetric(String label, String value, String total, Color color) {
    // Calculate percentage
    double percentage = double.tryParse(value) != null && double.tryParse(total) != null
        ? (double.parse(value) / double.parse(total)) * 100
        : 0.0;
    
    // Use color with opacity for light version
    final lightColor = color.withOpacity(0.2);
    
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              Text(
                ' / $total',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: percentage / 100,
              backgroundColor: lightColor,
              valueColor: AlwaysStoppedAnimation<Color>(color),
              minHeight: 8,
            ),
          ),
        ],
      ),
    );
  }
}