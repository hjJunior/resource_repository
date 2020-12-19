# Resource Repository

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