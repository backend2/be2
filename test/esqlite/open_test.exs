defmodule Be2.Esqlite.OpenTest do
  use ExUnit.Case, async: false

  defp rm_file_if_exists(file) do
    if (File.exists? file) do
      File.rm! file
    end
  end

  test "open_test_db" do
    rm_file_if_exists "test.db"
    
    {:ok, db} = :esqlite3.open('test.db')

    assert true == File.exists?("test.db")

    assert [{1}] == :esqlite3.q('SELECT 1', db)
    assert [{1}] == :esqlite3.q('SELECT 1 as c', db)
    assert [{1, 2}] == :esqlite3.q('SELECT 1, 2', db)

    assert [{1}, {2}] == :esqlite3.q('SELECT 1 UNION ALL SELECT 2', db)
    
    assert :ok == :esqlite3.close(db)
    assert true == File.exists?("test.db")
    rm_file_if_exists "test.db"
  end

  test "open_test_db_persist_data" do
    rm_file_if_exists "test.db"
    
    {:ok, db} = :esqlite3.open('test.db')
    assert true == File.exists?("test.db")

    assert :ok == :esqlite3.exec('CREATE TABLE tbl (id integer NOT NULL)', db)
    assert :ok == :esqlite3.exec('INSERT INTO tbl VALUES (1)', db)
    assert [{1}] == :esqlite3.q('SELECT id FROM tbl', db)
    assert [{1}] == :esqlite3.q('SELECT count(*) FROM tbl', db)
    assert :ok == :esqlite3.exec('INSERT INTO tbl VALUES (2)', db)
    assert [{1}, {2}] == :esqlite3.q('SELECT id FROM tbl ORDER BY id', db)
    assert [{2}] == :esqlite3.q('SELECT count(*) FROM tbl', db)

    assert :ok == :esqlite3.close(db)
    # Open again
    {:ok, db} = :esqlite3.open('test.db')
    assert true == File.exists?("test.db")
    assert [{1}, {2}] == :esqlite3.q('SELECT id FROM tbl ORDER BY id', db)
    assert [{2}] == :esqlite3.q('SELECT count(*) FROM tbl', db)
    assert :ok == :esqlite3.close(db)

    rm_file_if_exists "test.db"
  end

  test "open_test_2_db_persist_data" do
    rm_file_if_exists "test1.db"
    rm_file_if_exists "test2.db"
    # Open db1
    {:ok, db1} = :esqlite3.open('test1.db')
    assert true == File.exists?("test1.db")
    assert :ok == :esqlite3.exec('CREATE TABLE tbl (id integer NOT NULL)', db1)
    # Open db2
    {:ok, db2} = :esqlite3.open('test2.db')
    assert true == File.exists?("test2.db")
    assert :ok == :esqlite3.exec('CREATE TABLE tbl (id integer NOT NULL)', db2)

    assert :ok == :esqlite3.exec('INSERT INTO tbl VALUES (1)', db1)
    assert [{1}] == :esqlite3.q('SELECT id FROM tbl', db1)
    assert [] == :esqlite3.q('SELECT id FROM tbl', db2)

    assert :ok == :esqlite3.exec('INSERT INTO tbl VALUES (2)', db2)
    assert [{1}] == :esqlite3.q('SELECT id FROM tbl', db1)
    assert [{2}] == :esqlite3.q('SELECT id FROM tbl', db2)

    assert :ok == :esqlite3.exec('INSERT INTO tbl VALUES (3)', db1)
    assert :ok == :esqlite3.exec('INSERT INTO tbl VALUES (4)', db2)
    assert [{1}, {3}] == :esqlite3.q('SELECT id FROM tbl ORDER BY id', db1)
    assert [{2}, {4}] == :esqlite3.q('SELECT id FROM tbl ORDER BY id', db2)

    assert :ok == :esqlite3.close(db1)
    assert :ok == :esqlite3.close(db2)

    # Open again 
    {:ok, db1} = :esqlite3.open('test1.db')
    {:ok, db2} = :esqlite3.open('test2.db')

    assert [{3}, {1}] == :esqlite3.q('SELECT id FROM tbl ORDER BY id DESC', db1)
    assert [{4}, {2}] == :esqlite3.q('SELECT id FROM tbl ORDER BY id DESC', db2)

    assert :ok == :esqlite3.close(db1)
    assert :ok == :esqlite3.close(db2)

    rm_file_if_exists "test1.db"
    rm_file_if_exists "test2.db"
  end

end
