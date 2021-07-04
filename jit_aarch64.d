extern (C):

enum JIT_HASH_CONSTS = 0;
enum JIT_NUM_OPERANDS = 3;

/*
 * Types
 */
enum JIT_FP = jit_reg_t._R29;

enum jit_reg_t
{
    _R8 = 0, /* indirect result */
    _R18 = 1, /* platform register */
    _R17 = 2, /* IP1 */
    _R16 = 3, /* IP0 */
    _R9 = 4,
    _R10 = 5,
    _R11 = 6,
    _R12 = 7, /* temporaries */
    _R13 = 8,
    _R14 = 9,
    _R15 = 10,

    _R19 = 11,
    _R20 = 12,
    _R21 = 13,
    _R22 = 14, /* callee save */
    _R23 = 15,
    _R24 = 16,
    _R25 = 17,
    _R26 = 18,
    _R27 = 19,
    _R28 = 20,
    _SP = 21, /* stack pointer */
    _R30 = 22, /* link register */
    _R29 = 23, /* frame pointer */
    _R7 = 24,
    _R6 = 25,
    _R5 = 26,
    _R4 = 27,
    _R3 = 28,
    _R2 = 29,
    _R1 = 30,
    _R0 = 31,

    _V31 = 32,
    _V30 = 33,
    _V29 = 34,
    _V28 = 35, /* temporaries */
    _V27 = 36,
    _V26 = 37,
    _V25 = 38,
    _V24 = 39,
    _V23 = 40,
    _V22 = 41,
    _V21 = 42,
    _V20 = 43,
    _V19 = 44,
    _V18 = 45,
    _V17 = 46,
    _V16 = 47,
    /* callee save */
    _V8 = 48,
    _V9 = 49,
    _V10 = 50,
    _V11 = 51,
    _V12 = 52,
    _V13 = 53,
    _V14 = 54,
    _V15 = 55,
    _V7 = 56,
    _V6 = 57,
    _V5 = 58,
    _V4 = 59, /* arguments */
    _V3 = 60,
    _V2 = 61,
    _V1 = 62,
    _V0 = 63,
    _NOREG = 64
}

extern (D) auto jit_r(T)(auto ref T i)
{
    return jit_reg_t._R9 + i;
}

extern (D) int jit_r_num()
{
    return 7;
}

extern (D) auto jit_v(T)(auto ref T i)
{
    return jit_reg_t._R19 + i;
}

extern (D) int jit_v_num()
{
    return 10;
}

extern (D) auto jit_f(T)(auto ref T i)
{
    return jit_reg_t._V8 + i;
}

extern (D) int jit_f_num()
{
    return 8;
}

enum JIT_R0 = jit_reg_t._R9;
enum JIT_R1 = jit_reg_t._R10;
enum JIT_R2 = jit_reg_t._R11;
enum JIT_R3 = jit_reg_t._R12;
enum JIT_R4 = jit_reg_t._R13;
enum JIT_R5 = jit_reg_t._R14;
enum JIT_R6 = jit_reg_t._R15;
enum JIT_V0 = jit_reg_t._R19;
enum JIT_V1 = jit_reg_t._R20;
enum JIT_V2 = jit_reg_t._R21;
enum JIT_V3 = jit_reg_t._R22;
enum JIT_V4 = jit_reg_t._R23;
enum JIT_V5 = jit_reg_t._R24;
enum JIT_V6 = jit_reg_t._R25;
enum JIT_V7 = jit_reg_t._R26;
enum JIT_V8 = jit_reg_t._R27;
enum JIT_V9 = jit_reg_t._R28;
enum JIT_F0 = jit_reg_t._V8;
enum JIT_F1 = jit_reg_t._V9;
enum JIT_F2 = jit_reg_t._V10;
enum JIT_F3 = jit_reg_t._V11;
enum JIT_F4 = jit_reg_t._V12;
enum JIT_F5 = jit_reg_t._V13;
enum JIT_F6 = jit_reg_t._V14;
enum JIT_F7 = jit_reg_t._V15;
enum JIT_NOREG = jit_reg_t._NOREG;

/* _jit_aarch64_h */
