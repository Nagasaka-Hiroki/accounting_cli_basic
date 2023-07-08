# 作業記録
## 概要
　メモを記録する。

## 記録
### ActiveRecordのメモ
　ActiveRecordを使う際に調べたURLについてメモする。

- [SQLite3に接続するときの書き方｜README.rdoc](https://api.rubyonrails.org/files/activerecord/README_rdoc.html)
- [ActiveRecord::ConnectionAdapters::SchemaStatements](https://edgeapi.rubyonrails.org/classes/ActiveRecord/ConnectionAdapters/SchemaStatements.html#method-i-create_table)

### SQLインジェクション対策
　SQL文をコードに書くとき、変数に対してエスケープ処理が必要になる。そのためプレースホルダーを使った書き方が重要になる。<br/>
今回はローカルで動作するので厳密には必要ないがせっかくなので取り組んで見る。

試した結果何故かテーブル名に対してプレースホルダーが使えない。Railsの場合テーブルに相当するのはモデルクラスでプレースホルダはモデルに含まれるレコードを絞り込むのに使う。そのためプレースホルダで重要なのは条件のところという認識になる。また以下のサイトを確認した。

- [プレースホルダとは？SQLインジェクション攻撃を回避せよ！](https://blog.senseshare.jp/placeholder.html)

この例を見ると`execute_batch`を使わずに`execute`を使うのがよいかもしれない。ひとまずテーブル名の切り替えはプレースホルダではなく変数で切り替えるように意識して考える。

### 疑問
　create_tableがActiveRecord::ConnectionAdapters::SchemaStatementsの名前空間付きで実行できない。なぜ？<br/>
`NoMethodError: undefined method 'create_table' for ActiveRecord::ConnectionAdapters::SchemaStatements:Module`というエラーが出る。

応急処置として`ActiveRecord::Migration.create_table`の形で実行している。しかしこの方法だとテーブルを作成する過程がターミナルに表示される。（CLIアプリにするのであまりこれは良くない）

別の方法として以下の手段もある。

```ruby
db=ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: DATABASE_PATH).connection
db.create_table #以降は定義
```

しかし、この書き方は個人的に避けたい。create_table自体がモジュールメソッドなのでできれば名前空間とモジュール名（orクラス名）で指定したい。加えて`db`は`ActiveRecord::ConnectionAdapters::SQLite3Adapter `クラスのインスタンスだが、クラスメソッドとしては実行できなかった。インスタンスメソッドまたは特異メソッドとして`create_table`が定義されていると考えられる。

最大の疑問は`ActiveRecord::Migration.create_table`が実行できて、`ActiveRecord::ConnectionAdapters::SchemaStatements.create_table`にエラーが出るかがわからない。

ターミナルに出力される問題を回避する単純な方法として`db.create_table`を使うのはいいと思うので一時的にこれを採用する。

### 