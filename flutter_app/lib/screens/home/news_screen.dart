import 'package:flutter/material.dart';
import 'package:khalfan_center/models/news_model.dart';
import 'package:khalfan_center/services/firebase_service.dart';
import 'package:khalfan_center/widgets/news_card.dart';
import 'package:url_launcher/url_launcher.dart';

class NewsScreen extends StatefulWidget {
  @override
  _NewsScreenState createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<NewsModel> _news = [];
  List<NewsModel> _events = [];
  List<NewsModel> _announcements = [];
  bool _isLoading = true;
  String _errorMessage = '';
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _fetchNews();
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
  
  Future<void> _fetchNews() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });
    
    try {
      final firebaseService = FirebaseService();
      List<NewsModel> allNews = await firebaseService.getLatestNews(50);
      
      setState(() {
        _news = allNews.where((item) => item.category == 'news').toList();
        _events = allNews.where((item) => item.category == 'event').toList();
        _announcements = allNews.where((item) => item.category == 'announcement').toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'حدث خطأ أثناء تحميل الأخبار: $e';
      });
    }
  }
  
  void _openNewsDetails(NewsModel news) {
    if (news.isExternal && news.externalUrl != null) {
      _launchUrl(news.externalUrl!);
    } else {
      _showNewsDetailsDialog(news);
    }
  }
  
  Future<void> _launchUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('لا يمكن فتح الرابط: $url')),
      );
    }
  }
  
  void _showNewsDetailsDialog(NewsModel news) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Container(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (news.imageUrls.isNotEmpty)
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    news.imageUrls.first,
                    width: double.infinity,
                    height: 180,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: double.infinity,
                      height: 180,
                      color: Colors.grey[300],
                      child: Icon(Icons.image_not_supported, size: 40),
                    ),
                  ),
                ),
              SizedBox(height: 16),
              Text(
                news.title,
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                news.subtitle,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              SizedBox(height: 16),
              Text(
                news.content,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    news.getFormattedDate(),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  Text(
                    'بواسطة: ${news.authorName}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
              SizedBox(height: 16),
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('إغلاق'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildNewsTab(List<NewsModel> items, String emptyMessage) {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    
    if (_errorMessage.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 48, color: Colors.red),
            SizedBox(height: 16),
            Text(_errorMessage),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _fetchNews,
              child: Text('إعادة المحاولة'),
            ),
          ],
        ),
      );
    }
    
    if (items.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.info_outline, size: 48, color: Colors.grey),
            SizedBox(height: 16),
            Text(emptyMessage),
          ],
        ),
      );
    }
    
    return RefreshIndicator(
      onRefresh: _fetchNews,
      child: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: items.length,
        itemBuilder: (context, index) {
          return NewsCard(
            news: items[index],
            onTap: () => _openNewsDetails(items[index]),
          );
        },
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('الأخبار والفعاليات'),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'الأخبار'),
            Tab(text: 'الفعاليات'),
            Tab(text: 'الإعلانات'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildNewsTab(_news, 'لا توجد أخبار حالياً'),
          _buildNewsTab(_events, 'لا توجد فعاليات حالياً'),
          _buildNewsTab(_announcements, 'لا توجد إعلانات حالياً'),
        ],
      ),
    );
  }
}
