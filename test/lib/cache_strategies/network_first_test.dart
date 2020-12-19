import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:resource_repository/cache_strategies/network_first.dart';
import 'package:resource_repository/resource_source/cache/index.dart';
import 'package:resource_repository/resource_source/resource.dart';

class MockCacheResourceSource extends Mock implements CacheResourceSource {}

class MockResource extends Mock implements Resource {}

void main() {
  MockResource model;
  NetworkFirstCacheUpdateStrategy subject;
  MockCacheResourceSource cacheSource;

  setUp(() {
    model = MockResource();
    cacheSource = MockCacheResourceSource();
    subject = NetworkFirstCacheUpdateStrategy(cacheSource);
  });

  group('NetworkFirstCacheUpdateStrategy', () {
    test('.onCreate', () async {
      await subject.onCreate(model);

      verify(cacheSource.create(model)).called(1);
    });

    test('.onDelete', () async {
      await subject.onDelete("resource-id", cascate: true);

      verify(cacheSource.delete("resource-id", cascate: true)).called(1);
    });

    group('.onGet', () {
      test('when exists local register', () async {
        when(model.idKey).thenReturn("resource-id");
        when(cacheSource.findOne("resource-id"))
            .thenAnswer((_) => Future.value(model));

        await subject.onGet(model);

        verify(cacheSource.update("resource-id", model)).called(1);
        verify(cacheSource.findOne("resource-id")).called(1);
        verifyNever(cacheSource.delete(any));
      });

      test('when does not exist local register', () async {
        when(model.idKey).thenReturn("resource-id");
        when(cacheSource.findOne("resource-id"))
            .thenAnswer((_) => Future.value(null));

        await subject.onGet(model);

        verify(cacheSource.create(model)).called(1);
        verify(cacheSource.findOne("resource-id")).called(1);
        verifyNever(cacheSource.update(any, any));
      });
    });

    test('.onGetAll', () async {
      when(model.idKey).thenReturn("resource-id");
      when(cacheSource.findOne("resource-id"))
          .thenAnswer((_) => Future.value(model));

      await subject.onGetAll([model, model]);

      verify(cacheSource.update("resource-id", model)).called(2);
      verify(cacheSource.findOne("resource-id")).called(2);
      verifyNever(cacheSource.delete(any));
    });

    test('.onUpdate', () async {
      when(model.idKey).thenReturn("resource-id");
      when(cacheSource.findOne("resource-id"))
          .thenAnswer((_) => Future.value(model));

      await subject.onUpdate("resource-id", model);

      verify(cacheSource.update("resource-id", model)).called(1);
      verify(cacheSource.findOne("resource-id")).called(1);
      verifyNever(cacheSource.delete(any));
    });
  });
}
