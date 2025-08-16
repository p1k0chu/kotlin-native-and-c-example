#include "main.h"
#include "mykt_api.h"

int get_funny_number() {
    return 69;
}

int main() {
    mykt_ExportedSymbols *symbols = mykt_symbols();

    symbols->kotlin.root.print_hi();

    return 0;
}

