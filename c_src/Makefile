
PROJECT_NIF_NAME=eunicode2gsm_nif

include nif.mk

ifeq ($(UNAME_SYS), darwin)
	LDFLAGS +=  -Wl,-U,_enif_is_binary \
				-Wl,-U,_enif_inspect_binary \
				-Wl,-U,_enif_is_identical \
				-Wl,-U,_enif_make_atom \
				-Wl,-U,_enif_make_existing_atom \
				-Wl,-U,_enif_make_new_binary \
				-Wl,-U,_enif_make_tuple
endif

CXXFLAGS += -I../_build/deps/unicode2gsm/include \
			-DNDEBUG \
			-g -Wextra -Werror -Wno-missing-field-initializers -fno-exceptions -fno-rtti \
			 -std=c++11

LDFLAGS += -L../_build/deps/unicode2gsm/build \
			-lunicode2gsm \
			-lstdc++
