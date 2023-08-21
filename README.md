# sysoaitest

Skrypt do testowania oprogramowania potrzebnego w czasie laboratoriów związanych z kursem __Systemy Obliczeniowe__.

Jest to prosty *Makefile*, który uruchamia skrypty w pythonie. Każdy ze skryptów pythona testuje wybrane pakiety tego języka

## Wymagania

Wymagane pakiety pythona: requirements.txt

Wymagania (pozostałe):

  + Python 3.9.X
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