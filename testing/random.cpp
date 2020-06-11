#include <iostream>

using namespace std;

/*
  Takes 4 integers via stdin: a,b,n,s and print out a pseudo-random number to stdout
*/

int lcong(const unsigned int a, const unsigned int b, const int n, const unsigned int s){
  unsigned int y = s;
  unsigned int sum = 0;
  for (int i = n ; i > 0; i--){
    y = y*a + b;
    sum = sum + y;
  }
  return sum;
}

int main(){
  unsigned int a, b, n, s;
  cin >> a >> b >> n >> s;
  cout << lcong(a,b,n,s);
}
