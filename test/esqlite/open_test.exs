defmodule Be2.Esqlite.OpenTest do
  use ExUnit.Case, async: true

  defp rm_file_if_exists(file) do
    if (File.exists? file) do
      File.rm! file
    end
  end

  test "open_test_db" do
    rm_file_if_exists "test.db"
    
    {ok, db} = :esqlite3.open('test.db')

    assert true == File.exists?("test.db")

    assert [{1}] == :esqlite3.q('SELECT 1', db)
    assert [{1}] == :esqlite3.q('SELECT 1 as c', db)
    assert [{1, 2}] == :esqlite3.q('SELECT 1, 2', db)

    assert [{1}, {2}] == :esqlite3.q('SELECT 1 UNION ALL SELECT 2', db)
    
    assert :ok == :esqlite3.close(db)
    assert true == File.exists?("test.db")
    rm_file_if_exists "test.db"
  end


end
