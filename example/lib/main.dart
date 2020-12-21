import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:resource_repository/repository_strategies/cache_only.dart';
import 'package:resource_repository/resource_repository.dart';

import 'repository/user.dart';
import 'resource/user.dart';
import 'sources/user/cache.dart';
import 'sources/user/remote.dart';

Future<void> main() async {
  await Hive.initFlutter();
  Hive.registerAdapter<UserResource>(UserResourceAdapter());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home pa'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final userRepository = UserRepository();
  final cacheOnlyStrategy = RemoteFirstRepositoryStrategy(
    cacheSource: UserCacheResourceSource(),
    remoteSource: UserRemoteResourceSource(),
    cacheUpdate: IncrementalCacheUpdateStrategy(
      UserCacheResourceSource(),
    ),
  );

  final faker = Faker();

  List<UserResource> _users = [];

  Future<void> _createNew() async {
    final name = faker.person.name();
    final model = UserResource(name: name);

    await userRepository.create(
      model,
      strategy: cacheOnlyStrategy,
    );

    await _loadAll();
  }

  Future<void> _removeUser(UserResource user) async {
    await userRepository.delete(
      user.id,
      strategy: cacheOnlyStrategy,
    );

    await _loadAll();
  }

  void _showDetails(UserResource user) {
    showDialog(
      context: context,
      builder: (_) {
        return Dialog(
          child: Column(
            children: [
              Text(user.name),
              Divider(),
              Text(user.toString()),
            ],
          ),
        );
      },
    );
  }

  Future<void> _clearAll() async {
    await (cacheOnlyStrategy.cacheSource as UserCacheResourceSource).clear();
    await _loadAll();
  }

  Future<void> _loadAll() async {
    final users = await userRepository.getAll(strategy: cacheOnlyStrategy);

    setState(() {
      _users = users;
    });
  }

  @override
  void initState() {
    _loadAll();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: Icon(Icons.delete_sweep_sharp),
            onPressed: _clearAll,
          ),
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _loadAll,
          ),
        ],
      ),
      body: ListView.builder(
        itemBuilder: (_, index) {
          final user = _users[index];

          return ListTile(
            onTap: () => _showDetails(user),
            onLongPress: () => _removeUser(user),
            title: Text(user.name),
          );
        },
        itemCount: _users.length,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _createNew,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
