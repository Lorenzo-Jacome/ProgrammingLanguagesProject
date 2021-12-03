#Final-Project
#
#Miguel Hernández A01022398
#Lorenzo Jacome A01026759
#
#Feistel Algorithm


defmodule Feistel do
  #Funcion que recibe el nombre de un archivo y regresa una
  #lista con cada byte
  def readImage(fileName) do
    File.stream!(fileName, [], 1)
  end

  #Funcion que recibe lista, contador (.bmp = 54), y lista vacia para resultado
  #Regresa lista de enteros con cada byte
  def generateByteList(list, count, resultList) do
    if count < Enum.count(list) do
      generateByteList(list, count + 1, resultList ++ [:binary.decode_unsigned(Enum.at(list, count))])
    else
      resultList
    end
  end

  #Funcion que toma seccion de header de bmp (count = 0)
  def generateHeader(list, count, resultHeader) do
    if count < 54 do
      generateHeader(list, count + 1, resultHeader ++ [(Enum.at(list, count))])
    else
      resultHeader
    end
  end

  #Creat matriz de bits tomando la lista de bytes
  def bytesToBits(listBytes, resultMat) do
    if Enum.count(listBytes) != 0 do
      bytesToBits(tl(listBytes), resultMat ++ [addRemainingBits(Integer.digits(hd(listBytes), 2))])
    else
      resultMat
    end
  end

  def addRemainingBits(listToAdd) do
    if Enum.count(listToAdd) < 8 do
      addRemainingBits([0 | listToAdd])
    else
      listToAdd
    end
  end

  def xor(leftSide, e, newList) do
    if Enum.count(leftSide) != 0 do
      if hd(leftSide) != hd(e) do
        xor(tl(leftSide), tl(e), newList ++ [1])
      else
        xor(tl(leftSide), tl(e), newList ++ [0])
      end
    else
      newList
    end
  end

  #Funcion que realiza un Fesitel Round
  def feistelRound(matBits) do
    twoSides = split(matBits)
    leftSide = List.flatten(elem(twoSides, 0))

    rightSide = List.flatten(elem(twoSides, 1))

    e = reverse(rightSide)

    newLeft = rightSide
    newRight = xor(leftSide, e, [])

    newNormal = newLeft ++ newRight

    twoSides2 = split(newNormal)
    leftSide2 = elem(twoSides2, 0)
    rightSide2 = elem(twoSides2, 1)

    newE = reverse(rightSide2)

    newLeft2 = rightSide2
    newRight2 = xor(leftSide2, newE, [])

    result = newLeft2 ++ newRight2

    twoSides3 = split(result)
    leftSide3 = elem(twoSides3, 0)
    rightSide3 = elem(twoSides3, 1)

    newE2 = reverse(rightSide3)

    newLeft3 = rightSide3
    newRight3 = xor(leftSide3, newE2, [])

    finalResult = newLeft3 ++ newRight3
    finalResult


  end

  #Regresa lista de cada bit (sin header)
  def feistelBits(fileName) do
    header = generateHeader(readImage(fileName), 0, [])

    normalList = readImage(fileName)
    byteList = generateByteList(normalList, 54, [])
    binMat = bytesToBits(byteList, [])
    bitMat = addRemainingBits(binMat)
    x = feistelRound(bitMat)
    bitsGroup = separateBits(x)
    final = header ++ bitsToBytes(bitsGroup, [])
    final

    #generateHeader(readImage(fileName), 0, []) ++ bitsToBytes(bitsGroup, [])
  end

  #Recives a list of 8 bits and returns a decimal (counter must be 7 at start and result 0)
  def bitsToDec(listOfBits, count, resultDec) do
    if count >= 0 do
      bitsToDec(tl(listOfBits), count - 1, resultDec + (hd(listOfBits) * :math.pow(2,count) |> round))
    else
      resultDec
    end
  end

  #Dividir lista de bits en grupos de 8 y general lista de bytes
  def separateBits(listOfBits) do
    Enum.chunk_every(listOfBits, 8)
  end

  def bitsToBytes(separatedList, newList) do
    if Enum.count(separatedList) != 0 do
      bitsToBytes(tl(separatedList), newList ++ [bitsToDec(hd(separatedList), 7, 0)])
    else
      newList
    end
  end

  def feistelEncrypt(fileName) do
    binaryList = feistelBits(fileName)
    bitsGroup = separateBits(binaryList)
    generateHeader(readImage(fileName), 0, []) ++ bitsToBytes(bitsGroup, [])
  end

  #-----------------------------------------------------------------------------------------------------------

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
