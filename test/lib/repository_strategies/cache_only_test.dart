import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:resource_repository/repository_strategies/cache_only.dart';
import 'package:resource_repository/resource_source/cache/index.dart';
import 'package:resource_repository/resource_source/resource.dart';

class MockCacheResourceSource extends Mock implements CacheResourceSource {}

class MockResource extends Mock implements Resource {}

void main() {
  MockResource model;
  MockCacheResourceSource cacheSource;
  CacheOnlyRepositoryStrategy subject;

  setUp(() {
    model = MockResource();
    cacheSource = MockCacheResourceSource();
    subject = CacheOnlyRepositoryStrategy(
      cacheSource: cacheSource,
    );
  });

  test('.getAll', () async {
    when(cacheSource.findAll()).thenAnswer((_) => Future.value([model]));

    final result = await subject.getAll();

    expect(result, [model]);
    verify(cacheSource.findAll()).called(1);
  });

  test('.get', () async {
    when(cacheSource.findOne('fake-id')).thenAnswer((_) => Future.value(model));

    final result = await subject.get('fake-id');

    expect(result, model);
    verify(cacheSource.findOne(any)).called(1);
  });

  test('.create', () async {
    await subject.create(model);

    verify(cacheSource.create(model)).called(1);
  });

  test('.update', () async {
    await subject.update('fake-id', model);

    verify(cacheSource.update('fake-id', model)).called(1);
  });

  test('.delete', () async {
    await subject.delete('fake-id', cascate: true);

    verify(cacheSource.delete('fake-id', cascate: true)).called(1);
  });
}
