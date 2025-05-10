import 'package:flutter/material.dart';
import 'package:khalfan_center/config/themes.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({Key? key}) : super(key: key);

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  final List<Map<String, dynamic>> _memorizedSurahs = [
    {
      'name': 'الفاتحة',
      'arabic_name': 'الفاتحة',
      'verses': 7,
      'memorized_date': '10/02/2025',
      'score': 10,
      'max_score': 10,
    },
    {
      'name': 'الإخلاص',
      'arabic_name': 'الإخلاص',
      'verses': 4,
      'memorized_date': '15/02/2025',
      'score': 9,
      'max_score': 10,
    },
    {
      'name': 'الفلق',
      'arabic_name': 'الفلق',
      'verses': 5,
      'memorized_date': '01/03/2025',
      'score': 10,
      'max_score': 10,
    },
    {
      'name': 'الناس',
      'arabic_name': 'الناس',
      'verses': 6,
      'memorized_date': '15/03/2025',
      'score': 8,
      'max_score': 10,
    },
  ];

  final List<Map<String, dynamic>> _inProgressSurahs = [
    {
      'name': 'البقرة',
      'arabic_name': 'البقرة',
      'verses': 286,
      'progress': 20,
      'last_revision': '05/05/2025',
    },
    {
      'name': 'آل عمران',
      'arabic_name': 'آل عمران',
      'verses': 200,
      'progress': 5,
      'last_revision': '01/05/2025',
    },
  ];

  final List<Map<String, dynamic>> _monthlyProgress = [
    {'month': 'يناير', 'verses': 17},
    {'month': 'فبراير', 'verses': 11},
    {'month': 'مارس', 'verses': 11},
    {'month': 'أبريل', 'verses': 20},
    {'month': 'مايو', 'verses': 5},
  ];

  @override
  Widget build(BuildContext context) {
    // Calculate total stats
    final totalMemorizedVerses = _memorizedSurahs.fold<int>(
        0, (sum, surah) => sum + (surah['verses'] as int));
    final totalSurahs = _memorizedSurahs.length;

    // Calculate average score
    final totalScore = _memorizedSurahs.fold<int>(
        0, (sum, surah) => sum + (surah['score'] as int));
    final averageScore =
        totalScore / (_memorizedSurahs.isEmpty ? 1 : _memorizedSurahs.length);

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Progress summary cards
            const Text(
              'ملخص التقدم',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildSummaryCard(
                    title: 'السور المحفوظة',
                    value: '$totalSurahs',
                    icon: Icons.menu_book,
                    color: AppColors.primaryGreen,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildSummaryCard(
                    title: 'الآيات المحفوظة',
                    value: '$totalMemorizedVerses',
                    icon: Icons.format_list_numbered,
                    color: AppColors.secondaryBlue,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildSummaryCard(
                    title: 'متوسط التقييم',
                    value: '${averageScore.toStringAsFixed(1)}/10',
                    icon: Icons.star,
                    color: AppColors.goldAccent,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Monthly progress
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'التقدم الشهري',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton.icon(
                  onPressed: () {
                    // View detailed progress
                  },
                  icon: const Icon(Icons.trending_up, size: 16),
                  label: const Text('التفاصيل'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Container(
              height: 150,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade200,
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              // In real app, we would use a chart library like fl_chart
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: _monthlyProgress.map((month) {
                  final double barHeight = month['verses'] / 30 * 100;
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        '${month['verses']}',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        width: 30,
                        height: barHeight,
                        decoration: BoxDecoration(
                          color: AppColors.primaryGreen,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        month['month'],
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 24),

            // Memorized surahs
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'السور المحفوظة',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '$totalSurahs سورة',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _memorizedSurahs.length,
              itemBuilder: (context, index) {
                final surah = _memorizedSurahs[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: AppColors.primaryGreen,
                      child: Text(
                        '${index + 1}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    title: Text(
                      surah['arabic_name'],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      'عدد الآيات: ${surah['verses']} • تاريخ الحفظ: ${surah['memorized_date']}',
                      style: const TextStyle(fontSize: 12),
                    ),
                    trailing: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.primaryGreen.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        '${surah['score']}/${surah['max_score']}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryGreen,
                        ),
                      ),
                    ),
                    onTap: () {
                      // Navigate to surah details
                    },
                  ),
                );
              },
            ),
            const SizedBox(height: 24),

            // In progress surahs
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'السور قيد الحفظ',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${_inProgressSurahs.length} سورة',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _inProgressSurahs.length,
              itemBuilder: (context, index) {
                final surah = _inProgressSurahs[index];
                final progress = surah['progress'] / 100.0;
                
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: AppColors.secondaryBlue.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                Icons.bookmark,
                                color: AppColors.secondaryBlue,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    surah['arabic_name'],
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'عدد الآيات: ${surah['verses']} • آخر مراجعة: ${surah['last_revision']}',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              '${surah['progress']}%',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppColors.secondaryBlue,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        LinearProgressIndicator(
                          value: progress,
                          backgroundColor: Colors.grey.shade200,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppColors.secondaryBlue,
                          ),
                          minHeight: 6,
                          borderRadius: const BorderRadius.all(Radius.circular(4)),
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
    );
  }

  Widget _buildSummaryCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: color,
              size: 20,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade700,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}