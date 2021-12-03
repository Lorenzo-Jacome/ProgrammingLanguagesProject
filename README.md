# Encrypted Members - Feistel encryption
## Members
* Lorenzo Jácome - A01026759
* Miguel Hernández - A01022398
## Description
The purpose of this project is to develop a set of modules and functions targeted to the encryption and decryption usning the Feistel Algorithm of digital photografies.
Nowdays, maintaining your data private is becoming more of a challenge and it's hard to define wether certain information sharing platforms are actually keeping our infomration private and outside the access of other people. That is why the purpose of this project is to guarantee that, whenever you have the need to send delicate information or just wanting to keep your pictures private, you have access to an easy to use tool that ensures your selected pictures get encrypted and ready to send, rendering this pictures useless for anyone who should not have access to them. To achieve this, the users of this programm will have access to functions that:
1. Encrypt a selected picture and returns the encrypted file, ready to be sent. 
2. Decrypt a file you have, given that you have the key. 

## Objective
The project has multiple applications, but specifically, it is designed to encrypt the images of a facial recognition system to keep non wanted user to have access to private pictures. 

Being students of the Tecnológico de Monterrey campus Santa Fe we care about the community, therefore, we take as a reference the new implementation of the facial recognition system to be able to enter and leave the campus.

Lately cyberattacks have focused on the theft of biometric data information, therefore in our project it has the objective of being able to be used to encrypt all the photos with which the campus facial recognition system operates in order to reinforce data security.

## Topics for the Project
1. Lists: let's use the list topic to iterate the vector that contains the image data, with the help of [head | tail].
2. File I / O: we use this topic to read the image that the user wants to encrypt and at the same time we use it to return the image encrypted or decrypted.
3. Encryption: we use this topic to encrypt the image data provided by the user, but only as a reference since we implement the Feistel method.

## Details
**Language:** The project will ve developed using [Elixir](https://elixir-lang.org/)
### Functionality and behaviour
The programm expects to recieve an image in an .bmp format. It will be processed using by our programm by reading each byte, dividing the header and body bytes. The body bytes will be encrypted using the Feistel algorithm. Once the bytes are encrypted, they are attached to the header bytes to recreate a new image. Our program returns this new encrypted picture and stores it in the same directory where the program ran. The user will be able to interact with the picture but it has nothing to do with the original. Now, to decrypt it, the program will allow the user to process the image againt thorugh the same Feistel process in order to return it to its original value. 
#### Encryption
1. The user selects the picture it wants to encrypt.
3. The user selects where does he want to store the new encrypted file
4. The user selects the name of the new file
5. The user gets prompted with the location and name of its new generated file
#### Decryption
1. The user selects the picture to decrypt
3. The user selects where does he want to store its decrypted file
4. The user gets prompted with the location of the file

![ExampleA](https://github.com/Lorenzo-Jacome/ProgrammingLanguagesProject/blob/main/Images/image1.jpeg)
![ExampleB](https://github.com/Lorenzo-Jacome/ProgrammingLanguagesProject/blob/main/Images/image2.jpeg)

### References
1. http://profesores.elo.utfsm.cl/~agv/elo329/1s04/projects/C_Mellings.L_Baez/Documentacion.htm
2. https://www.redalyc.org/pdf/4988/498853957007.pdf
3. https://elixir-lang.org/getting-started/erlang-libraries.html#the-crypto-module
4. https://github.com/elixir-mogrify/mogrify

