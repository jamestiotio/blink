#-*-mode:makefile-gmake;indent-tabs-mode:t;tab-width:8;coding:utf-8-*-┐
#───vi: set et ft=make ts=8 tw=8 fenc=utf-8 :vi───────────────────────┘

TAGS ?= /usr/bin/ctags

CFLAGS +=				\
	-g				\
	-O2				\
	-Wall				\
	-pthread			\
	-fno-ident			\
	-fno-common			\
	-fstrict-aliasing		\
	-fstrict-overflow		\
	-Wno-unused-function		\
	-Wno-unused-const-variable	\
	-Wno-unused-function

CPPFLAGS +=				\
	-iquote.			\
	-D_POSIX_C_SOURCE=200809L	\
	-D_XOPEN_SOURCE=700		\
	-D_DARWIN_C_SOURCE		\
	-D_DEFAULT_SOURCE		\
	-D_BSD_SOURCE			\
	-D_GNU_SOURCE

LDLIBS +=				\
	-lm				\
	-pthread

TAGSFLAGS =				\
	-e				\
	-a				\
	--if0=no			\
	--langmap=c:.c.h.i		\
	--line-directives=yes

ifeq ($(USER),jart)
CFLAGS += -Werror
endif

ifeq ($(MODE), rel)
CPPFLAGS += -DNDEBUG
CFLAGS += -std=c11 -O2
endif

ifeq ($(MODE), opt)
CPPFLAGS += -DNDEBUG
CFLAGS += -std=c11 -O3 -march=native
endif

# ifeq ($(MODE), opt)
# CC = clang
# AR = llvm-ar
# CPPFLAGS += -DNDEBUG
# CFLAGS += -std=c11 -O3
# TARGET_ARCH = -march=native
# endif

ifeq ($(MODE), dbg)
CFLAGS += -std=c11 -O0
CPPFLAGS += -DDEBUG
endif

ifeq ($(MODE), asan)
CFLAGS += -std=c11 -O0
CPPFLAGS += -DDEBUG
CPPFLAGS += -fsanitize=address
LDLIBS += -fsanitize=address
endif

ifeq ($(MODE), ubsan)
CC = clang++
AR = llvm-ar
CPPFLAGS += -DDEBUG
CFLAGS += -xc++ -Werror -Wno-unused-parameter -Wno-missing-field-initializers
LDFLAGS += -fuse-ld=lld
CFLAGS += -fsanitize=undefined
LDLIBS += -fsanitize=undefined
endif

ifeq ($(MODE), tsan)
CC = clang++
AR = llvm-ar
CPPFLAGS +=
CFLAGS += -xc++ -Werror -Wno-unused-parameter -Wno-missing-field-initializers
LDFLAGS += -fuse-ld=lld
CFLAGS += -fsanitize=thread
LDLIBS += -fsanitize=thread
endif

ifeq ($(MODE), msan)
CC = clang++
AR = llvm-ar
CPPFLAGS += -DDEBUG
CFLAGS += -xc++ -Werror -Wno-unused-parameter -Wno-missing-field-initializers
LDFLAGS += -fuse-ld=lld
CFLAGS += -fsanitize=memory
LDLIBS += -fsanitize=memory
endif

ifeq ($(MODE), tiny)
CPPFLAGS += -DNDEBUG  -DTINY
CFLAGS += -std=c11 -Os -fno-align-functions -fno-align-jumps -fno-align-labels -fno-align-loops -fno-pie
LDFLAGS += -no-pie -Wl,--cref,-Map=$@.map
endif

# ifeq ($(MODE), tiny)
# CC = clang
# AR = llvm-ar
# CPPFLAGS += -DNDEBUG -DTINY
# CFLAGS += -std=c11 -Oz -fno-pie
# LDFLAGS += -no-pie -Wl,--cref,-Map=$@.map
# endif
