import 'package:resource_repository/resource_source/resource.dart';

import '../resource_source.dart';

export 'hive_data_source.dart';

abstract class CacheResourceSource<T extends Resource>
    implements ResourceSource<T> {
  Future<void> initialize();
}
