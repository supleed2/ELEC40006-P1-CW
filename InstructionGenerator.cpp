#include <iostream>
#include <sstream>
#include <string>
#include <vector>
#include <cassert>

using namespace std;

#define pb push_back

#define endl "\n"
#define IOS ios_base::sync_with_stdio(false); cin.tie(NULL);

const unsigned int RAM_SIZE = 2048;
const unsigned int INSTRUCTION_LENGTH = 16;

vector<string> getWords(string line){
  vector<string> ans;
  istringstream stream(line);
  while (stream){
    string temp;
    stream >> temp;
    ans.pb(temp);
  }
  return ans;
}

string convertBinaryToHex(string binary4){
  if(binary4=="0000"){
    return "0";
  }else if(binary4=="0001"){
    return "1";
  }else if(binary4=="0010"){
    return "2";
  }else if(binary4=="0011"){
    return "3";
  }else if(binary4=="0100"){
    return "4";
  }else if(binary4=="0101"){
    return "5";
  }else if(binary4=="0110"){
    return "6";
  }else if(binary4=="0111"){
    return "7";
  }else if(binary4=="1000"){
    return "8";
  }else if(binary4=="1001"){
    return "9";
  }else if(binary4=="1010"){
    return "A";
  }else if(binary4=="1011"){
    return "B";
  }else if(binary4=="1100"){
    return "C";
  }else if(binary4=="1101"){
    return "D";
  }else if(binary4=="1110"){
    return "E";
  }else if(binary4=="1111"){
    return "F";
  }else{
    assert(0);
  }
}

string convertInstructionToHex(string binaryInstruction){
  string ans="";
  string temp="";
  assert(binaryInstruction.size()==16);
  for (int i=0; i<16; i++){
    temp+=binaryInstr.at(i);
    if(i==3 || i==7 ||i==11 || i==15){
      ans+=convertBinaryToHex(temp);
      temp=""
    }
  }
  return ans;
}

string getInstructionHex(string instruction){
  string binary;
  string opcode, rs1, rs2, rd;

  if (opcode=="LDA" || opcode=="STA"){
    binary="1";
    if(opcode=="LDA"){

    }else if (opcode=="STA"){

    }else {
      assert(0);
    }
  }else{
    switch (opcode) {
      case "":
        // Add code
        break;
    }
  }
  return ans;
}

void generateMIF(vector<string> instructions){
  cout << "DEPTH = " << RAM_SIZE << ";" << endl;
  cout << "WIDTH = " << INSTRUCTION_LENGTH << ";" << endl;
  cout << "ADDRESS_RADIX = DEC;" << endl;
  cout << "DATA_RADIX = HEX;" << endl;
  cout << "CONTENT" << endl;
  cout << "BEGIN" << endl;
  cout << "[0..2047]: 0;" << endl;
  for (int i = 0; i <= instruction.size(); i++){
    cout << i << " : " << instruction.at(i) << ";" << endl;
  }
}

int main(){
  IOS;
  string temp;
  vector<string> hexCodes;
  while(getline(cin, temp)){
    hexCodes.pb(getInstructionHex(temp));
  }
  generateMIF(hexCodes);
}
