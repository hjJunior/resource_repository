import 'package:resource_repository/cache_strategies/strategy.dart';
import 'package:resource_repository/resource_source/cache/index.dart';
import 'package:resource_repository/resource_source/resource.dart';

class IncrementalCacheUpdateStrategy<T extends Resource>
    extends CacheUpdateStrategy<T> {
  final CacheResourceSource<T> cacheSource;

  IncrementalCacheUpdateStrategy(this.cacheSource);

  bool _cachedInitialized = false;

  @override
  Future<void> onCreate(T model) async {
    await _initCacheIfRequired();
    final localRegister =
        await cacheSource.findOneByExternalId(model.externalId);

    if (localRegister != null) {
      cacheSource.update(localRegister.id, model);
      return;
    }

    await cacheSource.create(model);
  }

  @override
  Future<void> onDelete(String externalId, {bool cascate = true}) async {
    await _initCacheIfRequired();
    final localRegister = await cacheSource.findOneByExternalId(externalId);

    if (localRegister != null) {
      await cacheSource.delete(localRegister.id, cascate: true);
    }
  }

  @override
  Future<void> onGet(T model) async {
    await _initCacheIfRequired();

    final localRegister =
        await cacheSource.findOneByExternalId(model.externalId);

    if (localRegister != null) {
      cacheSource.update(localRegister.id, model);
      return;
    }

    await cacheSource.create(model);
  }

  @override
  Future<void> onGetAll(List<T> remoteDataList) async {
    await _initCacheIfRequired();

    for (final model in remoteDataList) {
      await onGet(model);
    }
  }

  @override
  Future<void> onUpdate(String externalId, T model) async {
    await _initCacheIfRequired();

    await onGet(model);
  }

  Future<void> _initCacheIfRequired() async {
    if (!_cachedInitialized) {
      await cacheSource.initialize();
      _cachedInitialized = true;
    }
  }
}
