# Goluaf
_Lua but for golfing_

## Introduction

Goluaf, _Pronounced "Go-Lu-af"_ is a wrapper for Lua built around trying to make it as golfy as possible. This is because lua is annoyingly verbose, and even simple things can end up with loads of unnecessary boilerplate.

Take, my favourite example, printing the Alphabet.

In lua, the fastest way to do this is literally `print"ABCDEFGHIJKLMNOPQRSTUVWXYZ"` _(33 Bytes)_. Other solutions exist, like `a=""for i=65,90 do a=a..string.char(i)end print(a)` _(50 bytes)_ and `for i=65,90 do io.write(string.char(i))end print()` _(50 bytes)_ but as can be seen, neither of them are viable, unless doing so alongside something else.

Goluaf blows this out of the water.

`p(A)` _(4 Bytes)_

But if you feel this is cheating, you can skip the constant alphabet, and actually generate it.

`w((char*(90)(65))())p()` _(23 Bytes)_

which breaks down into...
```
w((char*(90)(65))())	-- Write the alphabet
  (char*(90)(65))   	-- for char(n) in 65<=n<=90
  				 ()  	-- Call it, which generates the arguments 'A', 'B', ..., which io.write loves to just slam together.
  				 	p() -- Print, giving us our trailing newline.
```

## Running scripts

You can run a script from the command line via one of the below methods:

* `lua golf.lua target_file.lua "_arg1" "_arg2"`
* `lua golf.lua "something_to_do" +e "_arg1" "_arg2"`

## Features

Below in no particular order are a list of features.

* Exposed libraries. Many of the Libraries, `string`, `math`, etc. have had their functions exposed to `_G`, which turns `math.floor` to just `floor`
* Shortened globals. Arbitrary calls to global functions, including those exposed, can be made by calling `_something`. `something` can be as few characters as uniquely belong to `something`, so assuming nothing else shares these characters, `_som` refers to `something`.
* Handpicked Constants. Important functions for golfing such as `load`, `print`, `io.write` and some constant values have been given much shorter names.
* [Tacit programming](https://en.wikipedia.org/wiki/Tacit_programming). Through the use of operators on functions, they can be tact'd together, which is often much shorter than defining a new function.
* And of course, all the power of lua.

## Command Line Arguments

On the command line, you can specify particular flags to change how Goluaf will behave.
Below, are the currently usable command line arguments, and their basic functionality.

* `+e` **Execute:** Will run the input as lua, instead of as a file.
* `+debug` **Debug:** Will turn on basic debugging info. Prints to STDERR the more basic and often negligible information.
* `+debug_error` **Error Debug:** Will turn on error debugging info. Prints errors to STDERR. With this, all errors halt, otherwise, only some of the less vital ones do.
* `+debug_system` **System Debug:** Things that someone editing Goluaf might care about, but not someone writing IN Goluaf will, are printed to STDERR. None of it halting.''

Flags can be toggled on via a `+` or off via a `-`. The uppercase form of a flag indicates the opposite functionality, which, defaultly, simply toggles the flag the other way. So, `+e` and `-E` are functionality identical.

## Details

### Tacit

The Tacit system is fundemental for helping to improve scores for code-golfing, allowing you to completely ignore much of the boilerplate requires whilst keeping most of the same functionality.

The operators, and their descriptions are:

* `a<func>+b<func>`. A flat link. Returns a function that runs both funcs with the arguments inputted.
* `a<func>+b<any>`. Returns a function that returns `a(...), b`.
* `a<any>+b<func>`. Like the inverse, yet returns `a, b(...)`.

* `a<func>*b<func>`. Essentially a `for ... in b do` call. Keeps calling `a(b())` until `b()` starts returning false or nil.
* `a<func>*b<string>`. Works both ways around identically. Calls `a()` with each character of `b` sequentially.
* `a<func>*b<number>`. Calls `a(...)` `b` times.
* `a<func>*b<table>`. Calls `a(key,value)` for each key and value in `b`.

* `a<func>^b<func>`. Returns a function that calls `a(...,b())`.
* `a<func>^b<any>`. Returns a function that calls `a(...,b)`.
* `a<any>^b<func>`. Returns a function that calls `a(b,...)`.

### String, Boolean and Number Modifications.

Basic objects have been given a bit more functionality, For math and tacing and such.

**Strings**

* Calling them is equivalent to `:gmatch(arg)`, calling it with a blank arg is equivalent to calling it with `'.'`
* Calling them with two arguments is equivlent to `:sub(a,b)`.
* Indexing them with a number will return the substring at that index.
* Indexing them with a string will, if the `string` table does not contain it, return the index in which `key` first appears.
* Adding them, if not a number, will concatenate them.
* Multiplying it with a number will repeat it that many times.

**Numbers**

* Calling them returns an iterater from 1 to `n`. If an arg is provided, then the iterater is from `arg` to `n`.

**Booleans**

* Booleans will let you do math with them, true acting as 1, and false acting as 0.

**Nils**

* Nil will act as a 0 in all math.


## Constant Values

Some values have also be added to act as constants.

* `l`: `load`
* `H`: `"Hello, World!"`
* `h`: `"hello world"`
* `p`: `print`
* 'w': `write`
* `m`: `min`
* `M`: `max`
* `Q`: `"\""`
* `q`: `"'"`
* `A`: `"ABCDEFGHIJKLMNOPQRSTUVWXYZ"`
* `a`: `"abcdefghijklmnopqrstuvwxyz"`
* `n`: `"\n"`
