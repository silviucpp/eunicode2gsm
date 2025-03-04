-module(eunicode2gsm_nif).

-define(NOT_LOADED, not_loaded(?LINE)).

-on_load(load_nif/0).

-export([
    init_transliteration_map/1,
    requires_transliteration/1,
    transliterate/1
]).

init_transliteration_map(_TransliterateGsmExtended)->
    ?NOT_LOADED.

requires_transliteration(_Bin) ->
    ?NOT_LOADED.

transliterate(_Bin) ->
    ?NOT_LOADED.

% internals

load_nif() ->
    ok = erlang:load_nif(get_priv_path(?MODULE), 0).

get_priv_path(File) ->
    case code:priv_dir(eunicode2gsm) of
        {error, bad_name} ->
            Ebin = filename:dirname(code:which(?MODULE)),
            filename:join([filename:dirname(Ebin), "priv", File]);
        Dir ->
            filename:join(Dir, File)
    end.

not_loaded(Line) ->
    erlang:nif_error({not_loaded, [{module, ?MODULE}, {line, Line}]}).
