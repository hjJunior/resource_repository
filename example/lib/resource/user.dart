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

  @override
  Resource copy(Resource obj) {
    if (obj is UserResource) {
      return UserResource(
        id: obj.id,
        externalId: obj.externalId,
        name: obj.name,
      );
    }

    return this;
  }

  @override
  Resource shallowCopy(Resource obj) {
    if (obj is UserResource) {
      return UserResource(
        id: obj.id,
        externalId: obj.externalId,
        name: name,
      );
    }

    return this;
  }
}
