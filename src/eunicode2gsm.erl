-module(eunicode2gsm).

-export([
    requires_transliteration/1,
    transliterate/1
]).

-spec requires_transliteration(binary()) ->
    boolean() | {error, any()}.

requires_transliteration(Bin) ->
    case eunicode2gsm_utils:validate_utf8(Bin) of
        true ->
            eunicode2gsm_nif:requires_transliteration(Bin);
        _ ->
            {error, <<"input string should be utf8 encoded">>}
    end.

-spec transliterate(binary()) ->
    binary() | {error, any()}.

transliterate(Bin) ->
    case eunicode2gsm_utils:validate_utf8(Bin) of
        true ->
            eunicode2gsm_nif:transliterate(Bin);
        _ ->
            {error, <<"input string should be utf8 encoded">>}
    end.
