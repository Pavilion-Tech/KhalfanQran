import 'package:flutter/material.dart';
import 'package:khalfan_center/config/themes.dart';

class CertificatesScreen extends StatefulWidget {
  const CertificatesScreen({Key? key}) : super(key: key);

  @override
  State<CertificatesScreen> createState() => _CertificatesScreenState();
}

class _CertificatesScreenState extends State<CertificatesScreen> {
  final List<Map<String, dynamic>> _certificates = [
    {
      'id': '1',
      'title': 'شهادة حفظ جزء عم',
      'date': '15/03/2025',
      'type': 'حفظ',
      'description': 'شهادة حفظ الجزء الثلاثين من القرآن الكريم',
      'image_url': '',
    },
    {
      'id': '2',
      'title': 'شهادة تفوق في التلاوة',
      'date': '01/04/2025',
      'type': 'تلاوة',
      'description': 'شهادة تميز في مخارج الحروف وأحكام التلاوة',
      'image_url': '',
    },
    {
      'id': '3',
      'title': 'شهادة تميز في المسابقة القرآنية',
      'date': '20/04/2025',
      'type': 'مسابقة',
      'description': 'المركز الثاني في مسابقة حفظ القرآن الكريم',
      'image_url': '',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _certificates.isEmpty
          ? _buildEmptyState()
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  const Text(
                    'الشهادات والإنجازات',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'إجمالي الشهادات: ${_certificates.length}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Certificate list
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _certificates.length,
                    itemBuilder: (context, index) {
                      final certificate = _certificates[index];
                      return _buildCertificateCard(certificate);
                    },
                  ),
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Request new certificate
          _showRequestDialog(context);
        },
        backgroundColor: AppColors.primaryGreen,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.card_membership,
            size: 80,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          const Text(
            'لا توجد شهادات',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'ستظهر الشهادات هنا عند الحصول عليها',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              // Request new certificate
              _showRequestDialog(context);
            },
            icon: const Icon(Icons.add),
            label: const Text('طلب شهادة'),
          ),
        ],
      ),
    );
  }

  Widget _buildCertificateCard(Map<String, dynamic> certificate) {
    Color typeColor;
    IconData typeIcon;

    switch (certificate['type']) {
      case 'حفظ':
        typeColor = AppColors.primaryGreen;
        typeIcon = Icons.menu_book;
        break;
      case 'تلاوة':
        typeColor = AppColors.secondaryBlue;
        typeIcon = Icons.record_voice_over;
        break;
      case 'مسابقة':
        typeColor = AppColors.goldAccent;
        typeIcon = Icons.emoji_events;
        break;
      default:
        typeColor = Colors.grey;
        typeIcon = Icons.description;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        children: [
          // Certificate header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: typeColor.withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: typeColor,
                  child: Icon(
                    typeIcon,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        certificate['title'],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'تاريخ الإصدار: ${certificate['date']}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    certificate['type'],
                    style: TextStyle(
                      fontSize: 12,
                      color: typeColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Certificate content
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Certificate placeholder image
                Container(
                  height: 160,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Colors.grey.shade300,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.image,
                        size: 40,
                        color: Colors.grey.shade400,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'صورة الشهادة',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                
                // Description
                const Text(
                  'تفاصيل الشهادة:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  certificate['description'],
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade700,
                  ),
                ),
                const SizedBox(height: 16),
                
                // Action buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    OutlinedButton.icon(
                      onPressed: () {
                        // Share certificate
                      },
                      icon: const Icon(Icons.share, size: 16),
                      label: const Text('مشاركة'),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton.icon(
                      onPressed: () {
                        // Download certificate
                      },
                      icon: const Icon(Icons.download, size: 16),
                      label: const Text('تحميل'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: typeColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showRequestDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('طلب شهادة جديدة'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'يرجى اختيار نوع الشهادة المطلوبة:',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: CircleAvatar(
                backgroundColor: AppColors.primaryGreen.withOpacity(0.1),
                child: Icon(
                  Icons.menu_book,
                  color: AppColors.primaryGreen,
                ),
              ),
              title: const Text('شهادة حفظ'),
              subtitle: const Text('شهادة إتمام حفظ جزء أو سورة من القرآن'),
              onTap: () {
                Navigator.pop(context);
                // Logic to request certificate
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('تم إرسال طلب شهادة الحفظ بنجاح'),
                  ),
                );
              },
            ),
            const Divider(),
            ListTile(
              leading: CircleAvatar(
                backgroundColor: AppColors.secondaryBlue.withOpacity(0.1),
                child: Icon(
                  Icons.record_voice_over,
                  color: AppColors.secondaryBlue,
                ),
              ),
              title: const Text('شهادة تلاوة'),
              subtitle: const Text('شهادة إتقان أحكام التلاوة والتجويد'),
              onTap: () {
                Navigator.pop(context);
                // Logic to request certificate
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('تم إرسال طلب شهادة التلاوة بنجاح'),
                  ),
                );
              },
            ),
            const Divider(),
            ListTile(
              leading: CircleAvatar(
                backgroundColor: AppColors.goldAccent.withOpacity(0.1),
                child: Icon(
                  Icons.emoji_events,
                  color: AppColors.goldAccent,
                ),
              ),
              title: const Text('شهادة مشاركة'),
              subtitle: const Text('شهادة مشاركة في مسابقة أو نشاط للمركز'),
              onTap: () {
                Navigator.pop(context);
                // Logic to request certificate
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('تم إرسال طلب شهادة المشاركة بنجاح'),
                  ),
                );
              },
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
        ],
      ),
    );
  }
}