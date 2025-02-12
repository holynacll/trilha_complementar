import 'package:complemento/enums.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'activity.freezed.dart';
part 'activity.g.dart';

@freezed
class Activity with _$Activity {
  @JsonSerializable(explicitToJson: true)
  const factory Activity({
    required String title,
    required String description,
    required ActivityGroup group,
    required String address,
    required String url,
    required int hours,
    required DateTime startDate,
    required DateTime endDate,
    required String logoImage,
  }) = _Activity;

  factory Activity.fromJson(Map<String, dynamic> json) =>
      _$ActivityFromJson(json);
}
