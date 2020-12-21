import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:mockito/mockito.dart';
import 'package:resource_repository/resource_source/cache/hive_data_source.dart';
import 'package:resource_repository/resource_source/resource.dart';

class MockResource extends Mock implements Resource {}

class MockBox extends Mock implements Box<MockResource> {}

class HiveResourceSourceImpl extends HiveResourceSource {
  @override
  String get boxName => 'fake-box-name';
}

void main() {
  MockBox box;
  MockResource model;
  MockResource model2;
  HiveResourceSourceImpl subject;

  setUp(() async {
    box = MockBox();
    model = MockResource();
    model2 = MockResource();
    subject = HiveResourceSourceImpl();

    await subject.initialize(box);
  });

  test('.findAll', () async {
    // Be sure that converts keys to int
    when(box.keys).thenReturn(['1', 2]);
    when(box.get(1)).thenAnswer((_) => model);
    when(box.get(2)).thenAnswer((_) => model2);

    final result = await subject.findAll();

    expect(result, [model, model2]);

    verifyInOrder([
      box.keys,
      box.get(1, defaultValue: null),
      box.get(2, defaultValue: null),
    ]);
  });

  test('.findOne', () async {
    when(box.get(1)).thenAnswer((_) => model);

    final result = await subject.findOne('1');

    expect(result, model);

    verify(box.get(1, defaultValue: null)).called(1);
  });

  group('.findOneByExternalId', () {
    test('when find local register', () async {
      when(box.keys).thenReturn([1]);
      when(model.externalId).thenReturn('fake-external-id');
      when(box.get(1)).thenAnswer((_) => model);

      final result = await subject.findOneByExternalId('fake-external-id');

      expect(result, model);

      verify(box.get(1, defaultValue: null)).called(1);
    });

    test('when find no local register', () async {
      when(box.keys).thenReturn([1]);
      when(model.externalId).thenReturn('fake-external-id-2');
      when(box.get(1)).thenAnswer((_) => model);

      final result = await subject.findOneByExternalId('fake-external-id');

      expect(result, null);

      verify(box.get(1, defaultValue: null)).called(1);
    });
  });

  test('.update', () async {
    final result = await subject.update('1', model);

    expect(result, model);

    verify(box.put(1, model)).called(1);
  });

  test('.create', () async {
    const key = 1;
    when(box.add(model)).thenAnswer((_) => Future.value(key));

    final result = await subject.create(model);

    expect(result, model);

    verifyInOrder([
      box.add(model),
      model.id = key.toString(),
      box.put(key, model),
    ]);
  });

  test('.delete', () async {
    await subject.delete('1');

    verify(box.delete(1)).called(1);
  });

  test('.clear', () async {
    await subject.clear();

    verify(box.deleteFromDisk()).called(1);
  });
}
