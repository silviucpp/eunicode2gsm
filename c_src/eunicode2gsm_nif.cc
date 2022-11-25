#include "eunicode2gsm_nif.h"
#include "nif_utils.h"
#include "macros.h"

#include <unicode2gsm/unicode2gsm.h>

namespace {

const char kAtomTrue[] = "true";
const char kAtomFalse[] = "false";
const char kAtomError[] = "error";
const char kAtomBadArg[] = "badarg";

ERL_NIF_TERM enif_init_transliteration_map(ErlNifEnv* env, int argc, const ERL_NIF_TERM argv[])
{
    UNUSED(argc);

    bool transliterate_extended_alphabet;

    if(!get_boolean(argv[0], &transliterate_extended_alphabet))
        return make_badarg(env);

    if(unicode2gsm::init_transliteration_map(transliterate_extended_alphabet))
        return ATOMS.atomTrue;

    return ATOMS.atomFalse;
}

ERL_NIF_TERM enif_requires_transliteration(ErlNifEnv* env, int argc, const ERL_NIF_TERM argv[])
{
    UNUSED(argc);

    ErlNifBinary bin;

    if(!enif_inspect_binary(env, argv[0], &bin))
        return make_badarg(env);

    if(unicode2gsm::requires_transliteration(reinterpret_cast<const char*>(bin.data), bin.size))
        return ATOMS.atomTrue;

    return ATOMS.atomFalse;
}

ERL_NIF_TERM enif_transliterate(ErlNifEnv* env, int argc, const ERL_NIF_TERM argv[])
{
    UNUSED(argc);

    ErlNifBinary bin;

    if(!enif_inspect_binary(env, argv[0], &bin))
        return make_badarg(env);

    std::string output = unicode2gsm::transliterate(reinterpret_cast<const char*>(bin.data), bin.size);

    return make_binary(env, output.data(), output.length());
}

ErlNifFunc nif_funcs[] = {
    {"init_transliteration_map", 1, enif_init_transliteration_map},
    {"requires_transliteration", 1, enif_requires_transliteration},
    {"transliterate", 1, enif_transliterate}
};

}

atoms ATOMS;

int on_nif_load(ErlNifEnv* env, void** priv_data, ERL_NIF_TERM load_info)
{
    UNUSED(env);
    UNUSED(load_info);

    ATOMS.atomTrue = make_atom(env, kAtomTrue);
    ATOMS.atomFalse = make_atom(env, kAtomFalse);
    ATOMS.atomError = make_atom(env, kAtomError);
    ATOMS.atomBadArg = make_atom(env, kAtomBadArg);

    *priv_data = nullptr;
    return 0;
}

int on_nif_upgrade(ErlNifEnv* env, void** priv, void** old_priv, ERL_NIF_TERM info)
{
    UNUSED(env);
    UNUSED(old_priv);
    UNUSED(info);
    *priv = nullptr;
    return 0;
}

void on_nif_unload(ErlNifEnv* env, void* priv_data)
{
    UNUSED(env);
    UNUSED(priv_data);
}

ERL_NIF_INIT(eunicode2gsm_nif, nif_funcs, on_nif_load, NULL, on_nif_upgrade, on_nif_unload)
