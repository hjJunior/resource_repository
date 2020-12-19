import 'package:resource_repository/repository_strategies/strategy.dart';
import 'package:resource_repository/resource_source/cache/index.dart';
import 'package:resource_repository/resource_source/remote/index.dart';
import 'package:resource_repository/resource_source/resource.dart';

class CacheFirstRepositoryStrategy<T extends Resource>
    implements RepositoryStrategy<T> {
  final RemoteResourceSource<T> remoteSource;
  final CacheResourceSource<T> cacheSource;

  bool _cachedInitialized = false;

  CacheFirstRepositoryStrategy({this.cacheSource, this.remoteSource});

  Future<List<T>> getAll() async {
    await _initCacheIfRequired();

    List<T> data;

    try {
      data = await cacheSource.findAll();
    } catch (e) {
      data = await remoteSource.findAll();
    }

    return data;
  }

  Future<T> get(String resourceId) async {
    await _initCacheIfRequired();

    T data;

    try {
      data = await cacheSource.findOne(resourceId);
    } catch (e) {
      data = await remoteSource.findOne(resourceId);
    }

    return data;
  }

  Future create(T model) async {
    await _initCacheIfRequired();

    await cacheSource.create(model);
    await remoteSource.create(model);
  }

  Future update(String resourceId, T model) async {
    await _initCacheIfRequired();

    await cacheSource.update(resourceId, model);
    await remoteSource.update(resourceId, model);
  }

  Future delete(String resourceId, {bool cascate = true}) async {
    await _initCacheIfRequired();

    await cacheSource.delete(resourceId, cascate: cascate);
    await remoteSource.delete(resourceId, cascate: cascate);
  }

  Future<void> _initCacheIfRequired() async {
    if (!_cachedInitialized) {
      await cacheSource.initialize();
    }
  }
}
