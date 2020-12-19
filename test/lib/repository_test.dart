import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:resource_repository/repository.dart';
import 'package:resource_repository/repository_strategies/strategy.dart';
import 'package:resource_repository/resource_source/resource.dart';

class MockResource extends Mock implements Resource {}

class MockRepositoryStrategy extends Mock implements RepositoryStrategy {}

void main() {
  MockResource model;
  MockRepositoryStrategy strategy;
  Repository subject;

  setUp(() {
    model = MockResource();
    strategy = MockRepositoryStrategy();
    subject = Repository();
  });

  test('.getAll', () async {
    when(strategy.getAll()).thenAnswer((_) => Future.value([model]));

    final result = await subject.getAll(strategy: strategy);

    expect(result, [model]);
    verify(strategy.getAll()).called(1);
  });

  test('.get', () async {
    when(strategy.get('fake-id')).thenAnswer((_) => Future.value(model));

    final result = await subject.get('fake-id', strategy: strategy);

    expect(result, model);
    verify(strategy.get('fake-id')).called(1);
  });

  test('.create', () async {
    await subject.create(model, strategy: strategy);

    verify(strategy.create(model)).called(1);
  });

  test('.update', () async {
    await subject.update('fake-id', model, strategy: strategy);

    verify(strategy.update('fake-id', model)).called(1);
  });

  test('.delete', () async {
    await subject.delete('fake-id', cascate: true, strategy: strategy);

    verify(strategy.delete('fake-id', cascate: true)).called(1);
  });
}
