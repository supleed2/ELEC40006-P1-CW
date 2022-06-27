#include <iostream>
#include <cmath>

using namespace std;

typedef unsigned long long ull;

int main(){
  ios_base::sync_with_stdio(false);
  int bits;
  cin >> bits;
  int width = 2*bits;
  int depth = pow(2, bits);

  cout << "DEPTH = " << depth << ";" << endl;
  cout << "WIDTH = " << width << ";" << endl;
  cout << "ADDRESS_RADIX = DEC;" << endl;
  cout << "DATA_RADIX = DEC;" << endl;
  cout << "CONTENT" << endl;
  cout << "BEGIN" << endl;

  for (int i = 0; i<=(depth-1); i++){
    ull temp = i*i;
    cout << i << " : " << temp << ";" << endl;
  }
  cout << "END";
}
