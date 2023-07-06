# 簿記のプログラム
　簿記の習得を目標にプログラムを作成する。

## 学習目標
　せっかく新しくコードを作るのでコードとデータを分離する以前の目標に取り組む。（以前はコードの中にデータを直接打ち込んで使っていた）<br/>
以前のコードは以下。
- [ubuntu_shell_script/get_domain_name at main · Nagasaka-Hiroki/ubuntu_shell_script · GitHub](https://github.com/Nagasaka-Hiroki/ubuntu_shell_script/tree/main/get_domain_name)

分離する手段として今回はデータベースを使ってデータを分離して管理する。<br/>
データベースを使うRubyGemは複数あるが以下の2つを使う。

1. `ActiveRecord`
2. `sqlite3-ruby`

ActiveRecordは内部でsqlite3-rubyを使っている。以下に書かれている。

- [ActiveRecord::ConnectionAdapters::SQLite3Adapter](https://api.rubyonrails.org/v7.0/classes/ActiveRecord/ConnectionAdapters/SQLite3Adapter.html)

読んでいてわかったことは、ActiveRecord自体にデータベースを作成することができないようだ。接続はできるが作成はできないみたい。なのでsqlite3-rubyを併用してruby側から作成を試みる。

ActiveRecordを単体での使い方は以下が参考になる。

- [Ruby 単体で ActiveRecord を使いたい - Qiita](https://qiita.com/dnnnn_yu/items/027665ccb88de2fd9b55)

そのため以下を学習目標とする。

1. データベースを使ってデータを永続化およびプログラムとデータを分離する。
1. ActiveRecordを単体で使ってRailsの理解を深める。

## 参考文献
　以下のサイトを参考にする。頻繁にアクセスするのでリンクを貼り付けておく。
- [ File: README — Documentation for sqlite3 (1.6.3) ](https://www.rubydoc.info/gems/sqlite3)
- [README.rdoc](https://api.rubyonrails.org/v7.0/files/activerecord/README_rdoc.html)
- [ActiveRecord::ConnectionAdapters::SQLite3Adapter](https://api.rubyonrails.org/v7.0/classes/ActiveRecord/ConnectionAdapters/SQLite3Adapter.html#method-c-database_exists-3F)
- [Query Language Understood by SQLite](https://www.sqlite.org/lang.html)
- [Command Line Shell For SQLite](https://www.sqlite.org/cli.html)
- [SQLite3 チートシート - Qiita](https://qiita.com/sotetsuk/items/cd2aeae4ba7e72faad47)
- [【SQLite3】コマンド例と他データベースとの比較から始める SQLite 入門 - Qiita](https://qiita.com/d-yokoi/items/be7cf4622c66cdcc04cb)
- [Ruby+SQLite3 - Qiita](https://qiita.com/akito_tameto/items/868e3805dc01c7bef6ef)
- [Ruby で SQLite ってみた - 想像力の欠如は深刻な欠点の一つである。](https://noqisofon.hatenablog.com/entry/20101219/1292687825)
- [SQLite｜テーブルスキーマ(構造)の確認](https://www.javadrive.jp/sqlite/table/index2.html)

## SQLインジェクション対策
　SQL文をコードに書くとき、変数に対してエスケープ処理が必要になる。そのためプレースホルダーを使った書き方が重要になる。<br/>
今回はローカルで動作するので厳密には必要ないがせっかくなので取り組んで見る。

試した結果何故かテーブル名に対してプレースホルダーが使えない。Railsの場合テーブルに相当するのはモデルクラスでプレースホルダはモデルに含まれるレコードを絞り込むのに使う。そのためプレースホルダで重要なのは条件のところという認識になる。また以下のサイトを確認した。

- [プレースホルダとは？SQLインジェクション攻撃を回避せよ！](https://blog.senseshare.jp/placeholder.html)

この例を見ると`execute_batch`を使わずに`execute`を使うのがよいかもしれない。ひとまずテーブル名の切り替えはプレースホルダではなく変数で切り替えるように意識して考える。
