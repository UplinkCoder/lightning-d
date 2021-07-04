/*
 * Copyright (C) 2012-2019  Free Software Foundation, Inc.
 *
 * This file is part of GNU lightning.
 *
 * GNU lightning is free software; you can redistribute it and/or modify it
 * under the terms of the GNU Lesser General Public License as published
 * by the Free Software Foundation; either version 3, or (at your option)
 * any later version.
 *
 * GNU lightning is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
 * or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU Lesser General Public
 * License for more details.
 *
 * Authors:
 *	Paulo Cesar Pereira de Andrade
 */

extern (C):

enum JIT_HASH_CONSTS = 1;
enum JIT_NUM_OPERANDS = 2;

alias jit_uint32_t = uint;
/*
 * Types
 */
extern (D) auto jit_sse2_p()
{
    return jit_cpu.sse2;
}

extern (D) auto jit_x87_reg_p(T)(auto ref T reg)
{
    return reg >= jit_reg_t._ST0 && reg <= jit_reg_t._ST6;
}

enum __X64 = 1;

enum JIT_FP = jit_reg_t._RBP;

enum jit_reg_t
{
    /* Volatile - Return value register */

    /* Volatile */

    /* Nonvolatile */

    /* Volatile - Integer arguments (4 to 1) */

    /* Nonvolatile */

    /* Volatile */

    /* Nonvolatile */

    /* Volatile - FP arguments (4 to 1) */

    _RAX = 0,
    _R10 = 1,
    _R11 = 2,

    _RBX = 3,
    _R13 = 4,
    _R14 = 5,
    _R15 = 6,
    _R12 = 7,
    _R9 = 8,
    _R8 = 9,
    _RCX = 10,
    _RDX = 11,
    _RSI = 12,
    _RDI = 13,
    _RSP = 14,
    _RBP = 15,

    _XMM8 = 16,
    _XMM9 = 17,
    _XMM10 = 18,
    _XMM11 = 19,
    _XMM12 = 20,
    _XMM13 = 21,
    _XMM14 = 22,
    _XMM15 = 23,
    _XMM7 = 24,
    _XMM6 = 25,
    _XMM5 = 26,
    _XMM4 = 27,
    _XMM3 = 28,
    _XMM2 = 29,
    _XMM1 = 30,
    _XMM0 = 31,

    _ST0 = 32,
    _ST1 = 33,
    _ST2 = 34,
    _ST3 = 35,
    _ST4 = 36,
    _ST5 = 37,
    _ST6 = 38,

    _NOREG = 39
}

extern (D) auto jit_r(T)(auto ref T i)
{
    return jit_reg_t._RAX + i;
}

extern (D) int jit_r_num()
{
    return 3;
}

extern (D) auto jit_v(T)(auto ref T i)
{
    return jit_reg_t._RBX + i;
}

extern (D) int jit_v_num()
{
    return 5;
}

extern (D) auto jit_f(T)(auto ref T index)
{
    return jit_reg_t._XMM8 + index;
}

extern (D) int jit_f_num()
{
    return 8;
}

enum JIT_R0 = jit_reg_t._RAX;
enum JIT_R1 = jit_reg_t._R10;
enum JIT_R2 = jit_reg_t._R11;
enum JIT_V0 = jit_reg_t._RBX;
enum JIT_V1 = jit_reg_t._R13;
enum JIT_V2 = jit_reg_t._R14;
enum JIT_V3 = jit_reg_t._R15;
enum JIT_V4 = jit_reg_t._R12;
enum JIT_F0 = jit_reg_t._XMM8;
enum JIT_F1 = jit_reg_t._XMM9;
enum JIT_F2 = jit_reg_t._XMM10;
enum JIT_F3 = jit_reg_t._XMM11;
enum JIT_F4 = jit_reg_t._XMM12;
enum JIT_F5 = jit_reg_t._XMM13;
enum JIT_F6 = jit_reg_t._XMM14;
enum JIT_F7 = jit_reg_t._XMM15;

extern (D) auto jit_sse_reg_p(T)(auto ref T reg)
{
    return reg >= jit_reg_t._XMM8 && reg <= jit_reg_t._XMM0;
}

enum JIT_NOREG = jit_reg_t._NOREG;

struct jit_cpu_t
{
    import std.bitmanip : bitfields;

    mixin(bitfields!(
        uint, "fpu", 1,
        uint, "cmpxchg8b", 1,
        uint, "cmov", 1,
        uint, "mmx", 1,
        uint, "sse", 1,
        uint, "sse2", 1,
        uint, "sse3", 1,
        uint, "pclmulqdq", 1,
        uint, "ssse3", 1,
        uint, "fma", 1,
        uint, "cmpxchg16b", 1,
        uint, "sse4_1", 1,
        uint, "sse4_2", 1,
        uint, "movbe", 1,
        uint, "popcnt", 1,
        uint, "aes", 1,
        uint, "avx", 1,
        uint, "lahf", 1,
        uint, "", 14));

    /* x87 present */

    /* cmpxchg8b instruction */

    /* cmov and fcmov branchless conditional mov */

    /* mmx registers/instructions available */

    /* sse registers/instructions available */

    /* sse2 registers/instructions available */

    /* sse3 instructions available */

    /* pcmulqdq instruction */

    /* ssse3 suplemental sse3 instructions available */

    /* fused multiply/add using ymm state */

    /* cmpxchg16b instruction */

    /* sse4.1 instructions available */

    /* sse4.2 instructions available */

    /* movbe instruction available */

    /* popcnt instruction available */

    /* aes instructions available */

    /* avx instructions available */

    /* lahf/sahf available in 64 bits mode */
}

/*
 * Initialization
 */
extern __gshared jit_cpu_t jit_cpu;

/* _jit_x86_h */
