import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:resource_repository/cache_strategies/strategy.dart';
import 'package:resource_repository/repository_strategies/remote_first.dart';
import 'package:resource_repository/resource_source/cache/index.dart';
import 'package:resource_repository/resource_source/remote/index.dart';
import 'package:resource_repository/resource_source/resource.dart';

class MockCacheResourceSource extends Mock implements CacheResourceSource {}

class MockRemoteResourceSource extends Mock implements RemoteResourceSource {}

class MockCacheUpdateStrategy extends Mock implements CacheUpdateStrategy {}

class MockResource extends Mock implements Resource {}

void main() {
  MockResource model;
  MockResource model2;
  MockCacheResourceSource cacheSource;
  MockRemoteResourceSource remoteSource;
  MockCacheUpdateStrategy cacheUpdate;

  RemoteFirstCacheUpdateStrategy subject;

  setUp(() {
    model = MockResource();
    model2 = MockResource();
    cacheSource = MockCacheResourceSource();
    cacheUpdate = MockCacheUpdateStrategy();
    remoteSource = MockRemoteResourceSource();
    subject = RemoteFirstCacheUpdateStrategy(
      cacheSource: cacheSource,
      remoteSource: remoteSource,
      cacheUpdate: cacheUpdate,
    );
  });

  tearDown(() {
    verify(cacheSource.initialize()).called(1);
  });

  group('.getAll', () {
    test('when fetch successfully from remote', () async {
      when(remoteSource.findAll()).thenAnswer((_) => Future.value([model]));

      final result = await subject.getAll();

      expect(result, [model]);
      verify(remoteSource.findAll()).called(1);
      verify(cacheUpdate.onGetAll([model])).called(1);
    });

    test('when fail to fetch from remote', () async {
      when(remoteSource.findAll()).thenAnswer((_) => Future.error('error'));
      when(cacheSource.findAll()).thenAnswer((_) => Future.value([model]));

      final result = await subject.getAll();

      expect(result, [model]);
      verify(remoteSource.findAll()).called(1);
      verify(cacheSource.findAll()).called(1);
      verifyNever(cacheUpdate.onGetAll(any));
    });
  });

  group('.get', () {
    test('when fetch successfully from remote', () async {
      when(remoteSource.findOne('fake-id'))
          .thenAnswer((_) => Future.value(model));

      final result = await subject.get('fake-id');

      expect(result, model);
      verify(remoteSource.findOne('fake-id')).called(1);
      verify(cacheUpdate.onGet(model)).called(1);
    });

    test('when fail to fetch from remote', () async {
      when(remoteSource.findOne('fake-id'))
          .thenAnswer((_) => Future.error('error'));

      when(cacheSource.findOne('fake-id'))
          .thenAnswer((_) => Future.value(model));

      final result = await subject.get('fake-id');

      expect(result, model);
      verify(remoteSource.findOne(any)).called(1);
      verify(cacheSource.findOne(any)).called(1);
      verifyNever(cacheUpdate.onGet(any));
    });
  });

  test('.create', () async {
    when(remoteSource.create(model)).thenAnswer((_) => Future.value(model2));

    await subject.create(model);

    verifyInOrder([
      remoteSource.create(model),
      cacheUpdate.onCreate(model2),
    ]);
  });

  test('.update', () async {
    when(remoteSource.update('fake-id', model))
        .thenAnswer((_) => Future.value(model2));

    await subject.update('fake-id', model);

    verifyInOrder([
      remoteSource.update('fake-id', model),
      cacheUpdate.onUpdate('fake-id', model2),
    ]);
  });

  test('.delete', () async {
    when(remoteSource.delete('fake-id', cascate: true))
        .thenAnswer((_) => Future.value(model2));

    await subject.delete('fake-id', cascate: true);

    verifyInOrder([
      remoteSource.delete('fake-id', cascate: true),
      cacheUpdate.onDelete('fake-id', cascate: true),
    ]);
  });
}
