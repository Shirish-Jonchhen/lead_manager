import 'package:hive/hive.dart';

part 'lead_model.g.dart';

@HiveType(typeId: 0)
class Lead extends HiveObject {
  @HiveField(0)
  late String name;

  @HiveField(1)
  late String email;

  @HiveField(2)
  late String phone;

  @HiveField(3)
  late dynamic service;

  @HiveField(4)
  late DateTime createdAt;

  Lead({
    required this.name,
    required this.email,
    required this.phone,
    required this.service,
    required this.createdAt,
  });

  String get serviceDisplayName {
    if (service is List) {
      return (service as List).join(', ');
    }
    return service?.toString() ?? '';
  }
}
