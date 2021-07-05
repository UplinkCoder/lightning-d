import core.stdc.stdio;
import lightning;
import jit_x86;

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
  return 0;
}
