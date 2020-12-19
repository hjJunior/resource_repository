import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:resource_repository/repository_strategies/cache_first.dart';
import 'package:resource_repository/resource_source/cache/index.dart';
import 'package:resource_repository/resource_source/remote/index.dart';
import 'package:resource_repository/resource_source/resource.dart';

class MockCacheResourceSource extends Mock implements CacheResourceSource {}

class MockRemoteResourceSource extends Mock implements RemoteResourceSource {}

class MockResource extends Mock implements Resource {}

void main() {
  MockResource model;
  MockCacheResourceSource cacheSource;
  MockRemoteResourceSource remoteSource;
  CacheFirstRepositoryStrategy subject;

  setUp(() {
    model = MockResource();
    cacheSource = MockCacheResourceSource();
    remoteSource = MockRemoteResourceSource();
    subject = CacheFirstRepositoryStrategy(
      cacheSource: cacheSource,
      remoteSource: remoteSource,
    );
  });

  tearDown(() {
    verify(cacheSource.initialize()).called(1);
  });

  group('.getAll', () {
    test('when contains data on cache', () async {
      when(cacheSource.findAll()).thenAnswer((_) => Future.value([model]));

      final result = await subject.getAll();

      expect(result, [model]);
      verify(cacheSource.findAll()).called(1);
      verifyZeroInteractions(remoteSource);
    });

    test('when does not contain data on cache', () async {
      when(cacheSource.findAll()).thenAnswer((_) => Future.error('error'));
      when(remoteSource.findAll()).thenAnswer((_) => Future.value([model]));

      final result = await subject.getAll();

      expect(result, [model]);
      verify(cacheSource.findAll()).called(1);
      verify(remoteSource.findAll()).called(1);
    });
  });

  group('.get', () {
    test('when contains data on cache', () async {
      when(cacheSource.findOne('id')).thenAnswer((_) => Future.value(model));

      final result = await subject.get('id');

      expect(result, model);
      verify(cacheSource.findOne('id')).called(1);
      verifyZeroInteractions(remoteSource);
    });

    test('when does not contain data on cache', () async {
      when(cacheSource.findOne('id')).thenAnswer((_) => Future.error('error'));
      when(remoteSource.findOne('id')).thenAnswer((_) => Future.value(model));

      final result = await subject.get('id');

      expect(result, model);
      verify(cacheSource.findOne('id')).called(1);
      verify(remoteSource.findOne('id')).called(1);
    });
  });

  test('.create', () async {
    await subject.create(model);

    verifyInOrder([
      cacheSource.create(model),
      remoteSource.create(model),
    ]);
  });

  test('.update', () async {
    await subject.update("fake-id", model);

    verifyInOrder([
      cacheSource.update("fake-id", model),
      remoteSource.update("fake-id", model),
    ]);
  });

  test('.delete', () async {
    await subject.delete("fake-id", cascate: true);

    verifyInOrder([
      cacheSource.delete("fake-id", cascate: true),
      remoteSource.delete("fake-id", cascate: true),
    ]);
  });
}
