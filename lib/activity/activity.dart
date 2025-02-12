import 'package:freezed_annotation/freezed_annotation.dart';

part 'activity.freezed.dart';
part 'activity.g.dart';

@freezed
class Activity with _$Activity {
  @JsonSerializable(explicitToJson: true)
  const factory Activity({
    required String title,
    required String owner,
    required String group,
    required String modalidade,
    required int hours,
    required DateTime startDate,
    required DateTime endDate,
    required String logoImage,
  }) = _Activity;

  factory Activity.fromJson(Map<String, dynamic> json) =>
      _$ActivityFromJson(json);
}
