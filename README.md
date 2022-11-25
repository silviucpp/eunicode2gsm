# eunicode2gsm

[![Build Status](https://travis-ci.com/silviucpp/eunicode2gsm.svg?branch=main)](https://travis-ci.com/github/silviucpp/unicode2gsm)
[![GitHub](https://img.shields.io/github/license/silviucpp/eunicode2gsm)](https://github.com/silviucpp/unicode2gsm/blob/master/LICENSE)
[![Hex.pm](https://img.shields.io/hexpm/v/eunicode2gsm)](https://hex.pm/packages/eunicode2gsm)

## What it is ?

A library that transliterates Unicode characters outside GSM alphabet with a similar GSM-encoded character. This helps ensure that your message gets segmented at 160 characters and saves you from sending multiple message segments, which increases your spend.

When Unicode characters are used in an SMS message, they must be encoded as UCS-2. However, UCS-2 characters take 16 bits to encode, so when a message includes a Unicode character, it will be split or segmented between the 70th and 71st characters. This is shorter than the 160-character per message segment that you get with GSM-7 character encoding.

For example, sometimes a Unicode character such as a smart quote `〞`, a long dash `—`, or a Unicode whitespace accidentally slips into your carefully crafted 125-character message. Now, your message is segmented and priced at two messages instead of one.

## Quick start

Getting all deps and compile:

```sh
rebar3 compile
```

Optionally you can specify into `sys.config` if you want to transliterate also the extended GSM charset using `transliterate_extended_gsm_charset` option (`false` by default).

Extended GSM charset symbols are escaped so each one will count as 2 characters. For the symbols that have a decent GSM-encoded replacement 
you can optionally enable transliteration using transliterate_gsm_extended parameter and these symbols will be mapped as follows:

- `{` -> `(`
- `}` -> `)`
- `[` -> `(`
- `]` -> `)`
- `~` -> `-`

Example:

```erlang
[
    {eunicode2gsm, [
        {transliterate_extended_gsm_charset, false}
    ]}
].
```

## API

The library accepts only utf8 encoded binaries. If you are not familiar with how erlang handle unicode please check:

- https://imteemu.wordpress.com/2011/10/31/string-encodings-in-erlang/
- https://adoptingerlang.org/docs/development/hard_to_get_right/

### Check if a string requires transliteration

```erlang
eunicode2gsm:requires_transliteration(<<"utf8 binary here"/utf8>>).
```

### Perform transliteration

```erlang
eunicode2gsm:transliterate(<<"utf8 binary here"/utf8>>).
```

## Running tests

```sh
rebar3 ct
```
