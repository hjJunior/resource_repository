import 'package:resource_repository/resource_source/resource.dart';

abstract class CacheUpdateStrategy<T extends Resource> {
  Future<void> onGetAll(List<T> remoteData);
  Future<void> onGet(T resourceId);
  Future<void> onCreate(T model);
  Future<void> onUpdate(String resourceId, T newData);
  Future<void> onDelete(String resourceId, {bool cascate = true});
}
