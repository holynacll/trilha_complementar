import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:complemento/activity/activity.dart';

class FirebaseActivityService {
  final CollectionReference _activitiesCollection =
      FirebaseFirestore.instance.collection('activities');

  /// Salva a atividade no Firebase
  Future<void> saveActivity(Activity activity) async {
    await _activitiesCollection.add(activity.toJson());
  }

  /// Recupera todas as atividades do Firebase
  Future<List<Activity>> getActivities() async {
    final querySnapshot = await _activitiesCollection.get();
    return querySnapshot.docs
        .map((doc) => Activity.fromJson(doc.data() as Map<String, dynamic>))
        .toList();
  }
}
