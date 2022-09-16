#include <stdio.h>
#include <stdlib.h>
#ifdef IMP
#include "reference_stackADT.h"
#else
#include "stackADT.h"
#endif
#include "memtrace.h"

// Define ADT node in stack
struct node {
  // modify the data type
  void * data;
  struct node *next;
};

// Set stack pointer
struct stack_type {
  struct node *begin;
};

// To initialize a stack
Stack Stack_create(void){
  Stack s = malloc(sizeof(struct stack_type));
  if (s == NULL){
    printf("Error in create: stack could not be created.\n");
    exit(EXIT_FAILURE);

  }
  s -> begin = NULL;
  return s;
}

// clear the memory and free the memory;
void Stack_destroy(Stack s){
  Stack_make_empty(s);
  free(s);

}

// helper function to clear memory 
void Stack_make_empty(Stack s){
  while (!Stack_is_empty(s)){
    // free all pointer to data 
    free( (s-> begin) -> data);
    Stack_pop(s);
  }
}

// helper function to "Stack_make_empty"
bool Stack_is_empty(Stack s){
  return s -> begin == NULL;
}

// return not full;
bool Stack_is_full(Stack s){
  return false;
}

// add element to stack 
void Stack_push(Stack s, void * i){
  struct node *new = malloc(sizeof(struct node));
  if (new == NULL){
    printf("Error in push: stack is full.\n");
    exit(EXIT_FAILURE);
  }
  new -> data = i;
  new -> next = s -> begin;
  s -> begin = new;
}

// delete element from stack 
void * Stack_pop(Stack s){
  struct node *old;
  void * i;
  if (Stack_is_empty(s)){
    printf("Error in pop: stack is empty.\n");
    exit(EXIT_FAILURE);
  }
  old = s-> begin;
  i = old -> data;
  s -> begin = old -> next;
  free(old);
  return i;
}
