# sysoaitest

Skrypt do instalacji i testowania oprogramowania potrzebnego w czasie laboratoriów związanych z kursem __Systemy Obliczeniowe__.
Jest to Makefile, który zainstaluje odpowiednie pakiety przez __apt__, zainstaluje __asdf__, odpowiednią wersję Pythona i utworzy wirtualne środowisko (venv) z odpowiednimi pakietami.

## Wymagania

Wymagane pakiety Pythona: _requirements\_general.txt_. Jest to lista pakietów wraz z wersjami, które ostatnio działały. W razie potrzeby można je uaktualnić. Dla MintLinux zostaną zainstalowane pakiety systemowe zapisane w pliku _mint\_packages.txt_

Wymagania (pozostałe):
+ Odpowiednie sterowniki dla karty graficznej. Powinny działać z OpenCL i Keras. To niestety trzeba dodać manualnie, gdy znamy hardware.
+ Jakieś IDE do Pythona. Proponuję VSCodium (`make vscodium`) lub inne IDE z odpowiednimi wtyczkami.

## Uruchomienie

Uruchomienie pełnej instalacji i testów:

```
make
```

Można też uruchamiać poszczególne cele osobno:

```bash
make install       # Tylko instalacja (asdf, Python, venv, pakiety, Oclgrind)
make tests         # Tylko testy (wymaga wcześniejszej instalacji)
make numpy         # Pojedynczy test
```

## Struktura

Środowisko wirtualne (venv) jest tworzone w katalogu domowym: `~/sysoai_venv`. Nazwę można zmienić zmienną `VENV_NAME`:

```bash
make VENV_NAME=moje_srodowisko
```
