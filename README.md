## How to run the test:

Simply run `make`

# Flashing the firmware

For converting assembly to machine code we are using a package called `bronzebeard`. We then take the output
and inject it in our ROM code. 

By default we will target the file `assembly/main.asm`. The process can be invoked by:

```make compile-firmware```

In case you wish to override the target file you can set it as an argument. For example:

```make compile-firmware TARGET_ASSEMBLY_FILE=doom.asm```

The target file must be in the `assembly` folder.
