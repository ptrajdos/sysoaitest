# sysoaitest

Skrypt do testowania oprogramowania potrzebnego w czasie laboratoriów związanych z kursem __Systemy Obliczeniowe__.

Jest to prosty *Makefile*, który uruchamia skrypty w pythonie. Każdy ze skryptów pythona testuje wybrane pakiety tego języka

## Wymagania

Wymagane pakiety pythona: requirements.txt. Jest to lista pakietów wraz z wersjami, które ostatnio działały. W razie potrzeby można je uaktualnić.

Wymagania (pozostałe):

+ Python 3.9.X (Powoli wychodzi z użycia, można przejść na 3.10.X lub nowszy)
+ Mpich
+ Java JDK (co najmniej 11.0)
+ scala
+ spark
+ kompilator c i c++
+ LLVM
+ clinfo
+ libpocl2
+ ocl-icd-opencl-dev
+ oclgrind
+ Odpowiednie sterowniki dla karty graficznej. Powinny działać z OpenCL i Keras.

## Uruchomienie

Uruchomienie testów następuje poprzez wpisanie w terminalu

```
make
```
