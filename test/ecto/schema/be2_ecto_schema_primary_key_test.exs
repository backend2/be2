defmodule Be2.Ecto.Schema.PrimaryKeyTest do 
  use ExUnit.Case, async: true

  defmodule A do
    use Ecto.Model

    schema "default_primary_key" do
      field :name
    end 
  end

  test "default_primary_key_test" do
    assert                    [:id] == A.__schema__(:primary_key)
    assert [id: :id, name: :string] == A.__schema__(:types) 
    # assert [:id] == A.__schema__(:autogenerate)
  end

  defmodule B1 do
    use Ecto.Model

    @primary_key {:b_key, :id, autogenerate: false}
    schema "b1_my_primary_key" do
      field :name
    end
  end

  defmodule B2 do
    use Ecto.Model

    @primary_key {:b_key, :binary_id, autogenerate: false}
    schema "b2_my_primary_key" do
      field :name
    end 
  end

  defmodule B3 do
    use Ecto.Model

    @primary_key {:b_key, :string, autogenerate: false}
    schema "b3_my_primary_key" do
      field :name
    end 
  end  

  test "my_primary_key_test" do
    # Test pk field name [1]
    assert                     [:b_key] == B1.__schema__(:primary_key)
    assert                     [:b_key] == B2.__schema__(:primary_key)
    assert                     [:b_key] == B3.__schema__(:primary_key)

    # Same as [1] different syntaxes
    assert List.duplicate([:b_key], 3) == 
       Enum.map([B1, B2, B3], fn(m) -> m.__schema__(:primary_key) end)

    # Same as [1] different syntaxes
    assert [:b_key] |> List.duplicate(3) ==
       [B1, B2, B3] |> Enum.map &(&1.__schema__(:primary_key))

    assert        [b_key: :id, name: :string] == B1.__schema__(:types) 
    assert [b_key: :binary_id, name: :string] == B2.__schema__(:types) 
    assert    [b_key: :string, name: :string] == B3.__schema__(:types) 
  end

  defmodule C do
    use Ecto.Model

    @primary_key false
    schema "no_primary_key" do
      field :name
    end 
  end

  test "no_primary_key_test" do
    assert [] == C.__schema__(:primary_key) 
  end


end