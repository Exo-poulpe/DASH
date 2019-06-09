# *DASH* #

**DASH** is a program for test hash in D language.

## Installation ##

*This program work only for Windows x86 OS*

Download the source and compile then.

## Usage/Help ##

```
Program write by Exo-poulpe 0.1.0.2
This program break hash from D language.
-t    --target Target value to find
-m      --mode Mode to use for hash function
        0 | md5
        1 | sha1
        2 | sha256
        3 | sha512
   --benchmark Benchmark mode
       --count Print count password only
-w  --wordlist Wordlist to use for password testing
-v   --verbose More verbose output
-h      --help This help information.

Exemple : dash -m 0 -t <hash> -w rockyou.txt
```

## Exemple ##

For exemple :

```
./dash.exe -m 0 -t 1a79a4d60de6718e8e5b326e338ae533 -w Dico\BigFile.txt
```


## Benchmark ##

```
Benchmark mode : SHA256
Password count : 10000000
==============================
Start : 2019-Jun-09 20:38:20.6891273
Stop : 2019-Jun-09 20:38:45.4489597
Password per seconds : ~389.88 KH/s
```

For benchmark RustHash test 1'000'000 MD5 hash (default), the result is not very accurate

## Features ##

TODO
