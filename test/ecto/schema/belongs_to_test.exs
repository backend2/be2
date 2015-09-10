defmodule Be2.Ecto.Schema.BelongsToTest do 
  use ExUnit.Case, async: true

  defmodule Category do
    use Ecto.Model

    schema "categories" do
      field :name
    end 
  end

  # default belongs_to 
  defmodule Client do
    use Ecto.Model
    alias Be2.Ecto.Schema.BelongsToTest.Category

    schema "clients" do
      field :name
      belongs_to :category, Category
    end
  end
  
  # Docs from http://hexdocs.pm/ecto/Ecto.Schema.html  
  test "default_belongs_to_test" do
    schema_fn1 = &Client.__schema__/1
    Client.__schema__(:source) == "clients"
    # Or short version
    assert schema_fn1.(:source)             ==  "clients"
    assert schema_fn1.(:primary_key)        == [:id]
    assert schema_fn1.(:fields)             == [:id, :name, :category_id]
    assert schema_fn1.(:types)              == [id: :id, name: :string, category_id: :id]
    assert schema_fn1.(:associations)       == [:category]
    assert schema_fn1.(:embeds)             == []
    assert schema_fn1.(:read_after_writes)  == []
    # TODO
    # assert Client.__schema__(:autogenerate)       == [] # Is not defined! Expect []
    assert schema_fn1.(:autogenerate_id)    == {:id, :id}

    assoc = Client.__schema__(:association, :category)
    assert Map.size(assoc) == 9 # 1 (__struct__ key) + 8 keys 

    assert assoc.__struct__     == Ecto.Association.BelongsTo
    assert assoc.cardinality    == :one
    assert assoc.defaults       == []
    assert assoc.field          == :category
    assert assoc.owner          == Be2.Ecto.Schema.BelongsToTest.Client
    assert assoc.owner_key      == :category_id
    assert assoc.queryable      == Be2.Ecto.Schema.BelongsToTest.Category
    assert assoc.related        == Be2.Ecto.Schema.BelongsToTest.Category
    assert assoc.related_key    == :id
  end

end