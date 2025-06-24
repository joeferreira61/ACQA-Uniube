import 'package:cloud_firestore/cloud_firestore.dart';

class Task {
  final String? id;
  final String title;
  final bool isCompleted;
  final DateTime date;

  Task({
    this.id,
    required this.title,
    this.isCompleted = false,
    required this.date,
  });

  // Converte um objeto Task em um Map para o Firestore
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'isCompleted': isCompleted,
      'date': Timestamp.fromDate(date),
    };
  }

  // Cria um objeto Task a partir de um DocumentSnapshot do Firestore
  factory Task.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return Task(
      id: doc.id,
      title: data['title'] ?? '',
      isCompleted: data['isCompleted'] ?? false,
      date: (data['date'] as Timestamp).toDate(),
    );
  }
} 