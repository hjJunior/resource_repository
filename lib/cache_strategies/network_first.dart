import 'package:resource_repository/cache_strategies/strategy.dart';
import 'package:resource_repository/resource_source/cache/index.dart';
import 'package:resource_repository/resource_source/resource.dart';

class NetworkFirstCacheUpdateStrategy<T extends Resource>
    extends CacheUpdateStrategy<T> {
  final CacheResourceSource<T> cacheSource;

  NetworkFirstCacheUpdateStrategy(this.cacheSource);

  @override
  Future<void> onCreate(T model) async {
    await cacheSource.create(model);
  }

  @override
  Future<void> onDelete(String resourceId, {bool cascate = true}) async {
    await cacheSource.delete(resourceId, cascate: true);
  }

  @override
  Future<void> onGet(T model) async {
    final localRegister = await cacheSource.findOne(model.idKey);

    if (localRegister != null) {
      cacheSource.update(localRegister.idKey, model);
      return;
    }

    await cacheSource.create(model);
  }

  @override
  Future<void> onGetAll(List<T> remoteDataList) async {
    remoteDataList.forEach((model) async {
      await onGet(model);
    });
  }

  @override
  Future<void> onUpdate(String resourceId, T model) async {
    await onGet(model);
  }
}
