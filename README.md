# sysoaitest

Skrypt do instalacji i testowania oprogramowania potrzebnego w czasie laboratoriów związanych z kursem __Systemy Obliczeniowe__.
Jest to Makefile, który zainstaluje odpowiednie pakiety przez __apt__, zainstaluje __asdf__, odpowiednią wersję pythona i dla niej zainstaluje odpowiednie wersje pakietów.

## Wymagania

Wymagane pakiety pythona: _requirements\_general.txt_. Jest to lista pakietów wraz z wersjami, które ostatnio działały. W razie potrzeby można je uaktualnić. Dla MintLinux zostaną zainstalowane pakiety zapisane w pliku _mint\_packages.txt_

Wymagania (pozostałe):
+ Odpowiednie sterowniki dla karty graficznej. Powinny działać z OpenCL i Keras. To niestety trzeba dodać manualnie, gdy znamy hardware.
+ Jakieś IDE do pythona. Proponuję VSCode z odpowiednimi wtyczkami

## Uruchomienie

Uruchomienie instalacji i testów następuje poprzez wpisanie w terminalu

```
make
```
