#ifndef C_SRC_MACROS_H_
#define C_SRC_MACROS_H_

#define UNUSED(expr) do { (void)(expr); } while (0)

#ifdef NDEBUG
#define ASSERT(x) UNUSED(x)
#else
#include <assert.h>
#define ASSERT(x) assert(x)
#endif

#endif
