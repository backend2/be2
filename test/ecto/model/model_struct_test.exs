defmodule Be2.Ecto.Model.ModelStructTest do 
  use ExUnit.Case, async: true

  import Ecto.Changeset

  defmodule User do
    use Ecto.Model

    schema "users" do
      field :username,  :string,   default: "noname"
      field :active,    :boolean,  default: true
      field :age,       :integer,  default: 0
    end

    # Do active proccesing for active user 
    def get_age_for_active_user(%User{active: true, age: age}) do
      # Do proccesing
      age
    end
  end

  test "user_struct_call_active_user" do
    user = %User{}

    assert user.__struct__ == User
    assert user.username   == "noname"
    assert user.active     == true
    assert user.age        == 0
    assert User.get_age_for_active_user(user) == 0

    # This do not works
    # user_equal = %User{user}
    # I change to 
    user_equal = user

    user_equal = user
    assert user_equal.__struct__ == User
    assert user_equal.username   == "noname"
    assert user_equal.active     == true
    assert user_equal.age        == 0
    assert User.get_age_for_active_user(user_equal) == 0

    user2 = %User{user | username: "my username", age: 10}
    assert user2.__struct__ == User
    assert user2.username   == "my username"
    assert user2.active     == true
    assert user2.age        == 10
    assert User.get_age_for_active_user(user2) == 10

    user3 = %User{username: "new username", age: 20, active: true}
    assert user3.__struct__ == User
    assert user3.username   == "new username"
    assert user3.active     == true
    assert user3.age        == 20
    assert User.get_age_for_active_user(user3) == 20

    simple_map = %{:username => "cool", :active => false, :age => 30}

    # This sintax do not work 
    #user4 = %User{simple_map}

    #assert user4.__struct__ == User
    #assert user4.username   == "cool"
    #assert user4.active     == false
    #assert user4.age        == 30
    #assert User.get_age_for_active_user(user4) == 30
  end

  test "get_age_for_active_user_call_FunctionClauseError" do
    inactive_user = %User{active: false}
    assert_raise FunctionClauseError, 
      "no function clause matching in Be2.Ecto.Model.ModelStructTest.User.get_age_for_active_user/1", fn ->
      User.get_age_for_active_user(inactive_user)
    end
  end
end
