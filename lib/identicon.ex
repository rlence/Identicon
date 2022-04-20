defmodule Identicon do

  def main(input) do
    input
    |> hash_input
    |> pick_color
    |> build_grid
    |> filter_odd_squares
    |> build_pixel_map
    |> draw_image
    |> save_image(input)
  end

  def save_image(image, input) do
    File.write("#{input}.png", image)

  end

  @spec draw_image(Identicon.Image.t()) :: any
  def draw_image(%Identicon.Image{color: color, pixel_map: pixel_map }) do
    image = :egd.create(250, 250)
    fill = :egd.color(color)

    Enum.each pixel_map, fn({start, stop}) ->
      :egd.filledRectangle(image, start, stop, fill)
    end

    :egd.render(image)

  end

  def build_pixel_map(%Identicon.Image{grid: grid } = image) do
    pixel_map = Enum.map grid, fn({_code, index }) ->

      horizantal = rem(index, 5 ) * 50
      vertical = div(index, 5) * 50

      top_lef = { horizantal, vertical }
      bottom_right = {horizantal + 50, vertical + 50 }

      {top_lef, bottom_right}

    end

    %Identicon.Image{image | pixel_map: pixel_map}
  end

  def filter_odd_squares(%Identicon.Image{grid: grid } = image) do
    grid = Enum.filter grid, fn({ code, _index }) ->
      rem(code, 2) == 0
    end

    %Identicon.Image{image | grid: grid}
  end

  def build_grid(%Identicon.Image{hex: hex} = image) do
    grid = hex
    |> Enum.chunk(3)
    # el & funciona para indicar que la funcion que estamos usando y pasar una referencia
    # luego viene el nombre de la funcion y de ultimo un / con el numero de argumentos a pasar
    |> Enum.map(&mirror_row/1)
    |> List.flatten
    |> Enum.with_index

    %Identicon.Image{image | grid: grid }
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
