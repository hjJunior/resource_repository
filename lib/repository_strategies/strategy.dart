import 'package:resource_repository/resource_source/resource.dart';

abstract class RepositoryStrategy<T extends Resource> {
  Future<List<T>> getAll();
  Future<T> get(String resourceId);
  Future create(T model);
  Future update(String resourceId, T model);
  Future delete(String resourceId, {bool cascate = true});
}
