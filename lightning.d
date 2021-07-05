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

import core.stdc.config;
import core.stdc.string;
import core.sys.posix.unistd;

extern (C):

alias jit_int8_t = byte;
alias jit_uint8_t = ubyte;
alias jit_int16_t = short;
alias jit_uint16_t = ushort;
alias jit_int32_t = int;
alias jit_uint32_t = uint;

alias jit_int64_t = c_long;
alias jit_uint64_t = c_ulong;
alias jit_word_t = c_long;
alias jit_uword_t = c_ulong;

alias jit_float32_t = float;
alias jit_float64_t = double;
alias jit_pointer_t = void*;
alias jit_bool_t = int;
alias jit_gpr_t = int;
alias jit_fpr_t = int;

enum jit_flag_node = 0x0001; /* patch node not absolute */
enum jit_flag_patch = 0x0002; /* jump already patched */
enum jit_flag_data = 0x0004; /* data in the constant pool */
enum jit_flag_use = 0x0008; /* do not remove marker label */
enum jit_flag_synth = 0x0010; /* synthesized instruction */
enum jit_flag_head = 0x1000; /* label reached by normal flow */
enum jit_flag_varargs = 0x2000; /* call{r,i} to varargs function */

//alias JIT_R = jit_r;
//alias JIT_V = jit_v;
//alias JIT_F = jit_f;
//enum JIT_R_NUM = jit_r_num();
//enum JIT_V_NUM = jit_v_num();
//enum JIT_F_NUM = jit_f_num();

enum JIT_DISABLE_DATA = 1; /* force synthesize of constants */
enum JIT_DISABLE_NOTE = 2; /* disable debug info generation */

enum jit_class_chk = 0x02000000; /* just checking */
enum jit_class_arg = 0x08000000; /* argument register */
enum jit_class_sav = 0x10000000; /* callee save */
enum jit_class_gpr = 0x20000000; /* general purpose */
enum jit_class_fpr = 0x40000000; /* float */
extern (D) auto jit_class(T)(auto ref T reg)
{
    return reg & 0xffff0000;
}

extern (D) auto jit_regno(T)(auto ref T reg)
{
    return reg & 0x00007fff;
}

struct jit_node;
alias jit_node_t = jit_node;
struct jit_state;
alias jit_state_t = jit_state;

enum jit_code_t
{
    jit_code_data = 0,

    jit_code_live = 1,
    jit_code_align = 2,
    jit_code_save = 3,
    jit_code_load = 4,

    jit_code_name = 5,

    jit_code_note = 6,
    jit_code_label = 7,

    jit_code_prolog = 8,

    jit_code_ellipsis = 9,

    jit_code_va_push = 10,

    jit_code_allocai = 11,
    jit_code_allocar = 12,

    jit_code_arg = 13,

    jit_code_getarg_c = 14,
    jit_code_getarg_uc = 15,

    jit_code_getarg_s = 16,
    jit_code_getarg_us = 17,

    jit_code_getarg_i = 18,
    jit_code_getarg_ui = 19,
    jit_code_getarg_l = 20,

    jit_code_putargr = 21,
    jit_code_putargi = 22,

    jit_code_va_start = 23,

    jit_code_va_arg = 24,
    jit_code_va_arg_d = 25,

    jit_code_va_end = 26,

    jit_code_addr = 27,
    jit_code_addi = 28,

    jit_code_addcr = 29,
    jit_code_addci = 30,

    jit_code_addxr = 31,
    jit_code_addxi = 32,

    jit_code_subr = 33,
    jit_code_subi = 34,

    jit_code_subcr = 35,
    jit_code_subci = 36,

    jit_code_subxr = 37,
    jit_code_subxi = 38,

    jit_code_rsbi = 39,

    jit_code_mulr = 40,
    jit_code_muli = 41,

    jit_code_qmulr = 42,
    jit_code_qmuli = 43,

    jit_code_qmulr_u = 44,
    jit_code_qmuli_u = 45,

    jit_code_divr = 46,
    jit_code_divi = 47,

    jit_code_divr_u = 48,
    jit_code_divi_u = 49,

    jit_code_qdivr = 50,
    jit_code_qdivi = 51,

    jit_code_qdivr_u = 52,
    jit_code_qdivi_u = 53,

    jit_code_remr = 54,
    jit_code_remi = 55,

    jit_code_remr_u = 56,
    jit_code_remi_u = 57,

    jit_code_andr = 58,
    jit_code_andi = 59,

    jit_code_orr = 60,
    jit_code_ori = 61,

    jit_code_xorr = 62,
    jit_code_xori = 63,

    jit_code_lshr = 64,
    jit_code_lshi = 65,

    jit_code_rshr = 66,
    jit_code_rshi = 67,

    jit_code_rshr_u = 68,
    jit_code_rshi_u = 69,

    jit_code_negr = 70,
    jit_code_comr = 71,

    jit_code_ltr = 72,
    jit_code_lti = 73,

    jit_code_ltr_u = 74,
    jit_code_lti_u = 75,

    jit_code_ler = 76,
    jit_code_lei = 77,

    jit_code_ler_u = 78,
    jit_code_lei_u = 79,

    jit_code_eqr = 80,
    jit_code_eqi = 81,

    jit_code_ger = 82,
    jit_code_gei = 83,

    jit_code_ger_u = 84,
    jit_code_gei_u = 85,

    jit_code_gtr = 86,
    jit_code_gti = 87,

    jit_code_gtr_u = 88,
    jit_code_gti_u = 89,

    jit_code_ner = 90,
    jit_code_nei = 91,

    jit_code_movr = 92,
    jit_code_movi = 93,

    jit_code_extr_c = 94,
    jit_code_extr_uc = 95,

    jit_code_extr_s = 96,
    jit_code_extr_us = 97,

    jit_code_extr_i = 98,
    jit_code_extr_ui = 99,

    jit_code_htonr_us = 100,

    jit_code_htonr_ui = 101,
    jit_code_htonr_ul = 102,

    jit_code_ldr_c = 103,
    jit_code_ldi_c = 104,

    jit_code_ldr_uc = 105,
    jit_code_ldi_uc = 106,

    jit_code_ldr_s = 107,
    jit_code_ldi_s = 108,

    jit_code_ldr_us = 109,
    jit_code_ldi_us = 110,

    jit_code_ldr_i = 111,
    jit_code_ldi_i = 112,

    jit_code_ldr_ui = 113,
    jit_code_ldi_ui = 114,
    jit_code_ldr_l = 115,
    jit_code_ldi_l = 116,

    jit_code_ldxr_c = 117,
    jit_code_ldxi_c = 118,

    jit_code_ldxr_uc = 119,
    jit_code_ldxi_uc = 120,

    jit_code_ldxr_s = 121,
    jit_code_ldxi_s = 122,

    jit_code_ldxr_us = 123,
    jit_code_ldxi_us = 124,

    jit_code_ldxr_i = 125,
    jit_code_ldxi_i = 126,

    jit_code_ldxr_ui = 127,
    jit_code_ldxi_ui = 128,
    jit_code_ldxr_l = 129,
    jit_code_ldxi_l = 130,

    jit_code_str_c = 131,
    jit_code_sti_c = 132,

    jit_code_str_s = 133,
    jit_code_sti_s = 134,

    jit_code_str_i = 135,
    jit_code_sti_i = 136,

    jit_code_str_l = 137,
    jit_code_sti_l = 138,

    jit_code_stxr_c = 139,
    jit_code_stxi_c = 140,

    jit_code_stxr_s = 141,
    jit_code_stxi_s = 142,

    jit_code_stxr_i = 143,
    jit_code_stxi_i = 144,

    jit_code_stxr_l = 145,
    jit_code_stxi_l = 146,

    jit_code_bltr = 147,
    jit_code_blti = 148,

    jit_code_bltr_u = 149,
    jit_code_blti_u = 150,

    jit_code_bler = 151,
    jit_code_blei = 152,

    jit_code_bler_u = 153,
    jit_code_blei_u = 154,

    jit_code_beqr = 155,
    jit_code_beqi = 156,

    jit_code_bger = 157,
    jit_code_bgei = 158,

    jit_code_bger_u = 159,
    jit_code_bgei_u = 160,

    jit_code_bgtr = 161,
    jit_code_bgti = 162,

    jit_code_bgtr_u = 163,
    jit_code_bgti_u = 164,

    jit_code_bner = 165,
    jit_code_bnei = 166,

    jit_code_bmsr = 167,
    jit_code_bmsi = 168,

    jit_code_bmcr = 169,
    jit_code_bmci = 170,

    jit_code_boaddr = 171,
    jit_code_boaddi = 172,

    jit_code_boaddr_u = 173,
    jit_code_boaddi_u = 174,

    jit_code_bxaddr = 175,
    jit_code_bxaddi = 176,

    jit_code_bxaddr_u = 177,
    jit_code_bxaddi_u = 178,

    jit_code_bosubr = 179,
    jit_code_bosubi = 180,

    jit_code_bosubr_u = 181,
    jit_code_bosubi_u = 182,

    jit_code_bxsubr = 183,
    jit_code_bxsubi = 184,

    jit_code_bxsubr_u = 185,
    jit_code_bxsubi_u = 186,

    jit_code_jmpr = 187,
    jit_code_jmpi = 188,

    jit_code_callr = 189,
    jit_code_calli = 190,

    jit_code_prepare = 191,

    jit_code_pushargr = 192,
    jit_code_pushargi = 193,

    jit_code_finishr = 194,
    jit_code_finishi = 195,

    jit_code_ret = 196,

    jit_code_retr = 197,
    jit_code_reti = 198,

    jit_code_retval_c = 199,
    jit_code_retval_uc = 200,

    jit_code_retval_s = 201,
    jit_code_retval_us = 202,

    jit_code_retval_i = 203,
    jit_code_retval_ui = 204,
    jit_code_retval_l = 205,

    jit_code_epilog = 206,

    jit_code_arg_f = 207,

    jit_code_getarg_f = 208,

    jit_code_putargr_f = 209,
    jit_code_putargi_f = 210,

    jit_code_addr_f = 211,
    jit_code_addi_f = 212,

    jit_code_subr_f = 213,
    jit_code_subi_f = 214,

    jit_code_rsbi_f = 215,

    jit_code_mulr_f = 216,
    jit_code_muli_f = 217,

    jit_code_divr_f = 218,
    jit_code_divi_f = 219,

    jit_code_negr_f = 220,
    jit_code_absr_f = 221,
    jit_code_sqrtr_f = 222,

    jit_code_ltr_f = 223,
    jit_code_lti_f = 224,

    jit_code_ler_f = 225,
    jit_code_lei_f = 226,

    jit_code_eqr_f = 227,
    jit_code_eqi_f = 228,

    jit_code_ger_f = 229,
    jit_code_gei_f = 230,

    jit_code_gtr_f = 231,
    jit_code_gti_f = 232,

    jit_code_ner_f = 233,
    jit_code_nei_f = 234,

    jit_code_unltr_f = 235,
    jit_code_unlti_f = 236,

    jit_code_unler_f = 237,
    jit_code_unlei_f = 238,

    jit_code_uneqr_f = 239,
    jit_code_uneqi_f = 240,

    jit_code_unger_f = 241,
    jit_code_ungei_f = 242,

    jit_code_ungtr_f = 243,
    jit_code_ungti_f = 244,

    jit_code_ltgtr_f = 245,
    jit_code_ltgti_f = 246,

    jit_code_ordr_f = 247,
    jit_code_ordi_f = 248,

    jit_code_unordr_f = 249,
    jit_code_unordi_f = 250,

    jit_code_truncr_f_i = 251,

    jit_code_truncr_f_l = 252,

    jit_code_extr_f = 253,
    jit_code_extr_d_f = 254,

    jit_code_movr_f = 255,
    jit_code_movi_f = 256,

    jit_code_ldr_f = 257,
    jit_code_ldi_f = 258,

    jit_code_ldxr_f = 259,
    jit_code_ldxi_f = 260,

    jit_code_str_f = 261,
    jit_code_sti_f = 262,

    jit_code_stxr_f = 263,
    jit_code_stxi_f = 264,

    jit_code_bltr_f = 265,
    jit_code_blti_f = 266,

    jit_code_bler_f = 267,
    jit_code_blei_f = 268,

    jit_code_beqr_f = 269,
    jit_code_beqi_f = 270,

    jit_code_bger_f = 271,
    jit_code_bgei_f = 272,

    jit_code_bgtr_f = 273,
    jit_code_bgti_f = 274,

    jit_code_bner_f = 275,
    jit_code_bnei_f = 276,

    jit_code_bunltr_f = 277,
    jit_code_bunlti_f = 278,

    jit_code_bunler_f = 279,
    jit_code_bunlei_f = 280,

    jit_code_buneqr_f = 281,
    jit_code_buneqi_f = 282,

    jit_code_bunger_f = 283,
    jit_code_bungei_f = 284,

    jit_code_bungtr_f = 285,
    jit_code_bungti_f = 286,

    jit_code_bltgtr_f = 287,
    jit_code_bltgti_f = 288,

    jit_code_bordr_f = 289,
    jit_code_bordi_f = 290,

    jit_code_bunordr_f = 291,
    jit_code_bunordi_f = 292,

    jit_code_pushargr_f = 293,
    jit_code_pushargi_f = 294,

    jit_code_retr_f = 295,
    jit_code_reti_f = 296,

    jit_code_retval_f = 297,

    jit_code_arg_d = 298,

    jit_code_getarg_d = 299,

    jit_code_putargr_d = 300,
    jit_code_putargi_d = 301,

    jit_code_addr_d = 302,
    jit_code_addi_d = 303,

    jit_code_subr_d = 304,
    jit_code_subi_d = 305,

    jit_code_rsbi_d = 306,

    jit_code_mulr_d = 307,
    jit_code_muli_d = 308,

    jit_code_divr_d = 309,
    jit_code_divi_d = 310,

    jit_code_negr_d = 311,
    jit_code_absr_d = 312,
    jit_code_sqrtr_d = 313,

    jit_code_ltr_d = 314,
    jit_code_lti_d = 315,

    jit_code_ler_d = 316,
    jit_code_lei_d = 317,

    jit_code_eqr_d = 318,
    jit_code_eqi_d = 319,

    jit_code_ger_d = 320,
    jit_code_gei_d = 321,

    jit_code_gtr_d = 322,
    jit_code_gti_d = 323,

    jit_code_ner_d = 324,
    jit_code_nei_d = 325,

    jit_code_unltr_d = 326,
    jit_code_unlti_d = 327,

    jit_code_unler_d = 328,
    jit_code_unlei_d = 329,

    jit_code_uneqr_d = 330,
    jit_code_uneqi_d = 331,

    jit_code_unger_d = 332,
    jit_code_ungei_d = 333,

    jit_code_ungtr_d = 334,
    jit_code_ungti_d = 335,

    jit_code_ltgtr_d = 336,
    jit_code_ltgti_d = 337,

    jit_code_ordr_d = 338,
    jit_code_ordi_d = 339,

    jit_code_unordr_d = 340,
    jit_code_unordi_d = 341,

    jit_code_truncr_d_i = 342,

    jit_code_truncr_d_l = 343,

    jit_code_extr_d = 344,
    jit_code_extr_f_d = 345,

    jit_code_movr_d = 346,
    jit_code_movi_d = 347,

    jit_code_ldr_d = 348,
    jit_code_ldi_d = 349,

    jit_code_ldxr_d = 350,
    jit_code_ldxi_d = 351,

    jit_code_str_d = 352,
    jit_code_sti_d = 353,

    jit_code_stxr_d = 354,
    jit_code_stxi_d = 355,

    jit_code_bltr_d = 356,
    jit_code_blti_d = 357,

    jit_code_bler_d = 358,
    jit_code_blei_d = 359,

    jit_code_beqr_d = 360,
    jit_code_beqi_d = 361,

    jit_code_bger_d = 362,
    jit_code_bgei_d = 363,

    jit_code_bgtr_d = 364,
    jit_code_bgti_d = 365,

    jit_code_bner_d = 366,
    jit_code_bnei_d = 367,

    jit_code_bunltr_d = 368,
    jit_code_bunlti_d = 369,

    jit_code_bunler_d = 370,
    jit_code_bunlei_d = 371,

    jit_code_buneqr_d = 372,
    jit_code_buneqi_d = 373,

    jit_code_bunger_d = 374,
    jit_code_bungei_d = 375,

    jit_code_bungtr_d = 376,
    jit_code_bungti_d = 377,

    jit_code_bltgtr_d = 378,
    jit_code_bltgti_d = 379,

    jit_code_bordr_d = 380,
    jit_code_bordi_d = 381,

    jit_code_bunordr_d = 382,
    jit_code_bunordi_d = 383,

    jit_code_pushargr_d = 384,
    jit_code_pushargi_d = 385,

    jit_code_retr_d = 386,
    jit_code_reti_d = 387,

    jit_code_retval_d = 388,

    /* Special internal backend specific codes */
    jit_code_movr_w_f = 389,
    jit_code_movr_ww_d = 390, /* w* -> f|d */

    jit_code_movr_w_d = 391, /* w -> d */

    jit_code_movr_f_w = 392,
    jit_code_movi_f_w = 393, /* f|d -> w* */

    jit_code_movr_d_ww = 394,
    jit_code_movi_d_ww = 395,

    jit_code_movr_d_w = 396,
    jit_code_movi_d_w = 397, /* d -> w */

    jit_code_last_code = 398
}

alias jit_alloc_func_ptr = void* function (size_t);
alias jit_realloc_func_ptr = void* function (void*, size_t);
alias jit_free_func_ptr = void function (void*);

/*
 * Prototypes
 */
void init_jit (const(char)*);
void finish_jit ();

jit_state_t* jit_new_state ();

void _jit_clear_state (jit_state_t*);

void _jit_destroy_state (jit_state_t*);

jit_pointer_t _jit_address (jit_state_t*, jit_node_t*);

jit_node_t* _jit_name (jit_state_t*, const(char)*);

jit_node_t* _jit_note (jit_state_t*, const(char)*, int);

jit_node_t* _jit_label (jit_state_t*);

jit_node_t* _jit_forward (jit_state_t*);

jit_node_t* _jit_indirect (jit_state_t*);

void _jit_link (jit_state_t*, jit_node_t*);

jit_bool_t _jit_forward_p (jit_state_t*, jit_node_t*);
jit_bool_t _jit_indirect_p (jit_state_t*, jit_node_t*);
jit_bool_t _jit_target_p (jit_state_t*, jit_node_t*);

void _jit_prolog (jit_state_t*);
jit_int32_t _jit_allocai (jit_state_t*, jit_int32_t);
void _jit_allocar (jit_state_t*, jit_int32_t, jit_int32_t);
void _jit_ellipsis (jit_state_t*);
jit_node_t* _jit_arg (jit_state_t*);

void _jit_getarg_c (jit_state_t*, jit_gpr_t, jit_node_t*);
void _jit_getarg_uc (jit_state_t*, jit_gpr_t, jit_node_t*);
void _jit_getarg_s (jit_state_t*, jit_gpr_t, jit_node_t*);
void _jit_getarg_us (jit_state_t*, jit_gpr_t, jit_node_t*);
void _jit_getarg_i (jit_state_t*, jit_gpr_t, jit_node_t*);
void _jit_getarg_ui (jit_state_t*, jit_gpr_t, jit_node_t*);
void _jit_getarg_l (jit_state_t*, jit_gpr_t, jit_node_t*);

void _jit_putargr (jit_state_t*, jit_gpr_t, jit_node_t*);
void _jit_putargi (jit_state_t*, jit_word_t, jit_node_t*);

void _jit_prepare (jit_state_t*);
void _jit_ellipsis (jit_state_t*);

void _jit_va_push (jit_state_t*, jit_gpr_t);
void _jit_pushargr (jit_state_t*, jit_gpr_t);
void _jit_pushargi (jit_state_t*, jit_word_t);

void _jit_finishr (jit_state_t*, jit_gpr_t);
jit_node_t* _jit_finishi (jit_state_t*, jit_pointer_t);

void _jit_ret (jit_state_t*);
void _jit_retr (jit_state_t*, jit_gpr_t);
void _jit_reti (jit_state_t*, jit_word_t);

void _jit_retval_c (jit_state_t*, jit_gpr_t);
void _jit_retval_uc (jit_state_t*, jit_gpr_t);
void _jit_retval_s (jit_state_t*, jit_gpr_t);
void _jit_retval_us (jit_state_t*, jit_gpr_t);
void _jit_retval_i (jit_state_t*, jit_gpr_t);
void _jit_retval_ui (jit_state_t*, jit_gpr_t);
void _jit_retval_l (jit_state_t*, jit_gpr_t);

void _jit_epilog (jit_state_t*);

void _jit_patch (jit_state_t*, jit_node_t*);
void _jit_patch_at (jit_state_t*, jit_node_t*, jit_node_t*);
void _jit_patch_abs (jit_state_t*, jit_node_t*, jit_pointer_t);

void _jit_realize (jit_state_t*);

jit_pointer_t _jit_get_code (jit_state_t*, jit_word_t*);
void _jit_set_code (jit_state_t*, jit_pointer_t, jit_word_t);
jit_pointer_t _jit_get_data (jit_state_t*, jit_word_t*, jit_word_t*);
void _jit_set_data (jit_state_t*, jit_pointer_t, jit_word_t, jit_word_t);

void _jit_frame (jit_state_t*, jit_int32_t);
void _jit_tramp (jit_state_t*, jit_int32_t);

jit_pointer_t _jit_emit (jit_state_t*);

void _jit_print (jit_state_t*);

jit_node_t* _jit_arg_f (jit_state_t*);

void _jit_getarg_f (jit_state_t*, jit_fpr_t, jit_node_t*);
void _jit_putargr_f (jit_state_t*, jit_fpr_t, jit_node_t*);
void _jit_putargi_f (jit_state_t*, jit_float32_t, jit_node_t*);

void _jit_pushargr_f (jit_state_t*, jit_fpr_t);
void _jit_pushargi_f (jit_state_t*, jit_float32_t);

void _jit_retr_f (jit_state_t*, jit_fpr_t);
void _jit_reti_f (jit_state_t*, jit_float32_t);

void _jit_retval_f (jit_state_t*, jit_fpr_t);

jit_node_t* _jit_arg_d (jit_state_t*);

void _jit_getarg_d (jit_state_t*, jit_fpr_t, jit_node_t*);
void _jit_putargr_d (jit_state_t*, jit_fpr_t, jit_node_t*);
void _jit_putargi_d (jit_state_t*, jit_float64_t, jit_node_t*);

void _jit_pushargr_d (jit_state_t*, jit_fpr_t);
void _jit_pushargi_d (jit_state_t*, jit_float64_t);
void _jit_retr_d (jit_state_t*, jit_fpr_t);
void _jit_reti_d (jit_state_t*, jit_float64_t);

void _jit_retval_d (jit_state_t*, jit_fpr_t);

jit_node_t* _jit_new_node (jit_state_t*, jit_code_t);
jit_node_t* _jit_new_node_w (jit_state_t*, jit_code_t, jit_word_t);
jit_node_t* _jit_new_node_f (jit_state_t*, jit_code_t, jit_float32_t);
jit_node_t* _jit_new_node_d (jit_state_t*, jit_code_t, jit_float64_t);
jit_node_t* _jit_new_node_p (jit_state_t*, jit_code_t, jit_pointer_t);
jit_node_t* _jit_new_node_ww (jit_state_t*, jit_code_t, jit_word_t, jit_word_t);
jit_node_t* _jit_new_node_wp (
    jit_state_t*,
    jit_code_t,
    jit_word_t,
    jit_pointer_t);
jit_node_t* _jit_new_node_fp (
    jit_state_t*,
    jit_code_t,
    jit_float32_t,
    jit_pointer_t);
jit_node_t* _jit_new_node_dp (
    jit_state_t*,
    jit_code_t,
    jit_float64_t,
    jit_pointer_t);
jit_node_t* _jit_new_node_pw (
    jit_state_t*,
    jit_code_t,
    jit_pointer_t,
    jit_word_t);
jit_node_t* _jit_new_node_wf (
    jit_state_t*,
    jit_code_t,
    jit_word_t,
    jit_float32_t);
jit_node_t* _jit_new_node_wd (
    jit_state_t*,
    jit_code_t,
    jit_word_t,
    jit_float64_t);
jit_node_t* _jit_new_node_www (
    jit_state_t*,
    jit_code_t,
    jit_word_t,
    jit_word_t,
    jit_word_t);
jit_node_t* _jit_new_node_qww (
    jit_state_t*,
    jit_code_t,
    jit_int32_t,
    jit_int32_t,
    jit_word_t,
    jit_word_t);
jit_node_t* _jit_new_node_wwf (
    jit_state_t*,
    jit_code_t,
    jit_word_t,
    jit_word_t,
    jit_float32_t);
jit_node_t* _jit_new_node_wwd (
    jit_state_t*,
    jit_code_t,
    jit_word_t,
    jit_word_t,
    jit_float64_t);
jit_node_t* _jit_new_node_pww (
    jit_state_t*,
    jit_code_t,
    jit_pointer_t,
    jit_word_t,
    jit_word_t);
jit_node_t* _jit_new_node_pwf (
    jit_state_t*,
    jit_code_t,
    jit_pointer_t,
    jit_word_t,
    jit_float32_t);
jit_node_t* _jit_new_node_pwd (
    jit_state_t*,
    jit_code_t,
    jit_pointer_t,
    jit_word_t,
    jit_float64_t);

jit_bool_t _jit_arg_register_p (jit_state_t*, jit_node_t*);

jit_bool_t _jit_callee_save_p (jit_state_t*, jit_int32_t);

jit_bool_t _jit_pointer_p (jit_state_t*, jit_pointer_t);

jit_bool_t _jit_get_note (jit_state_t*, jit_pointer_t, char**, char**, int*);

void _jit_disassemble (jit_state_t*);

void jit_set_memory_functions (
    jit_alloc_func_ptr,
    jit_realloc_func_ptr,
    jit_free_func_ptr);
void jit_get_memory_functions (
    jit_alloc_func_ptr*,
    jit_realloc_func_ptr*,
    jit_free_func_ptr*);
