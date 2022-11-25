#include "nif_utils.h"
#include "eunicode2gsm_nif.h"

#include <string.h>

ERL_NIF_TERM make_atom(ErlNifEnv* env, const char* name)
{
    ERL_NIF_TERM ret;

    if(enif_make_existing_atom(env, name, &ret, ERL_NIF_LATIN1))
        return ret;

    return enif_make_atom(env, name);
}

ERL_NIF_TERM make_binary(ErlNifEnv* env, const char* buff, size_t length)
{
    ERL_NIF_TERM term;
    uint8_t *destination_buffer = enif_make_new_binary(env, length, &term);
    memcpy(destination_buffer, buff, length);
    return term;
}

ERL_NIF_TERM make_badarg(ErlNifEnv* env)
{
    return enif_make_tuple2(env, ATOMS.atomError, ATOMS.atomBadArg);
}

bool get_boolean(ERL_NIF_TERM term, bool* val)
{
    if(enif_is_identical(term, ATOMS.atomTrue))
    {
        *val = true;
        return true;
    }

    if(enif_is_identical(term, ATOMS.atomFalse))
    {
        *val = false;
        return true;
    }

    return false;
}
