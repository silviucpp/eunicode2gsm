# eunicode2gsm

[![Build Status](https://app.travis-ci.com/silviucpp/eunicode2gsm.svg?branch=main)](https://travis-ci.com/github/silviucpp/unicode2gsm)
[![GitHub](https://img.shields.io/github/license/silviucpp/eunicode2gsm)](https://github.com/silviucpp/unicode2gsm/blob/master/LICENSE)
[![Hex.pm](https://img.shields.io/hexpm/v/eunicode2gsm)](https://hex.pm/packages/eunicode2gsm)

## What it is ?

A library that transliterates Unicode characters outside GSM alphabet with a similar GSM-encoded character. This helps ensure that your message gets segmented at 160 characters and saves you from sending multiple message segments, which increases your spend.

When Unicode characters are used in an SMS message, they must be encoded as UCS-2. However, UCS-2 characters take 16 bits to encode, so when a message includes a Unicode character, it will be split or segmented between the 70th and 71st characters. This is shorter than the 160-character per message segment that you get with GSM-7 character encoding.

For example, sometimes a Unicode character such as a smart quote `〞`, a long dash `—`, or a Unicode whitespace accidentally slips into your carefully crafted 125-character message. Now, your message is segmented and priced at two messages instead of one.

Currently, the library transliterates symbols into the following Unicode Character Sets:

|Start  |End    |Character Set                  |
|:-----:|:-----:|:------------------------------|
|0x0000 | 0x007F| Basic Latin                   |
|0x0080 | 0x00FF| Latin-1 Supplement            |
|0x0100 | 0x017F| Latin Extended-A              |
|0x0180 | 0x024F| Latin Extended-B              |
|0x0250 | 0x02AF| IPA Extensions                |
|0x02B0 | 0x02FF| Spacing Modifier Letters      |
|0x0300 | 0x036F| Combining Diacritical Marks   |
|0x0370 | 0x03FF| Greek and Coptic              |
|0x1D00 | 0x1D7F| Phonetic Extensions           |
|0x1D80 | 0x1DBF| Phonetic Extensions Supplement|
|0x1E00 | 0x1EFF| Latin Extended Additional     |
|0x1F00 | 0x1FFF| Greek Extended                |
|0x2000 | 0x206F| General Punctuation           |
|0x2070 | 0x209F| Superscripts and Subscripts   |
|0x20A0 | 0x20CF| Currency Symbols              |
|0x2100 | 0x214F| Letterlike Symbols            |
|0x2150 | 0x218F| Number Forms                  |
|0x2190 | 0x21FF| Arrows                        |
|0x2700 | 0x27BF| Dingbats                      |
|0x27F0 | 0x27FF| Supplemental Arrows-A         |
|0x2900 | 0x297F| Supplemental Arrows-B         |
|0x2C60 | 0x2C7F| Latin Extended-C              |
|0x3000 | 0x303F| CJK Symbols and Punctuation   |
|0xFE10 | 0xFE1F| Vertical Forms                |
|0xFE50 | 0xFE6F| Small Form Variants           |
|0xFF00 | 0xFFEF| Halfwidth and Fullwidth Forms |

Also the transliteration process is replacing all the `CRLF` (`\r\n`) sequences into `\n`.

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
