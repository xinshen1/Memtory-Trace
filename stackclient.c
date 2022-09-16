#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
#include <string.h>
#include "memtrace.h"

#ifdef IMP
#include "reference_stackADT.h"
#else
#include "stackADT.h"
#endif

/* CODE: from the textbook for programming project 4 on page 506 */
/*       based on stackclient on page 494                        */
/* We have add comments to explain our dynamic memory use.       */
/* STUDY THIS CODE CAREFULLY!!!!!!                               */

int main(void)
{
  Stack s1, s2;
  int n, *i_ptr;
  char *c_ptr;

  s1 = Stack_create();
  s2 = Stack_create();

  // Our stacks store pointers to dynamically allocated
  // items.  So below we create items and then hand them
  // over to the stacks to store them.  Read
  // this code carefully and make sure you understand what 
  // each line is doing and why it was done. 
  // Doing so will make your job of implmeneting both 
  // your version of the stackADT4.c and PartB much easier.

  // create an integer store 1 into and push it on to 
  // stack s1
  i_ptr = (int *)malloc(sizeof(int)); // allocate the memory
  assert(i_ptr);                      // to be on the safe side terminate 
                                      // if malloc failed 
  *i_ptr = 1;                         // set the value of the integer to 1
  Stack_push(s1, i_ptr);              // hand the memory over to the stack 
  i_ptr = NULL;                       // to be on the safe side set our pointer
                                      // variable to NULL so that we don't accidentally
                                      // access the integer while it is on the stack
                                      // we think of the stack as currently owning it

  // same thing as above for a second integer set to 2
  i_ptr = (int *)malloc(sizeof(int));
  assert(i_ptr); 
  *i_ptr = 2;
  Stack_push(s1, i_ptr);
  i_ptr = NULL;

  // alright lets get the top value of s1 back and print it out.
  // given that we are done with the item we can free it to avoid leaks
  i_ptr = Stack_pop(s1);   // set i_ptr to the pointer on the top of the stack
  n = *i_ptr;              // derefence the pointer to get the underlying value (should)
                           // be 2 as it was the last thing pushed on
  free(i_ptr);             // we are done with the memory as we have copied the value 
                           // to n
  i_ptr = NULL;            // again to be safe we immediately set i_ptr to NULL to avoid
                           // silly mistakes
  printf("Popped %d from s1\n", n);
  

  // The following code follows the same memory idoms but show you the
  // use of stack s2 to store strings -- which are of course just 
  // blocks of memory in which we store a sequence of ascii value terminated
  // with a zero
  c_ptr = (char *)malloc(strlen("hello world") + 1); // add one to to ensure we 
                                                     // have space for the terminating 0
  assert(c_ptr);                                     // again catch failures 
  strcpy(c_ptr, "hello world");                      // copy a string into our memory
  Stack_push(s2, c_ptr);                             // store it on the stack
  c_ptr = NULL;

  i_ptr = Stack_pop(s1);
  n = *i_ptr;
  free(i_ptr);
  i_ptr = NULL;
  printf("Popped %d from s1\n", n);

  c_ptr = malloc(strlen("goodbye!!!") + 1);
  assert(c_ptr);
  strcpy(c_ptr, "goodbye!!!");  
  Stack_push(s2, c_ptr);
  c_ptr = NULL;

  // the rest of the code exercises more of the stack functions

  Stack_destroy(s1);

  while (!Stack_is_empty(s2)) {
    c_ptr = Stack_pop(s2);
    printf("Popped %s from s2\n", c_ptr);
    free(c_ptr);
    c_ptr = NULL;
  }

  c_ptr = (char *)malloc(strlen("It's me again") + 1);
  assert(c_ptr);
  strcpy(c_ptr, "It's me again");  
  Stack_push(s2, c_ptr);
  c_ptr = NULL;

  Stack_make_empty(s2);
  if (Stack_is_empty(s2))
    printf("s2 is empty\n");
  else
    printf("s2 is not empty\n");

  Stack_destroy(s2);

  return 0;
}

