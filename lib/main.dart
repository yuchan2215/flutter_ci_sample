import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';


Key saveKey = const ValueKey("saveKey");
Key loadKey = const ValueKey("loadKey");
Key countKey = const ValueKey("countKey");
const countStorageKey = "COUNT";

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _storage = const FlutterSecureStorage();
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  /// ストレージの[countStorageKey]に[_count]を保存する。
  void _save() {
    _storage
        .write(
          key: countStorageKey,
          value: _counter.toString(),
        )
        .then(
          (value) => ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("保存しました")),
          ),
        );
  }

  /// ストレージから[countStorageKey]を使って保存された値を読み込み、[_count]に反映させる。
  void _load() {
    _storage.read(key: countStorageKey).then((value) {
      //もし値がないなら早期リターン
      if (value == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("データが保存されていません。")),
        );
        return;
      }
      int loadValue = int.parse(value);
      setState(() {
        _counter = loadValue;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("データを読み込みました")),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              key: countKey,
              style: Theme.of(context).textTheme.headline4,
            ),
            ElevatedButton(
              key: saveKey,
              onPressed: () => _save(),
              child: const Text("Save"),
            ),
            ElevatedButton(
              key: loadKey,
              onPressed: () => _load(),
              child: const Text("Load"),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
