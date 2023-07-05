require 'debug'
require 'minitest/autorun'
require 'sqlite3'

#sqlite3-testの動作を確認する。
class SQLite3Test < Minitest::Test
    DATABASE_PATH="./test.db" #テスト用のデータベースパス
    TABLE_NAME="sample"
    #データベースを作成する。
    def setup
        #データベースファイルの作成と接続
        @db=SQLite3::Database.new(DATABASE_PATH)
        #データベースのスキーマをSQLから指定してテーブルを作成する。
        @db.execute(<<~SQL, :table_name => TABLE_NAME)
            create table :table_name
            (
                record_id integer not null,
                record_st varchar(32) not null,
                primary key (record_id)
            );
        SQL
    end
    #データベースを削除する。
    def teardown
        #切断する。
        @db.close
        #SQLite3は単純にファイルを削除してデータベースを削除する。
        File.delete(DATABASE_PATH)
    end

    #接続したデータベースを操作する。
    def test_insert_reacord
        binding.break if ENV.fetch("DEBUG",false)

        #executeは一つの命令のみ実行する。
        @db.execute("begin transaction;")
        #データを挿入
        @db.execute(<<~SQL,:table_name => TABLE_NAME)
            insert into :table_name values(100, "record no 1");
        SQL
        @db.execute("commit;")
        #挿入したデータを確認。
        @db.execute("select * from :table_name;",:table_name => TABLE_NAME) do |rec|
            puts rec
        end
    end
    #複数のレコードを挿入して確認する。
end