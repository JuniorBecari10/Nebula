# Nebula

A simple library for Assembly programming in Linux environments. <br />
It supports both x32 and x64 architectures.

## Requirements

- `nasm`
- `ld`
- `make` (optional)

## How to Use

There are 2 folders in this repository: `x32` and `x64`. Pick the desired one.

Inside the folders there are 3 files:

- `lib.asm`:

This file contains the functions your program is able to use. It is not recommended to modify this file, since it may not function properly if modified incorrectly.

This file contains functions provided by `asmtutor.com`.

This file is commented out, with the name of the functions and its symbolic signature.

For example, this is the signature of the `print_uint64` function, defined in the `x64/lib.asm` file:

```
fn print_uint64(n: rax uint64): void
prints an unsigned 64-bit integer stored in rax.
```

In this case, this function will only accept an unsigned 64-bit number in the `rax` register, and it doesn't return anything.

It is recommended to take a look at these signatures when using the functions, to ensure registers hold the correct values.

All functions in the library restore the original values of all used registers.

- `main.asm`:

This file will contain your program. There is some boilerplate code, such as importing the library and defining the main function.

It is recommended to modify only the main function, the other ones the user may create, and also the `.data` section of the `main.asm` file. Changing other parts of the boilerplate code may cause it to not function properly too.

- `Makefile`:

This file contains the commands needed to assemble your program and turn it into an executable file.

You need to have `make` installed in order to run it.

If you don't want to use the `Makefile`, you can run the commands individually or put them in a shell script.

## Freedom of Use

The user is free to modify any parts of this library, even if some parts are not recommended to do so, since, like mentioned above, some parts may not function correctly.

Do you have a suggestion or proposal of change to this library? Open an Issue!

## License

This library is provided under the GPL-3.0 License.
