import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class EventModel extends Equatable {
  final String id;
  final String title;
  final String description;
  final DateTime date;
  final TimeOfDay startTime;
  final TimeOfDay? endTime;
  final String location;
  final String organizerId;
  final String organizerName;
  final List<String> imageUrls;
  final bool isPublic;
  final List<String> targetAudience; // parent, teacher, student, all
  final bool isRecurring;
  final String? recurringType; // daily, weekly, monthly
  final bool isActive;
  final String category; // academic, social, religious, other
  final String? externalLink;

  const EventModel({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.startTime,
    this.endTime,
    required this.location,
    required this.organizerId,
    required this.organizerName,
    this.imageUrls = const [],
    this.isPublic = true,
    this.targetAudience = const ['all'],
    this.isRecurring = false,
    this.recurringType,
    this.isActive = true,
    this.category = 'academic',
    this.externalLink,
  });

  factory EventModel.fromMap(Map<String, dynamic> map, String id) {
    return EventModel(
      id: id,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      date: (map['date'] as Timestamp?)?.toDate() ?? DateTime.now(),
      startTime: _timeOfDayFromMap(map['startTime']),
      endTime: map['endTime'] != null ? _timeOfDayFromMap(map['endTime']) : null,
      location: map['location'] ?? '',
      organizerId: map['organizerId'] ?? '',
      organizerName: map['organizerName'] ?? '',
      imageUrls: map['imageUrls'] != null 
        ? List<String>.from(map['imageUrls']) 
        : [],
      isPublic: map['isPublic'] ?? true,
      targetAudience: map['targetAudience'] != null 
        ? List<String>.from(map['targetAudience']) 
        : ['all'],
      isRecurring: map['isRecurring'] ?? false,
      recurringType: map['recurringType'],
      isActive: map['isActive'] ?? true,
      category: map['category'] ?? 'academic',
      externalLink: map['externalLink'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'date': Timestamp.fromDate(date),
      'startTime': _timeOfDayToMap(startTime),
      'endTime': endTime != null ? _timeOfDayToMap(endTime!) : null,
      'location': location,
      'organizerId': organizerId,
      'organizerName': organizerName,
      'imageUrls': imageUrls,
      'isPublic': isPublic,
      'targetAudience': targetAudience,
      'isRecurring': isRecurring,
      'recurringType': recurringType,
      'isActive': isActive,
      'category': category,
      'externalLink': externalLink,
    };
  }

  static Map<String, int> _timeOfDayToMap(TimeOfDay timeOfDay) {
    return {
      'hour': timeOfDay.hour,
      'minute': timeOfDay.minute,
    };
  }

  static TimeOfDay _timeOfDayFromMap(Map<String, dynamic> map) {
    return TimeOfDay(
      hour: map['hour'] ?? 0,
      minute: map['minute'] ?? 0,
    );
  }

  EventModel copyWith({
    String? title,
    String? description,
    DateTime? date,
    TimeOfDay? startTime,
    TimeOfDay? endTime,
    String? location,
    String? organizerId,
    String? organizerName,
    List<String>? imageUrls,
    bool? isPublic,
    List<String>? targetAudience,
    bool? isRecurring,
    String? recurringType,
    bool? isActive,
    String? category,
    String? externalLink,
  }) {
    return EventModel(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      date: date ?? this.date,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      location: location ?? this.location,
      organizerId: organizerId ?? this.organizerId,
      organizerName: organizerName ?? this.organizerName,
      imageUrls: imageUrls ?? this.imageUrls,
      isPublic: isPublic ?? this.isPublic,
      targetAudience: targetAudience ?? this.targetAudience,
      isRecurring: isRecurring ?? this.isRecurring,
      recurringType: recurringType ?? this.recurringType,
      isActive: isActive ?? this.isActive,
      category: category ?? this.category,
      externalLink: externalLink ?? this.externalLink,
    );
  }
  
  String getCategoryName() {
    switch (category) {
      case 'academic':
        return 'أكاديمي';
      case 'social':
        return 'اجتماعي';
      case 'religious':
        return 'ديني';
      case 'other':
        return 'آخر';
      default:
        return 'أكاديمي';
    }
  }
  
  String getFormattedTime() {
    String start = '${startTime.hour.toString().padLeft(2, '0')}:${startTime.minute.toString().padLeft(2, '0')}';
    
    if (endTime != null) {
      String end = '${endTime!.hour.toString().padLeft(2, '0')}:${endTime!.minute.toString().padLeft(2, '0')}';
      return '$start - $end';
    }
    
    return start;
  }
  
  String getFormattedDate() {
    return '${date.day}/${date.month}/${date.year}';
  }
  
  bool isUpcoming() {
    final now = DateTime.now();
    final eventDateTime = DateTime(
      date.year, 
      date.month, 
      date.day, 
      startTime.hour, 
      startTime.minute
    );
    
    return eventDateTime.isAfter(now);
  }

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    date,
    startTime,
    endTime,
    location,
    organizerId,
    organizerName,
    imageUrls,
    isPublic,
    targetAudience,
    isRecurring,
    recurringType,
    isActive,
    category,
    externalLink,
  ];
}

class TimeOfDay {
  final int hour;
  final int minute;

  const TimeOfDay({required this.hour, required this.minute});
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TimeOfDay && 
      other.hour == hour && 
      other.minute == minute;
  }
  
  @override
  int get hashCode => hour.hashCode ^ minute.hashCode;
}
