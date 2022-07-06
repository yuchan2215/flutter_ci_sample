import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_ci_example/main.dart' as app;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  //IntegrationTestをするためのおまじない
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  //毎回呼び出される初期化処理
  setUp(() async {
    //ストレージの値を初期化する。
    await const FlutterSecureStorage()
        .write(key: app.countStorageKey, value: null);
  });

  group('ストレージ関係', () {
    testWidgets('ストレージに保存するテスト', (tester) async {
      var storage = const FlutterSecureStorage();
      app.main();
      await tester.pumpAndSettle();

      //ストレージ初期値のnullチェック
      var storageCount = await storage.read(key: app.countStorageKey);
      expect(storageCount, null);

      //何回かボタンをを押す
      var fab = find.byTooltip('Increment');
      var times = Random().nextInt(10) + 5;
      for (int i = 0; i < times; i++) {
        await tester.tap(fab);
        await tester.pumpAndSettle();
      }

      //押した回数の値が表示されているか？
      expect(find.text(times.toString()), findsOneWidget);

      //saveボタンを押す。
      await tester.tap(find.byKey(app.saveKey));
      await tester.pumpAndSettle();

      //ストレージの数値が正しいか確認する
      storageCount = await storage.read(key: app.countStorageKey);
      expect(storageCount, times.toString());
    });

    testWidgets('ストレージから読み込むテスト', (tester) async {
      var storage = const FlutterSecureStorage();
      app.main();
      await tester.pumpAndSettle();

      //表示されている初期値は0？
      expect(find.text("0"), findsOneWidget);

      //loadボタンを押す。
      await tester.tap(find.byKey(app.loadKey));
      await tester.pumpAndSettle();

      //表示されている値は0？
      expect(find.text("0"), findsOneWidget);

      //ストレージの初期値を決める。
      var times = Random().nextInt(10000) + 1;

      //ストレージに書き込む
      await storage.write(key: app.countStorageKey, value: times.toString());

      //loadボタンを押す。
      await tester.tap(find.byKey(app.loadKey));
      await tester.pumpAndSettle();

      //値がしっかりと読み込めているか？
      expect(find.text(times.toString()), findsOneWidget);
    });
  });
}
