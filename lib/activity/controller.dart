import 'package:complemento/services/database_service.dart';

import 'activity.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'controller.g.dart';

@riverpod
class ActivityController extends _$ActivityController {
  @override
  Future<List<Activity>> build() async {
    return FirebaseActivityService().getActivities();
  }

  Future<void> addActivity(Activity activity) async {
    await FirebaseActivityService().saveActivity(activity);
    state = const AsyncLoading();
    state =
        await AsyncValue.guard(() => FirebaseActivityService().getActivities());
  }
}
