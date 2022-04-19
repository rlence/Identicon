defmodule Identicon do

  def main(input) do
    input
    |> hash_input
    |> pick_color
    |> build_grid
  end

  def build_grid(%Identicon.Image{hex: hex} = image) do
    hex
    |> Enum.chunk(3)
  end

  def mirror_row(row) do
    [ first, second | _tail ] = row
    # con el ++ es como el push en javascript para agregar elementos a la list
    row  ++ [ second, first ]
  end

  def pick_color(image) do
    # Pattern Matching Structs
    # indicamos que es un Image struct que tengra la propuedad hex y en el hex_list que es una
    # variable no definida se le va a asignar el valor del hex que esta en el parametro image
    %Identicon.Image{hex: hex_list} = image
    # para obtener los valores que queramos de un array en este caso los 3 primeros de un array de 16 lenght
    # usamos un pipe y luego _tail para indicar que todos los demas elementos del array no nos interesa
    [r, g, b | _tail] = hex_list

    %Identicon.Image{ image | color: { r,g,b }}
  end

  def hash_input(input) do
    hex = :crypto.hash(:md5, input)
    |> :binary.bin_to_list

    %Identicon.Image{ hex: hex }
  end

end
