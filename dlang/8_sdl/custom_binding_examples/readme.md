# readme


Examples in SDL that do not use any bindings or dub, but rather a custom C interface.

This requires a translation of the C SDL function calls into D function calls.

For the most part, this is very similar code, but there are a few differences (e.g. 'unsigned int' to 'uint', converting macros to functions, #define to alias or enum, etc.).
