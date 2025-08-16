# Kotlin/Native + C example

example project with C and Kotlin/Native.

The only notable thing here is the makefile:
- it generates kotlin bindings from the C code
- it builds the kotlin code using the bindings (which also generates kotlin's api headers)
- using the headers it compiles the C code
- links everything together

You need:
- `clang` and `clang++`
- Kotlin/Native

