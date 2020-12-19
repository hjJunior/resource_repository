import 'package:resource_repository/repository_strategies/strategy.dart';
import 'package:resource_repository/resource_source/remote/index.dart';
import 'package:resource_repository/resource_source/resource.dart';

class RemoteOnlyRepositoryStrategy<T extends Resource>
    implements RepositoryStrategy<T> {
  final RemoteResourceSource remoteSource;

  RemoteOnlyRepositoryStrategy({this.remoteSource});

  Future<List<T>> getAll() async {
    return await remoteSource.findAll();
  }

  Future<T> get(String resourceId) async {
    return await remoteSource.findOne(resourceId);
  }

  Future create(T model) async {
    await remoteSource.create(model);
  }

  Future update(String resourceId, T model) async {
    await remoteSource.update(resourceId, model);
  }

  Future delete(String resourceId, {bool cascate = true}) async {
    await remoteSource.delete(resourceId);
  }
}
