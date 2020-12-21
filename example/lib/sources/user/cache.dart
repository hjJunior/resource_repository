import 'package:resource_repository/resource_source/cache/index.dart';

import '../../resource/user.dart';

class UserCacheResourceSource extends HiveResourceSource<UserResource> {
  @override
  String get boxName => 'users';
}
