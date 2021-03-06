.PHONY: test all lint doc clean t.exe

UNAME = $(shell uname)

WINFLAGS = -lcygwin -lSDL2main # order of cflags matters

CFLAGS = 

ifeq ($(UNAME), Windows_NT)
CFLAGS = ${WINFLAGS}
endif

ifeq ($(UNAME), CYGWIN_NT-6.1-WOW64)
CFLAGS = ${WINFLAGS}
endif

ifeq ($(UNAME), Darwin)
SDL2_PATH = -I/usr/local/include/SDL2
else
SDL2_PATH = -I/usr/include/SDL2
endif

all : test t.exe
  # cat t.ll
	./t.exe

t.ll : src/Eel.hs test/Spec.hs
	stack runghc test/Spec.hs

%.s : %.ll
	llc $<

t.exe : t.s eel.c
	clang -I/usr/include/SDL2 -I/usr/local/include/SDL2 -o $@ $^ ${CFLAGS} -lSDL2

#all : test doc # lint
	# stack install
	# ./t.exe
	# ./t.exe

lint :
	hlint app src test

doc :
	stack haddock

test :
	stack test

clean :
	stack clean
