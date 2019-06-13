//Definimos El numero de simbolos
#define NSYMS 100
//generamos una estructura para los simbolos
struct symtab {
    char *name;
    int value;
    char *type;
} symtab[NSYMS];

struct symtab *putsym();
