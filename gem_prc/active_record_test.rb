#ActiveRecordを単体で使う
require 'debug'
require 'minitest/autorun'
require 'sqlite3'
require 'active_record'

class ActiveRecordTest < Minitest::Test
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
    def test_connect_db
        ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: DATABASE_PATH)
    end
end
