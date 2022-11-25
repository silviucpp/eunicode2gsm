#ifndef C_SRC_NIF_UTILS_H_
#define C_SRC_NIF_UTILS_H_

#include <stdint.h>
#include "erl_nif.h"

ERL_NIF_TERM make_atom(ErlNifEnv* env, const char* name);
ERL_NIF_TERM make_badarg(ErlNifEnv* env);
ERL_NIF_TERM make_binary(ErlNifEnv* env, const char* buff, size_t length);
bool get_boolean(ERL_NIF_TERM term, bool* val);

#endif
