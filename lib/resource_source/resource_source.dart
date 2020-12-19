import 'dart:async';

abstract class ResourceSource<T> {
  Future<List<T>> findAll();
  Future<T> findOne(String key);
  Future<T> create(T model);
  Future<T> update(String key, T model);
  Future<void> delete(String key, {bool cascate = true});
}
