-module(integrity_test_SUITE).

-include_lib("common_test/include/ct.hrl").
-include_lib("stdlib/include/assert.hrl").

-define(GSM_ALPHABET_NO_UTF8, <<"@£$¥èéùìòÇØøÅåΔ_ΦΓΛΩΠΨΣΘΞÆæßÉ!\"#¤%&'()*+,-./0123456789:;<=>?¡ABCDEFGHIJKLMNOPQRSTUVWXYZÄÖÑÜ§¿abcdefghijklmnopqrstuvwxyzäöñüà^{}\[~]|€">>).
-define(GSM_ALPHABET_UTF8, <<"@£$¥èéùìòÇØøÅåΔ_ΦΓΛΩΠΨΣΘΞÆæßÉ!\"#¤%&'()*+,-./0123456789:;<=>?¡ABCDEFGHIJKLMNOPQRSTUVWXYZÄÖÑÜ§¿abcdefghijklmnopqrstuvwxyzäöñüà^{}\[~]|€"/utf8>>).

-compile(export_all).

all() -> [
    {group, eunicode2gsm}
].

groups() -> [
    {eunicode2gsm, [sequence], [
        test_utf8_check,
        tes_no_utf8_input,
        test_no_transliteration,
        test_transliteration,
        test_new_line_and_tabs_normalization
    ]}
].

init_per_suite(Config) ->
    application:ensure_all_started(eunicode2gsm),
    Config.

end_per_suite(_Config) ->
    ok.

test_utf8_check(_Config) ->
    ?assertEqual(false, eunicode2gsm_utils:validate_utf8(?GSM_ALPHABET_NO_UTF8)),
    ?assertEqual(true, eunicode2gsm_utils:validate_utf8(?GSM_ALPHABET_UTF8)),
    ok.

tes_no_utf8_input(_Config) ->
    ?assertMatch({error, _}, eunicode2gsm:requires_transliteration(?GSM_ALPHABET_NO_UTF8)),
    ?assertMatch({error, _}, eunicode2gsm:transliterate(?GSM_ALPHABET_NO_UTF8)),
    ok.

test_no_transliteration(_Config) ->
    ?assertEqual(true, eunicode2gsm_nif:init_transliteration_map(false)),
    ?assertEqual(false, eunicode2gsm:requires_transliteration(?GSM_ALPHABET_UTF8)),
    ?assertEqual(?GSM_ALPHABET_UTF8, eunicode2gsm:transliterate(?GSM_ALPHABET_UTF8)),
    ok.

test_transliteration(_Config) ->
    ?assertEqual(true, eunicode2gsm_nif:init_transliteration_map(true)),
    ?assertEqual(true, eunicode2gsm:requires_transliteration(?GSM_ALPHABET_UTF8)),
    ?assertEqual(<<"@£$¥èéùìòÇØøÅåΔ_ΦΓΛΩΠΨΣΘΞÆæßÉ!\"#¤%&'()*+,-./0123456789:;<=>?¡ABCDEFGHIJKLMNOPQRSTUVWXYZÄÖÑÜ§¿abcdefghijklmnopqrstuvwxyzäöñüà^()\(-)|€"/utf8>>, eunicode2gsm:transliterate(?GSM_ALPHABET_UTF8)),
    ok.

test_new_line_and_tabs_normalization(_Config) ->
    ?assertEqual(true, eunicode2gsm_nif:init_transliteration_map(false)),
    BinInput = <<"@\n£\r\n$\t¥\f˜〜\r"/utf8>>,
    ?assertEqual(true, eunicode2gsm:requires_transliteration(BinInput)),
    ?assertEqual(<<"@\n£\n$ ¥ ~~\r"/utf8>>, eunicode2gsm:transliterate(BinInput)),
    ok.
