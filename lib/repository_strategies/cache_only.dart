import 'package:resource_repository/resource_source/cache/index.dart';
import 'package:resource_repository/resource_source/resource.dart';

import 'strategy.dart';

class CacheOnlyRepositoryStrategy<T extends Resource>
    implements RepositoryStrategy<T> {
  final CacheResourceSource<T> cacheSource;

  bool _cachedInitialized = false;

  CacheOnlyRepositoryStrategy({this.cacheSource});

  Future<List<T>> getAll() async {
    await _initCacheIfRequired();

    return await cacheSource.findAll();
  }

  Future<T> get(String resourceId) async {
    await _initCacheIfRequired();

    return await cacheSource.findOne(resourceId);
  }

  Future create(T model) async {
    await _initCacheIfRequired();

    await cacheSource.create(model);
  }

  Future update(String resourceId, T model) async {
    await _initCacheIfRequired();

    await cacheSource.update(resourceId, model);
  }

  Future delete(String resourceId, {bool cascate = true}) async {
    await _initCacheIfRequired();

    await cacheSource.delete(resourceId);
  }

  Future<void> _initCacheIfRequired() async {
    if (!_cachedInitialized) {
      await cacheSource.initialize();
    }
  }
}
