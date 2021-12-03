#Final-Project
#
#Miguel Hernández A01022398
#Lorenzo Jacome A01026759
#
#Feistel Algorithm


defmodule Feistel do
  #Function that recieves a file name
  #and returns a list with every byte in that file
  defp readImage(fileName) do
    File.stream!(fileName, [], 1)
  end

  #Function that recieves the list generated by reading the file, a counter from where to start to
  #iterate and an empty list to save the result
  #Returns a list with the bytes outisde the header
  #(When working with .bmp files, counter must start at 54 for it to ignore the header)
  defp generateByteList(list, count, resultList) do
    if count < Enum.count(list) do
      generateByteList(list, count + 1, resultList ++ [:binary.decode_unsigned(Enum.at(list, count))])
    else
      resultList
    end
  end

  #Function that recieves the list generated by reading the file, a counter that must
  #start at 0, and a list for the result to be stored
  #It returns the header of an .bmp file
  defp generateHeader(list, count, resultHeader) do
    if count < 54 do
      generateHeader(list, count + 1, resultHeader ++ [(Enum.at(list, count))])
    else
      resultHeader
    end
  end

  #Recives a list of bytes and you pass a list to store the result
  #Returns a matrix / list of lists with each byte turned into bits
  defp bytesToBits(listBytes, resultMat) do
    if Enum.count(listBytes) != 0 do
      bytesToBits(tl(listBytes), resultMat ++ [addRemainingBits(Integer.digits(hd(listBytes), 2))])
    else
      resultMat
    end
  end

  #Recives the list of lists of bits and adds 0s to the left in each bit in case it is necessary
  #in order to preserve the full byte for the future reconstruction of the image in the future
  defp addRemainingBits(listToAdd) do
    if Enum.count(listToAdd) < 8 do
      addRemainingBits([0 | listToAdd])
    else
      listToAdd
    end
  end

  #Recieves two bits lists and applies xor to them
  #Returns the values in bits after the xor
  defp xor(leftSide, e, newList) do
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

  #Recives the matrix of bits to apply Feistel to it
  #Returns the bits after being applied Feistel
  defp feistelRound(matBits) do
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

  #MAIN FUNCTION
  #Recieves the file name(.bmp) and encrypts it using Feistel
  #It generates an image in the same directory where the programm is running
  #with the encrypted picture
  def feistelEncrypt(fileName) do
    header = generateHeader(readImage(fileName), 0, [])

    normalList = readImage(fileName)
    byteList = generateByteList(normalList, 54, [])
    binMat = bytesToBits(byteList, [])
    bitMat = addRemainingBits(binMat)
    x = feistelRound(bitMat)
    bitsGroup = separateBits(x)
    final = header ++ bitsToBytes(bitsGroup, [])
    File.write("encrypt.bmp", final)
  end

  #Recives an encrypted bmp image and returns it to its original value
  def feistelDecrypt(fileName) do
    header = generateHeader(readImage(fileName), 0, [])

    normalList = readImage(fileName)
    byteList = generateByteList(normalList, 54, [])
    binMat = bytesToBits(byteList, [])
    bitMat = addRemainingBits(binMat)
    x = feistelRound(bitMat)
    bitsGroup = separateBits(x)
    final = header ++ bitsToBytes(bitsGroup, [])
    File.write("decrypt.bmp", final)
  end

  #Recives a list of 8 bits and returns a decimal (counter must be 7 at start and result 0)
  defp bitsToDec(listOfBits, count, resultDec) do
    if count >= 0 do
      bitsToDec(tl(listOfBits), count - 1, resultDec + (hd(listOfBits) * :math.pow(2,count) |> round))
    else
      resultDec
    end
  end

  #Divides the list of bits into groups of 8
  defp separateBits(listOfBits) do
    Enum.chunk_every(listOfBits, 8)
  end

  #Translates a list of bits into its Decimal value
  defp bitsToBytes(separatedList, newList) do
    if Enum.count(separatedList) != 0 do
      bitsToBytes(tl(separatedList), newList ++ [bitsToDec(hd(separatedList), 7, 0)])
    else
      newList
    end
  end

  #------------------------------AUX FUNCTIONS----------------------------------------------
  #Recieves a list and flips its order
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

    #Recives a list and returns a tuple with its value 0 being the first half of the list
    #and its value 1 being the other half
    def split(list) do
      len = round(length(list)/2)
      Enum.split(list, len)
    end

    #Contatenates two lists
    def concat(list1, list2) do
      list1 ++ list2
    end

    #Turns a decimal value to its binary value
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
