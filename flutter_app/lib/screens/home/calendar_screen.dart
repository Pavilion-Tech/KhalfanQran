import 'package:flutter/material.dart';
import 'package:khalfan_center/config/themes.dart';
import 'package:khalfan_center/models/event_model.dart';
import 'package:khalfan_center/services/firebase_service.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

class CalendarScreen extends StatefulWidget {
  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  Map<DateTime, List<EventModel>> _events = {};
  List<EventModel> _selectedEvents = [];
  bool _isLoading = true;
  String _errorMessage = '';
  
  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _fetchEvents();
  }
  
  Future<void> _fetchEvents() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });
    
    try {
      final firebaseService = FirebaseService();
      
      // Get events for the current and next 3 months
      DateTime startDate = DateTime(_focusedDay.year, _focusedDay.month, 1);
      DateTime endDate = DateTime(_focusedDay.year, _focusedDay.month + 3, 0);
      
      List<EventModel> events = await firebaseService.getUpcomingEvents(startDate, limit: 100);
      
      // Convert to map of events by date
      Map<DateTime, List<EventModel>> eventMap = {};
      
      for (EventModel event in events) {
        DateTime date = DateTime(
          event.date.year,
          event.date.month,
          event.date.day,
        );
        
        if (eventMap[date] == null) {
          eventMap[date] = [];
        }
        
        eventMap[date]!.add(event);
      }
      
      setState(() {
        _events = eventMap;
        _isLoading = false;
        
        // Update selected events if a day is selected
        if (_selectedDay != null) {
          _updateSelectedEvents();
        }
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'حدث خطأ أثناء تحميل الأحداث: $e';
      });
    }
  }
  
  void _updateSelectedEvents() {
    if (_selectedDay != null) {
      DateTime selectedDate = DateTime(
        _selectedDay!.year,
        _selectedDay!.month,
        _selectedDay!.day,
      );
      
      setState(() {
        _selectedEvents = _events[selectedDate] ?? [];
      });
    }
  }
  
  List<EventModel> _getEventsForDay(DateTime day) {
    DateTime date = DateTime(day.year, day.month, day.day);
    return _events[date] ?? [];
  }
  
  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
      });
      
      _updateSelectedEvents();
    }
  }
  
  void _showEventDetailsDialog(EventModel event) {
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
              if (event.imageUrls.isNotEmpty)
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    event.imageUrls.first,
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
                event.title,
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.access_time, size: 16, color: AppColors.textSecondary),
                  SizedBox(width: 4),
                  Text(
                    event.getFormattedTime(),
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
              SizedBox(height: 4),
              Row(
                children: [
                  Icon(Icons.location_on, size: 16, color: AppColors.textSecondary),
                  SizedBox(width: 4),
                  Text(
                    event.location,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
              SizedBox(height: 16),
              Text(
                event.description,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              SizedBox(height: 16),
              Text(
                'منظم الفعالية: ${event.organizerName}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              SizedBox(height: 16),
              if (event.externalLink != null)
                ElevatedButton.icon(
                  icon: Icon(Icons.link),
                  label: Text('فتح الرابط'),
                  onPressed: () async {
                    Navigator.pop(context);
                    if (await canLaunch(event.externalLink!)) {
                      await launch(event.externalLink!);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('لا يمكن فتح الرابط')),
                      );
                    }
                  },
                ),
              SizedBox(height: 8),
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
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('التقويم الدراسي'),
        centerTitle: true,
      ),
      body: _isLoading ? 
        Center(child: CircularProgressIndicator()) :
        (_errorMessage.isNotEmpty ? 
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 48, color: Colors.red),
                SizedBox(height: 16),
                Text(_errorMessage),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _fetchEvents,
                  child: Text('إعادة المحاولة'),
                ),
              ],
            ),
          ) :
          Column(
            children: [
              TableCalendar(
                firstDay: DateTime.utc(2020, 1, 1),
                lastDay: DateTime.utc(2030, 12, 31),
                focusedDay: _focusedDay,
                calendarFormat: _calendarFormat,
                selectedDayPredicate: (day) {
                  return isSameDay(_selectedDay, day);
                },
                eventLoader: _getEventsForDay,
                startingDayOfWeek: StartingDayOfWeek.saturday,
                calendarStyle: CalendarStyle(
                  markerDecoration: BoxDecoration(
                    color: AppColors.primaryGreen,
                    shape: BoxShape.circle,
                  ),
                  todayDecoration: BoxDecoration(
                    color: AppColors.primaryGreen.withOpacity(0.5),
                    shape: BoxShape.circle,
                  ),
                  selectedDecoration: BoxDecoration(
                    color: AppColors.primaryGreen,
                    shape: BoxShape.circle,
                  ),
                ),
                headerStyle: HeaderStyle(
                  formatButtonVisible: true,
                  titleCentered: true,
                  formatButtonShowsNext: false,
                ),
                onDaySelected: _onDaySelected,
                onFormatChanged: (format) {
                  if (_calendarFormat != format) {
                    setState(() {
                      _calendarFormat = format;
                    });
                  }
                },
                onPageChanged: (focusedDay) {
                  _focusedDay = focusedDay;
                  
                  // If month changed, fetch new events
                  if (focusedDay.month != _selectedDay?.month) {
                    _fetchEvents();
                  }
                },
              ),
              const SizedBox(height: 8.0),
              Expanded(
                child: _selectedEvents.isEmpty
                    ? Center(
                        child: Text('لا توجد أحداث في هذا اليوم'),
                      )
                    : ListView.builder(
                        padding: EdgeInsets.all(16),
                        itemCount: _selectedEvents.length,
                        itemBuilder: (context, index) {
                          final event = _selectedEvents[index];
                          return Card(
                            margin: EdgeInsets.only(bottom: 12),
                            child: ListTile(
                              contentPadding: EdgeInsets.all(16),
                              title: Text(
                                event.title,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Icon(Icons.access_time, size: 16, color: AppColors.textSecondary),
                                      SizedBox(width: 4),
                                      Text(event.getFormattedTime()),
                                    ],
                                  ),
                                  SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Icon(Icons.location_on, size: 16, color: AppColors.textSecondary),
                                      SizedBox(width: 4),
                                      Text(event.location),
                                    ],
                                  ),
                                ],
                              ),
                              trailing: Container(
                                width: 8,
                                height: double.infinity,
                                decoration: BoxDecoration(
                                  color: _getCategoryColor(event.category),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                              onTap: () => _showEventDetailsDialog(event),
                            ),
                          );
                        },
                      ),
              ),
            ],
          )
      ),
    );
  }
  
  Color _getCategoryColor(String category) {
    switch (category) {
      case 'academic':
        return AppColors.primaryGreen;
      case 'social':
        return AppColors.secondaryBlue;
      case 'religious':
        return AppColors.goldAccent;
      default:
        return Colors.grey;
    }
  }
}
