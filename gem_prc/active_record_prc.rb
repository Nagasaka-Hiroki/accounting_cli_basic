#ActiveRecordを単体で使う
require 'debug'
require 'minitest/autorun'
require 'active_record'

class ActiveRecordTest < Minitest::Test
    #テスト用のデータベースパス
    DATABASE_PATH="#{File.dirname(File.expand_path(__FILE__))}/test.db"
    #データベースを削除する。
    def teardown
        #SQLite3は単純にファイルを削除してデータベースを削除する。
        begin
            File.delete(DATABASE_PATH)
        rescue
            puts "#{DATABASE_PATH} does not exist!"
        end
    end

    #ActiveRecordによるデータベースの接続。
    def test_connect_db
        #SQLite3だと単純に以下で接続できる。
        ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: DATABASE_PATH)

        #接続を確認。
        #ActiveRecord::Base.connected?は少し違うメソッドみたい。接続情報から接続状態を確認する。
        assert_equal ActiveRecord::Base.connection_db_config.configuration_hash[:database], #接続情報を表示（読み込み専用）
                     DATABASE_PATH #データベースが正しく指定されているか確認して接続を確認する。

        #切断する。
        ActiveRecord::Base.remove_connection

        #切断を確認。失敗を期待するのでassert_raises内で実行する。
        assert_raises(ActiveRecord::ConnectionNotEstablished, "connection exists!") do
            ActiveRecord::Base.connection_db_config #切断後に接続すると失敗する。
        end
    end

    #レコードの記録の確認。
    def test_new_model
        # binding.break
        #データベースに接続する。
        ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: DATABASE_PATH)
        #テーブルを作成する。
        ActiveRecord::Migration.create_table :test_models do |t|
            t.integer :rec_1
        end

        #作ったテーブルにレコードを挿入する。
        (1..10).each do |i|
            TestModel.create(rec_1: 100+i)
        end
        #一覧を表示する。
        pp TestModel.all
        #切断する。
        ActiveRecord::Base.remove_connection
    end
end

#ActiveRecordのモデルを作る。
class TestModel < ActiveRecord::Base
end