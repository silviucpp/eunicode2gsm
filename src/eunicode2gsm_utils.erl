-module(eunicode2gsm_utils).

-export([
    env/1,
    validate_utf8/1
]).

env(Attr) ->
    case application:get_env(eunicode2gsm, Attr) of
        {ok, Value} ->
            Value;
        _ ->
            undefined
    end.

validate_utf8(Bin) ->
    validate_utf8(Bin, 0) =:= 0.

% internals

% based on https://ninenines.eu/articles/erlang-validate-utf8/
% this function returns 0 on success, 1 on error, and 2..8 on incomplete data.
validate_utf8(<<>>, State) ->
    State;
validate_utf8(<< C, Rest/bits >>, 0) when C < 128 -> validate_utf8(Rest, 0);
validate_utf8(<< C, Rest/bits >>, 2) when C >= 128, C < 144 -> validate_utf8(Rest, 0);
validate_utf8(<< C, Rest/bits >>, 3) when C >= 128, C < 144 -> validate_utf8(Rest, 2);
validate_utf8(<< C, Rest/bits >>, 5) when C >= 128, C < 144 -> validate_utf8(Rest, 2);
validate_utf8(<< C, Rest/bits >>, 7) when C >= 128, C < 144 -> validate_utf8(Rest, 3);
validate_utf8(<< C, Rest/bits >>, 8) when C >= 128, C < 144 -> validate_utf8(Rest, 3);
validate_utf8(<< C, Rest/bits >>, 2) when C >= 144, C < 160 -> validate_utf8(Rest, 0);
validate_utf8(<< C, Rest/bits >>, 3) when C >= 144, C < 160 -> validate_utf8(Rest, 2);
validate_utf8(<< C, Rest/bits >>, 5) when C >= 144, C < 160 -> validate_utf8(Rest, 2);
validate_utf8(<< C, Rest/bits >>, 6) when C >= 144, C < 160 -> validate_utf8(Rest, 3);
validate_utf8(<< C, Rest/bits >>, 7) when C >= 144, C < 160 -> validate_utf8(Rest, 3);
validate_utf8(<< C, Rest/bits >>, 2) when C >= 160, C < 192 -> validate_utf8(Rest, 0);
validate_utf8(<< C, Rest/bits >>, 3) when C >= 160, C < 192 -> validate_utf8(Rest, 2);
validate_utf8(<< C, Rest/bits >>, 4) when C >= 160, C < 192 -> validate_utf8(Rest, 2);
validate_utf8(<< C, Rest/bits >>, 6) when C >= 160, C < 192 -> validate_utf8(Rest, 3);
validate_utf8(<< C, Rest/bits >>, 7) when C >= 160, C < 192 -> validate_utf8(Rest, 3);
validate_utf8(<< C, Rest/bits >>, 0) when C >= 194, C < 224 -> validate_utf8(Rest, 2);
validate_utf8(<< 224, Rest/bits >>, 0) -> validate_utf8(Rest, 4);
validate_utf8(<< C, Rest/bits >>, 0) when C >= 225, C < 237 -> validate_utf8(Rest, 3);
validate_utf8(<< 237, Rest/bits >>, 0) -> validate_utf8(Rest, 5);
validate_utf8(<< C, Rest/bits >>, 0) when C =:= 238; C =:= 239 -> validate_utf8(Rest, 3);
validate_utf8(<< 240, Rest/bits >>, 0) -> validate_utf8(Rest, 6);
validate_utf8(<< C, Rest/bits >>, 0) when C =:= 241; C =:= 242; C =:= 243 -> validate_utf8(Rest, 7);
validate_utf8(<< 244, Rest/bits >>, 0) -> validate_utf8(Rest, 8);
validate_utf8(_, _) -> 1.
