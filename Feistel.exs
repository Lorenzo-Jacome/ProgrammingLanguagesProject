#Final-Project
#
#Miguel Hernández A01022398
#Lorenzo Jacome A0102
#
#Feistel Algorithm


defmodule Feistel do
  #TODO: Leer imagen bmp
  #TODO: Convertir cada byte en bits
  #TODO: Aplicar Feistel a los bits
  #TODO: Regresar bits a bytes y regresar a imagen

  def reverse(list), do: do_reverse(list, [])
    defp do_reverse([], listreturn),
       do: listreturn
    defp do_reverse([head | tail], listreturn) do
      if is_list(head) do
        do_reverse(tail, [reverse(head) | listreturn])
      else
        do_reverse(tail, [head | listreturn])
      end
    end

    def split(list) do
      len = round(length(list)/2)
      Enum.split(list, len)
    end


    def concat(list1, list2) do
      list1 ++ list2
    end

    def decimal_to_binary(str) when is_binary(str) do
      str
      |> String.to_integer()
      |> decimal_to_binary()
    end

    def decimal_to_binary(num) when is_integer(num) do
      binary_string = :erlang.integer_to_binary(num, 2)
      binary_string_length = String.length(binary_string)
      desired_string_length = binary_string_length + (8 - rem(binary_string_length, 8))
      String.pad_leading(binary_string, desired_string_length, "0")
    end


  end
