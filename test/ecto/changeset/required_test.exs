defmodule Be2.Ecto.Changeset.RequiredTest do 
  use ExUnit.Case, async: true

  import Ecto.Changeset

  defmodule Category do
    use Ecto.Model

    schema "categories" do
      field :a,  :integer, default: 10
      field :b,  :integer
      field :c,  :integer
      field :d,  :integer
    end
  end

  test "category_changeset_cast_test" do
    params = %{:a => 1, :b => 2, :x => 3}
    normalized_params = %{"a" => 1, "b" => 2, "x" => 3}

    model = %Category{}

    changeset = cast(model, params, ~w(a)a, ~w(b)a)

    assert Map.size(changeset) == 14

    assert changeset.__struct__     == Ecto.Changeset
    assert changeset.params         == normalized_params
    assert changeset.model          == model
    assert changeset.changes        == %{a: 1, b: 2}
    assert changeset.errors         == []
    assert changeset.validations    == []
    assert changeset.required       == [:a]
    assert changeset.optional       == [:b]
    assert changeset.valid?         == true
    assert changeset.action         == nil
    assert changeset.constraints    == []
    assert changeset.filters        == %{}
    assert changeset.repo           == nil
    assert changeset.types          == %{id: :id, a: :integer, b: :integer, c: :integer, d: :integer}
  end
end
