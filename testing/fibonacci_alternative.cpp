#include <bits/stdc++.h>

using namespace std;

int fib(int n){
  int temp = n; //temporary variable, set equal to n
  stack <int> s;
  //if n is non-negative, decrease until reaches zero to fill up stack
  while(temp>1){
    s.push(0); //n is not 0 or 1, hence push 0 onto stack, come back later
    temp--; //prevents an infinite loop
  }
  s.push(1);
  s.push(1);

  //go back, increase temp until equal to n
  while(temp<n){
    /*
      Retrieve the top two elements
    */
    int smaller = s.top();
    s.pop();
    int larger = s.top();
    s.pop();

    /*
      this removes the current element, which is 0, but add it back later, once calculated
    */
    s.pop();
    /*
      Calculate the next element and add it and then to the top of the stack add the larger of thee previous two values
    */
    int current = smaller+larger;
    s.push(current);
    s.push(larger);
    temp++; //prevents an infinite loop
  }
  /*
    the top element is 'bigger', which would be used to calculate next Fibonacci number but this is no longer required,
    so remove and return top element;
  */
  s.pop();
  return s.top();
}


int main(){
  int n;
  cin >> n;
  cout << fib(n) << endl;
}
