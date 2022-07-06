#!/bin/bash

#ディレクトリ移動
cd "$(dirname "$0")/.." || exit 1

if [ "$CI" = true ]; then
  # CI環境のテスト実行
  flutter test --coverage --machine | tee >(grep "^{" | grep "}$" >temp_report.log)
else
  flutter test --coverage
  #カバレッジの出力
  genhtml coverage/lcov.info -o coverage/html > /dev/null
  #開く
  open "file://$(pwd)/coverage/html/index.html"
fi
