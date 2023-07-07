require 'debug'
require 'minitest/autorun'
require 'sqlite3'

#sqlite3-rubyの動作を確認する。
class SQLite3Test < Minitest::Test
    #テスト用のデータベースパス
    DATABASE_PATH="#{File.dirname(File.expand_path(__FILE__))}/test.db"
    #データベースを作成する。
    def setup
        #データベースファイルの作成と接続
        @db=SQLite3::Database.new(DATABASE_PATH)
    end
    #データベースを削除する。
    def teardown
        @db.close #切断する。
        #SQLite3は単純にファイルを削除してデータベースを削除する。
        File.delete(DATABASE_PATH)
    end
    def table_up
        #SQLから指定してテーブルを作成する。
        @db.execute(<<~SQL)
            create table test
            (
                record_id integer not null,
                record_st varchar(32) not null,
                primary key (record_id)
            );
        SQL
    end
    def table_down
        @db.execute(<<~SQL)
            drop table test;
        SQL
    end
    def table_check
        #テーブルを確認
        @db.execute("select count(*) from sqlite_master where name='test' and type='table';") do |rec|
            if rec[0]==1
                puts "test tableが存在します。"
            else
                puts "test tableが存在しません。"
            end
        end
    end

    #接続したデータベースを操作する。
    def test_insert_reacord
        table_up
        table_check
        @db.transaction do
            binding.break if ENV.fetch("DEBUG",false)
            #executeは一つの命令のみ実行する。
            #データを挿入
            @db.execute(<<~SQL, :id=>100, :rec=>"record no 1")
                insert into test values(:id, :rec);
            SQL
        end
        #挿入したデータを確認。
        @db.execute("select * from test;") do |rec|
            pp rec
        end
        table_down
        table_check
    end
    #複数のレコードを挿入して確認する。
    def test_insert_multi_reacord
        table_up
        @db.transaction do
            #executeは一つの命令のみ実行する。
            #データを挿入
            data_list=(1..5).to_a.map do |i|
                {id: i, rec: "record no #{i}"}
            end
            data_list.each do |v|
                @db.execute(<<~SQL, :id=>v[:id], :rec=>v[:rec])
                    insert into test values(:id, :rec);
                SQL
            end
        end
        #挿入したデータを確認。
        @db.execute("select * from test;") do |rec|
            pp rec
        end
        table_down
    end

    #テーブル名にプレースホルダが使えるか試す。ｰ>無理なので無理やり切り替える。
    TABLE_NAME="test"
    def test_placeholder
        table_up
        #良くは無いが以下のようにするとテーブル名に変数が使える。
        @db.execute(<<~SQL)
            drop table #{TABLE_NAME};
        SQL
    end
end