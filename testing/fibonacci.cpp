#include <iostream>
using namespace std;

/*
  Takes one input via stdin, the integer n
*/

int fib(const int n){
  int y;
  if (n <= 1) {
    y = 1;
  }else {
    y = fib(n-1);
    y = y + fib(n-2);
  }
  return y;
}

int main(){
  int n;
  cin >> n;
  cout << fib(n) << endl;
}
