import 'package:flutter/foundation.dart';
import 'package:resource_repository/repository_strategies/strategy.dart';
import 'package:resource_repository/resource_source/resource.dart';

class Repository<T extends Resource> {
  Future<List<T>> getAll({
    @required RepositoryStrategy<T> strategy,
  }) async {
    return strategy.getAll();
  }

  Future<T> get(
    String resourceId, {
    @required RepositoryStrategy<T> strategy,
  }) {
    return strategy.get(resourceId);
  }

  Future<void> create(
    T model, {
    @required RepositoryStrategy<T> strategy,
  }) async {
    await strategy.create(model);
  }

  Future<void> update(
    String resourceId,
    T model, {
    @required RepositoryStrategy<T> strategy,
  }) async {
    await strategy.update(resourceId, model);
  }

  Future<void> delete(
    String resourceId, {
    bool cascate = true,
    @required RepositoryStrategy<T> strategy,
  }) async {
    await strategy.delete(resourceId, cascate: cascate);
  }
}
