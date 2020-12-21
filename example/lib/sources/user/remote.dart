import 'package:faker/faker.dart';
import 'package:resource_repository/resource_source/remote/index.dart';

import '../../resource/user.dart';

class UserRemoteResourceSource extends RemoteResourceSource<UserResource> {
  @override
  Future<UserResource> create(UserResource model) async {
    model.externalId = Faker().address.buildingNumber();

    return model;
  }

  @override
  Future<void> delete(String key, {bool cascate = true}) {}

  @override
  Future<List<UserResource>> findAll() async {
    return [
      UserResource(
        externalId: Faker().address.buildingNumber(),
        name: Faker().person.name(),
      ),
      UserResource(
        externalId: Faker().address.buildingNumber(),
        name: Faker().person.name(),
      ),
    ];
  }

  @override
  Future<UserResource> findOne(String key) async {
    return UserResource(
      externalId: Faker().address.buildingNumber(),
      name: Faker().person.name(),
    );
  }

  @override
  Future<UserResource> update(String key, UserResource model) async {
    model.externalId = key;

    return model;
  }
}
