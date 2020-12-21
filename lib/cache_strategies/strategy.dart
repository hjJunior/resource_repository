import 'package:resource_repository/resource_source/resource.dart';

abstract class CacheUpdateStrategy<T extends Resource> {
  Future<void> onGetAll(List<T> remoteData);
  Future<void> onGet(T externalId);
  Future<void> onCreate(T model);
  Future<void> onUpdate(String externalId, T newData);
  Future<void> onDelete(String externalId, {bool cascate = true});
}
