import core.stdc.stdio;
import lightning;

version(AArch64)
{
    import jit_aarch64;
}
else version (X86_64)
{
    import jit_x86;
}
else version (X86)
{
    import jit_x86;
}
else static assert(0, "Architecture unsupported");

static jit_state_t* _jit;

// typedef void (*pvfi)(int);      /* Pointer to Void Function of Int */
alias pvfi = void* function(int);

int main(string[] args)
{
  pvfi          myFunction;             /* ptr to generated code */
  jit_node_t*    start, end;           /* a couple of labels */
  jit_node_t*    arg;                    /* to get the argument */

  init_jit(null);
  _jit = jit_new_state();

  start = _jit_note(_jit, __FILE__, __LINE__);
  _jit_prolog(_jit);
  arg = _jit_arg(_jit);
  _jit_getarg_c(_jit, JIT_R1, arg);
  _jit_prepare(_jit);
  _jit_pushargi(_jit, cast(jit_word_t)(cast(void*)"generated %d bytes\n".ptr));
  _jit_ellipsis(_jit);
  _jit_pushargr(_jit, JIT_R1);
  _jit_finishi(_jit, cast(void*)&printf);
  _jit_ret(_jit);
  _jit_epilog(_jit);
  end = _jit_note(_jit, __FILE__, __LINE__);

  myFunction = cast(typeof(myFunction))_jit_emit(_jit);

  /* call the generated code, passing its size as argument */
  myFunction(cast(int)(cast(char*)_jit_address(_jit, end) - cast(char*)_jit_address(_jit, start)));
  _jit_clear_state(_jit);

  _jit_destroy_state(_jit);
  finish_jit();

  printf("54 + 102 = %d\n", expensiveAdd(54, 102));
  printf("54 + (-30) = %d\n", expensiveAdd(54, -30));

  return 0;
}

int expensiveAdd(int a, int b)
{
  int function (int, int) add;

  init_jit(null);
  _jit = jit_new_state();

  jit_node_t*    arg1, arg2;      /* to get the argument */

  _jit_prolog(_jit);
  arg1 = _jit_arg(_jit);
  arg2 = _jit_arg(_jit);

  _jit_getarg_i(_jit, JIT_R1, arg1);
  _jit_getarg_i(_jit, JIT_R2, arg2);
  _jit_prepare(_jit);

  _jit_new_node_www(_jit, jit_code_t.jit_code_addr, JIT_R0, JIT_R1, JIT_R2);

  _jit_retr(_jit, JIT_R0);
  _jit_epilog(_jit);

  add = cast(typeof(add))_jit_emit(_jit);

  /* call the generated code, passing its size as argument */
  auto result = add(a, b);
  _jit_clear_state(_jit);

  _jit_destroy_state(_jit);
  finish_jit();

  return result;
}
