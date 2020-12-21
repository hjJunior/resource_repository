import 'package:hive/hive.dart';
import 'package:resource_repository/resource_source/resource.dart';

part 'user.g.dart';

@HiveType(typeId: 0)
class UserResource implements Resource {
  @HiveField(0)
  String id;

  @HiveField(1)
  String externalId;

  @HiveField(2)
  String name;

  UserResource({
    this.id,
    this.externalId,
    this.name,
  });

  @override
  String toString() {
    return 'id: $id - externalId: $externalId';
  }
}
