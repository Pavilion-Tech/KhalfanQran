import 'package:flutter/material.dart';
import 'package:khalfan_center/config/themes.dart';

class LearningPlanScreen extends StatefulWidget {
  const LearningPlanScreen({Key? key}) : super(key: key);

  @override
  State<LearningPlanScreen> createState() => _LearningPlanScreenState();
}

class _LearningPlanScreenState extends State<LearningPlanScreen> {
  final List<Map<String, dynamic>> _weeklyPlan = [
    {
      'day': 'السبت',
      'date': '15/05/2025',
      'tasks': [
        {
          'type': 'حفظ',
          'surah': 'البقرة',
          'verses': 'الآيات 1-5',
          'completed': true,
        },
        {
          'type': 'مراجعة',
          'surah': 'الفاتحة',
          'verses': 'كاملة',
          'completed': true,
        },
      ],
    },
    {
      'day': 'الأحد',
      'date': '16/05/2025',
      'tasks': [
        {
          'type': 'حفظ',
          'surah': 'البقرة',
          'verses': 'الآيات 6-10',
          'completed': false,
        },
        {
          'type': 'مراجعة',
          'surah': 'البقرة',
          'verses': 'الآيات 1-5',
          'completed': false,
        },
      ],
    },
    {
      'day': 'الاثنين',
      'date': '17/05/2025',
      'tasks': [
        {
          'type': 'حفظ',
          'surah': 'البقرة',
          'verses': 'الآيات 11-15',
          'completed': false,
        },
        {
          'type': 'مراجعة',
          'surah': 'البقرة',
          'verses': 'الآيات 1-10',
          'completed': false,
        },
      ],
    },
    {
      'day': 'الثلاثاء',
      'date': '18/05/2025',
      'tasks': [
        {
          'type': 'حفظ',
          'surah': 'البقرة',
          'verses': 'الآيات 16-20',
          'completed': false,
        },
        {
          'type': 'مراجعة',
          'surah': 'البقرة',
          'verses': 'الآيات 1-15',
          'completed': false,
        },
      ],
    },
    {
      'day': 'الأربعاء',
      'date': '19/05/2025',
      'tasks': [
        {
          'type': 'مراجعة',
          'surah': 'البقرة',
          'verses': 'الآيات 1-20',
          'completed': false,
        },
      ],
    },
    {
      'day': 'الخميس',
      'date': '20/05/2025',
      'tasks': [
        {
          'type': 'اختبار',
          'surah': 'البقرة',
          'verses': 'الآيات 1-20',
          'completed': false,
        },
      ],
    },
    {
      'day': 'الجمعة',
      'date': '21/05/2025',
      'tasks': [],
      'isHoliday': true,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Plan header
            const Text(
              'خطة التعلم الأسبوعية',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'أسبوع 15 مايو - 21 مايو 2025',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 24),

            // Plan summary
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primaryGreen.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildSummaryItem(
                        label: 'المجموع',
                        value: '10',
                        icon: Icons.assignment,
                      ),
                      _buildSummaryItem(
                        label: 'المكتمل',
                        value: '2',
                        icon: Icons.check_circle,
                      ),
                      _buildSummaryItem(
                        label: 'المتبقي',
                        value: '8',
                        icon: Icons.pending_actions,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const LinearProgressIndicator(
                    value: 0.2, // 2 out of 10 tasks completed
                    backgroundColor: Colors.white,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppColors.primaryGreen,
                    ),
                    minHeight: 8,
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'تم إنجاز 20% من خطة الأسبوع',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Weekly plan
            const Text(
              'تفاصيل الخطة',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _weeklyPlan.length,
              itemBuilder: (context, index) {
                final day = _weeklyPlan[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 20,
                                  backgroundColor: day['isHoliday'] == true
                                      ? Colors.grey.shade300
                                      : AppColors.primaryGreen,
                                  child: Text(
                                    day['day'].substring(0, 1),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      day['day'],
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    Text(
                                      day['date'],
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            if (day['isHoliday'] == true)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade200,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Text(
                                  'إجازة',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        if (day['tasks'].isEmpty && day['isHoliday'] != true)
                          const Center(
                            child: Text(
                              'لا توجد مهام لهذا اليوم',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                          )
                        else if (day['isHoliday'] != true)
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: day['tasks'].length,
                            itemBuilder: (context, taskIndex) {
                              final task = day['tasks'][taskIndex];
                              return _buildTaskItem(task);
                            },
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add new task or send notification to teacher
        },
        backgroundColor: AppColors.primaryGreen,
        child: const Icon(Icons.message),
      ),
    );
  }

  Widget _buildSummaryItem({
    required String label,
    required String value,
    required IconData icon,
  }) {
    return Column(
      children: [
        CircleAvatar(
          radius: 24,
          backgroundColor: AppColors.primaryGreen,
          child: Icon(
            icon,
            color: Colors.white,
            size: 24,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
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

  Widget _buildTaskItem(Map<String, dynamic> task) {
    Color typeColor;
    IconData typeIcon;

    switch (task['type']) {
      case 'حفظ':
        typeColor = AppColors.primaryGreen;
        typeIcon = Icons.menu_book;
        break;
      case 'مراجعة':
        typeColor = AppColors.secondaryBlue;
        typeIcon = Icons.replay;
        break;
      case 'اختبار':
        typeColor = AppColors.goldAccent;
        typeIcon = Icons.quiz;
        break;
      default:
        typeColor = Colors.grey;
        typeIcon = Icons.assignment;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: typeColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              typeIcon,
              color: typeColor,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${task['type']} - سورة ${task['surah']}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  task['verses'],
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          Checkbox(
            value: task['completed'],
            activeColor: AppColors.primaryGreen,
            onChanged: (value) {
              // This would update the task status in a real app
              setState(() {
                task['completed'] = value;
              });
            },
          ),
        ],
      ),
    );
  }
}