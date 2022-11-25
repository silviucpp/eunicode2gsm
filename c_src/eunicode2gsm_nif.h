#ifndef C_SRC_EUNICODE2GSM_NIF_H_
#define C_SRC_EUNICODE2GSM_NIF_H_

#include "erl_nif.h"

struct atoms
{
    ERL_NIF_TERM atomTrue;
    ERL_NIF_TERM atomFalse;
    ERL_NIF_TERM atomError;
    ERL_NIF_TERM atomBadArg;
};

extern atoms ATOMS;

#endif
