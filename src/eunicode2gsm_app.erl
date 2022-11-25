-module(eunicode2gsm_app).

-behaviour(application).

-export([
    start/2,
    stop/1
]).

start(_StartType, _StartArgs) ->
    case eunicode2gsm_utils:env(transliterate_extended_gsm_charset) of
        undefined ->
            true = eunicode2gsm_nif:init_transliteration_map(false);
        Value ->
            true = eunicode2gsm_nif:init_transliteration_map(Value)
    end,
    eunicode2gsm_sup:start_link().

stop(_State) ->
    ok.
