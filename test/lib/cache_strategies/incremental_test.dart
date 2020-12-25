import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:resource_repository/cache_strategies/incremental.dart';
import 'package:resource_repository/resource_source/cache/index.dart';
import 'package:resource_repository/resource_source/resource.dart';

class MockCacheResourceSource extends Mock implements CacheResourceSource {}

class MockResource extends Mock implements Resource {}

void main() {
  MockResource model;
  IncrementalCacheUpdateStrategy subject;
  MockCacheResourceSource cacheSource;

  group('IncrementalCacheUpdateStrategy', () {
    setUp(() {
      model = MockResource();
      cacheSource = MockCacheResourceSource();
      subject = IncrementalCacheUpdateStrategy(cacheSource);
    });

    group('.onCreate', () {
      test('when find register by external id', () async {
        final localModel = MockResource();
        final copyModel = MockResource();

        when(localModel.id).thenReturn('fake-local-id');
        when(localModel.copy(model)).thenReturn(copyModel);

        when(model.externalId).thenReturn('fake-external-id');
        when(cacheSource.findOneByExternalId('fake-external-id'))
            .thenAnswer((_) => Future.value(localModel));

        await subject.onCreate(model);

        verify(cacheSource.update('fake-local-id', copyModel)).called((1));
        verify(localModel.copy(model)).called(1);
        verifyNever(localModel.shallowCopy(any));
        verifyNever(cacheSource.create(any));
      });

      test('when find no register by external id', () async {
        when(model.externalId).thenReturn('fake-external-id');
        when(cacheSource.findOneByExternalId('fake-external-id'))
            .thenAnswer((_) => Future.value(null));

        await subject.onCreate(model);

        verify(cacheSource.create(model)).called(1);
        verifyNever(cacheSource.update(any, any));
      });
    });

    group('.onDelete', () {
      test('when find register by external id', () async {
        when(model.id).thenReturn('fake-local-id');
        when(cacheSource.findOneByExternalId('fake-external-id'))
            .thenAnswer((_) => Future.value(model));

        await subject.onDelete("fake-external-id", cascate: true);

        verify(cacheSource.delete("fake-local-id", cascate: true)).called(1);
      });

      test('when find no register by external id', () async {
        when(cacheSource.findOneByExternalId('fake-external-id'))
            .thenAnswer((_) => Future.value(null));

        await subject.onDelete("fake-external-id", cascate: true);

        verifyNever(cacheSource.delete(any));
      });
    });

    group('.onGet', () {
      test('when find register by external id', () async {
        final localModel = MockResource();
        final copyModel = MockResource();

        when(localModel.id).thenReturn('fake-local-id');
        when(localModel.copy(model)).thenReturn(copyModel);

        when(model.id).thenReturn('fake-local-id');
        when(model.externalId).thenReturn('fake-external-id');
        when(cacheSource.findOneByExternalId('fake-external-id'))
            .thenAnswer((_) => Future.value(localModel));

        await subject.onGet(model);

        verify(cacheSource.update("fake-local-id", copyModel)).called(1);
        verify(cacheSource.findOneByExternalId("fake-external-id")).called(1);
        verifyNever(localModel.shallowCopy(any));
        verifyNever(cacheSource.create(any));
      });

      test('when find no register by external id', () async {
        when(model.id).thenReturn('fake-local-id');
        when(model.externalId).thenReturn('fake-external-id');
        when(cacheSource.findOneByExternalId('fake-external-id'))
            .thenAnswer((_) => Future.value(null));

        await subject.onGet(model);

        verify(cacheSource.findOneByExternalId("fake-external-id")).called(1);
        verify(cacheSource.create(model)).called(1);
        verifyNever(cacheSource.update(any, any));
      });
    });

    test('.onGetAll', () async {
      final localModel = MockResource();
      final copyModel = MockResource();

      when(localModel.id).thenReturn('fake-local-id-1');
      when(localModel.shallowCopy(model)).thenReturn(copyModel);

      when(model.id).thenReturn('fake-local-id-1');
      when(model.externalId).thenReturn('fake-external-id-1');
      when(cacheSource.findOneByExternalId('fake-external-id-1'))
          .thenAnswer((_) => Future.value(localModel));

      await subject.onGetAll([model]);

      verify(cacheSource.update('fake-local-id-1', copyModel)).called(1);
      verify(cacheSource.findOneByExternalId("fake-external-id-1"));
      verifyNever(localModel.copy(any));
      verifyNever(cacheSource.create(any));
    });

    group('.onUpdate', () {
      test('when find register by external id', () async {
        final localModel = MockResource();
        final copyModel = MockResource();

        when(localModel.id).thenReturn('fake-local-id');
        when(localModel.copy(model)).thenReturn(copyModel);

        when(model.id).thenReturn('fake-local-id');
        when(model.externalId).thenReturn('fake-external-id');
        when(cacheSource.findOneByExternalId('fake-external-id'))
            .thenAnswer((_) => Future.value(localModel));

        await subject.onUpdate('fake-external-id', model);

        verify(cacheSource.update("fake-local-id", copyModel)).called(1);
        verify(cacheSource.findOneByExternalId("fake-external-id")).called(1);
        verifyNever(localModel.shallowCopy(any));
        verifyNever(cacheSource.create(any));
      });

      test('when find no register by external id', () async {
        when(model.id).thenReturn('fake-local-id');
        when(model.externalId).thenReturn('fake-external-id');
        when(cacheSource.findOneByExternalId('fake-external-id'))
            .thenAnswer((_) => Future.value(null));

        await subject.onUpdate('fake-external-id', model);

        verify(cacheSource.findOneByExternalId("fake-external-id")).called(1);
        verify(cacheSource.create(model)).called(1);
        verifyNever(cacheSource.update(any, any));
      });
    });
  });
}
