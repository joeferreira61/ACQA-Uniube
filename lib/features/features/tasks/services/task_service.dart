import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:task_manager/features/features/tasks/model/task_model.dart';

class TaskService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Pega a coleção de tarefas do usuário logado
  CollectionReference<Task> _getTasksCollection() {
    final User? user = _auth.currentUser;
    if (user == null) {
      throw Exception("Usuário não está logado.");
    }

    return _firestore.collection('users').doc(user.uid).collection('tasks').withConverter<Task>(
          fromFirestore: (snapshot, _) => Task.fromFirestore(snapshot),
          toFirestore: (task, _) => task.toMap(),
        );
  }

  // Adicionar uma nova tarefa
  Future<void> addTask(Task task) async {
    await _getTasksCollection().add(task);
  }

  // Buscar tarefas para uma data específica
  Stream<List<Task>> getTasksForDate(DateTime date) {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    return _getTasksCollection()
        .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
        .where('date', isLessThan: Timestamp.fromDate(endOfDay))
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  }

  // Atualizar uma tarefa (ex: marcar como concluída)
  Future<void> updateTask(String taskId, {required bool isCompleted}) async {
    await _getTasksCollection().doc(taskId).update({'isCompleted': isCompleted});
  }

  // Deletar uma tarefa
  Future<void> deleteTask(String taskId) async {
    await _getTasksCollection().doc(taskId).delete();
  }
} 