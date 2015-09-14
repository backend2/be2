defmodule Be2.Elixir.MapTest do
  use ExUnit.Case, async: false

  # Uncoment code in body function to see output
  defp puts(mess) do
    # IO.puts "\n"
    # IO.puts mess
  end  

  defp print_map(m) do
     Enum.each m, fn({k,v}) -> 
       puts "#{k} => #{v}" 
     end
  end
  
  defp process_map(m) do
    pr_m = 
       m |> Map.delete(:d) |> Map.put(:a, "new")
    puts "Print from proces_map(m)"
    print_map pr_m
    pr_m   
  end 


  test "the_map_work" do
    m = %{x: 1, y: 2, z: 3, d: "to delete"}
    
    puts "Print from test"
    print_map m

    process_map m

    puts "Print from test again"
    print_map m
  end

# Print from test
# d => to delete
# x => 1
# y => 2
# z => 3


# Print from proces_map(m)
# a => new
# x => 1
# y => 2
# z => 3


# Print from test again
# d => to delete
# x => 1
# y => 2
# z => 3
end
