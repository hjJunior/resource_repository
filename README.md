# Resource Repository
![CI](https://github.com/hjJunior/resource_repository/workflows/CI/badge.svg)
[![codecov](https://codecov.io/gh/hjJunior/resource_repository/branch/master/graph/badge.svg?token=S7B7XVRPOP)](https://codecov.io/gh/hjJunior/resource_repository)

## Usage
```dart
class UserResource implements Resource {
  @override
  String get externalIdKey => '2';

  @override
  String get idKey => '1';
}

class UserRepository extends Repository<UserResource> {}

class UserApiResourceSource extends RemoteResourceSource<UserResource> { 
  // ...
}

class UserCacheResourceSource extends HiveResourceSource<UserResource> {
  @override
  String get boxName => 'users';
}
```
