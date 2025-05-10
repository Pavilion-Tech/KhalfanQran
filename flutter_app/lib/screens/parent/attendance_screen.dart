import 'package:flutter/material.dart';
import 'package:khalfan_center/config/themes.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({Key? key}) : super(key: key);

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  final List<Map<String, dynamic>> _attendanceRecords = [
    {
      'date': '2025-05-15',
      'day': 'السبت',
      'status': 'present',
      'notes': '',
    },
    {
      'date': '2025-05-16',
      'day': 'الأحد',
      'status': 'present',
      'notes': '',
    },
    {
      'date': '2025-05-17',
      'day': 'الاثنين',
      'status': 'absent',
      'notes': 'غياب بسبب المرض',
    },
    {
      'date': '2025-05-18',
      'day': 'الثلاثاء',
      'status': 'late',
      'notes': 'تأخر 15 دقيقة',
    },
    {
      'date': '2025-05-19',
      'day': 'الأربعاء',
      'status': 'present',
      'notes': '',
    },
    {
      'date': '2025-05-20',
      'day': 'الخميس',
      'status': 'present',
      'notes': '',
    },
    {
      'date': '2025-05-21',
      'day': 'الجمعة',
      'status': 'holiday',
      'notes': 'إجازة أسبوعية',
    },
  ];

  // Helper method to get attendance stats
  Map<String, int> getAttendanceStats() {
    int present = 0;
    int absent = 0;
    int late = 0;
    int holiday = 0;

    for (var record in _attendanceRecords) {
      switch (record['status']) {
        case 'present':
          present++;
          break;
        case 'absent':
          absent++;
          break;
        case 'late':
          late++;
          break;
        case 'holiday':
          holiday++;
          break;
      }
    }

    return {
      'present': present,
      'absent': absent,
      'late': late,
      'holiday': holiday,
      'total': _attendanceRecords.length - holiday,
    };
  }

  String getMonthName() {
    return 'مايو 2025';
  }

  @override
  Widget build(BuildContext context) {
    final stats = getAttendanceStats();
    final attendancePercentage = stats['total'] != 0
        ? (stats['present']! / stats['total']! * 100).toStringAsFixed(0)
        : '0';

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            const Text(
              'سجل الحضور والغياب',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              getMonthName(),
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 24),

            // Attendance rate card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primaryGreen.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'نسبة الحضور:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '$attendancePercentage%',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryGreen,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildAttendanceIndicator(
                        'حضور',
                        '${stats['present']}',
                        AppColors.success,
                      ),
                      _buildAttendanceIndicator(
                        'غياب',
                        '${stats['absent']}',
                        AppColors.error,
                      ),
                      _buildAttendanceIndicator(
                        'تأخير',
                        '${stats['late']}',
                        AppColors.warning,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Attendance log
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'سجل هذا الشهر',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton.icon(
                  onPressed: () {
                    // Show full attendance history
                  },
                  icon: const Icon(Icons.history, size: 16),
                  label: const Text('السجل الكامل'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _attendanceRecords.length,
              itemBuilder: (context, index) {
                final record = _attendanceRecords[index];
                return _buildAttendanceRecord(record);
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Show dialog to request absence excuse
          _showExcuseDialog(context);
        },
        backgroundColor: AppColors.primaryGreen,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildAttendanceIndicator(
    String label,
    String value,
    Color color,
  ) {
    return Column(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade700,
          ),
        ),
      ],
    );
  }

  Widget _buildAttendanceRecord(Map<String, dynamic> record) {
    IconData iconData;
    Color iconColor;
    String statusText;

    switch (record['status']) {
      case 'present':
        iconData = Icons.check_circle;
        iconColor = AppColors.success;
        statusText = 'حضور';
        break;
      case 'absent':
        iconData = Icons.cancel;
        iconColor = AppColors.error;
        statusText = 'غياب';
        break;
      case 'late':
        iconData = Icons.watch_later;
        iconColor = AppColors.warning;
        statusText = 'تأخير';
        break;
      case 'holiday':
        iconData = Icons.event;
        iconColor = Colors.grey;
        statusText = 'إجازة';
        break;
      default:
        iconData = Icons.help;
        iconColor = Colors.grey;
        statusText = 'غير معروف';
    }

    // Format date
    final parts = record['date'].split('-');
    final formattedDate = '${parts[2]}/${parts[1]}/${parts[0]}';

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: iconColor.withOpacity(0.1),
          child: Icon(
            iconData,
            color: iconColor,
          ),
        ),
        title: Row(
          children: [
            Text(
              record['day'],
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              formattedDate,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
        subtitle: record['notes'].isNotEmpty
            ? Text(
                record['notes'],
                style: const TextStyle(fontSize: 12),
              )
            : null,
        trailing: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 4,
          ),
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            statusText,
            style: TextStyle(
              fontSize: 12,
              color: iconColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        onTap: record['status'] == 'absent' || record['status'] == 'late'
            ? () {
                // Show excuse details
                _showDetailsDialog(context, record);
              }
            : null,
      ),
    );
  }

  void _showExcuseDialog(BuildContext context) {
    TextEditingController reasonController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تقديم طلب إجازة'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('يرجى تحديد تاريخ الإجازة وسببها:'),
            const SizedBox(height: 16),
            InkWell(
              onTap: () {
                // Show date picker
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_today, size: 16),
                    const SizedBox(width: 8),
                    Text(
                      '22/05/2025',
                      style: TextStyle(
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: reasonController,
              decoration: const InputDecoration(
                labelText: 'سبب الإجازة',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
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
              // Submit excuse request
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('تم تقديم طلب الإجازة بنجاح'),
                ),
              );
            },
            child: const Text('تقديم'),
          ),
        ],
      ),
    );
  }

  void _showDetailsDialog(BuildContext context, Map<String, dynamic> record) {
    final parts = record['date'].split('-');
    final formattedDate = '${parts[2]}/${parts[1]}/${parts[0]}';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تفاصيل الغياب'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              text: TextSpan(
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                ),
                children: [
                  const TextSpan(
                    text: 'التاريخ: ',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: '$formattedDate (${record['day']})'),
                ],
              ),
            ),
            const SizedBox(height: 8),
            RichText(
              text: TextSpan(
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                ),
                children: [
                  const TextSpan(
                    text: 'الحالة: ',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: record['status'] == 'absent' ? 'غياب' : 'تأخير',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            if (record['notes'].isNotEmpty) ...[
              const Text(
                'ملاحظات:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(record['notes']),
            ],
          ],
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
}