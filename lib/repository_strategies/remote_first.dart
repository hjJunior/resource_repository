import 'package:resource_repository/cache_strategies/strategy.dart';
import 'package:resource_repository/repository_strategies/strategy.dart';
import 'package:resource_repository/resource_source/cache/index.dart';
import 'package:resource_repository/resource_source/remote/index.dart';
import 'package:resource_repository/resource_source/resource.dart';

class RemoteFirstRepositoryStrategy<T extends Resource>
    implements RepositoryStrategy<T> {
  final RemoteResourceSource<T> remoteSource;
  final CacheResourceSource<T> cacheSource;
  final CacheUpdateStrategy<T> cacheUpdate;

  bool _cachedInitialized = false;

  RemoteFirstRepositoryStrategy({
    this.cacheSource,
    this.remoteSource,
    this.cacheUpdate,
  });

  Future<List<T>> getAll() async {
    await _initCacheIfRequired();
    List<T> data;

    try {
      data = await remoteSource.findAll();
      await cacheUpdate.onGetAll(data);
    } catch (e) {
      data = await cacheSource.findAll();
    }

    return data;
  }

  Future<T> get(String resourceId) async {
    await _initCacheIfRequired();
    T data;

    try {
      data = await remoteSource.findOne(resourceId);
      await cacheUpdate.onGet(data);
    } catch (e) {
      data = await cacheSource.findOne(resourceId);
    }

    return data;
  }

  Future create(T model) async {
    await _initCacheIfRequired();

    final remoteModel = await remoteSource.create(model);
    await cacheUpdate.onCreate(remoteModel);
  }

  Future update(String resourceId, T model) async {
    await _initCacheIfRequired();

    final remoteModel = await remoteSource.update(resourceId, model);
    await cacheUpdate.onUpdate(resourceId, remoteModel);
  }

  Future delete(String resourceId, {bool cascate = true}) async {
    await _initCacheIfRequired();

    await remoteSource.delete(resourceId, cascate: cascate);
    await cacheUpdate.onDelete(resourceId, cascate: cascate);
  }

  Future<void> _initCacheIfRequired() async {
    if (!_cachedInitialized) {
      await cacheSource.initialize();
    }
  }
}
