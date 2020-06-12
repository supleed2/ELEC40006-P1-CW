/*
  Source code for generating MIF files from instructions
  Input format: Text file with each instruction on a seperate line (see below, please follow this new lines breeak this code);
  Output format: Use stdout to redirect to filename.mif or filename.txt and then convert to .mif
  Single instruction format and example:
    1. INSTRUCTION RD RS1 RS2 (all in capitals, seperated by whitespace (this is okay if not exact, code removes whitespace anyway),
        BUT MUST INCLUDE R for registers)
        example: AND R2 R4 R5
                 MUL R0 R4 R7
                 JMP R2
                 STP
        For instructions that use only two registers, example MOV: MOV R0 R1 (do not enter third register, just proceed to next instruction)
        For instructions that use one register, example JMP: JMP R0 (similar to before, just proceed to next instruction)
        For insturctions that use no registers, example STP: STP (and just proceed to next line)
    2. LDA/STA RN MEMORY_LOCATION(DECIMAL) (please make sure memory location is in DECIMAL, otherwise bad things happen with the code)
      example: LDA R3 1546
               STA R6 909
*/

/*
  IMPORTANT NOTE: For the OR instruction, enter it as "_OR", otherwise the code breaks :(
  -Kacper
*/

#include <iostream>
#include <string>
#include <vector>
#include <cassert>
#include <algorithm>

using namespace std;

#define pb push_back

#define endl "\n"
#define IOS ios_base::sync_with_stdio(false); cin.tie(NULL);

const unsigned int RAM_SIZE = 2048;
const unsigned int INSTRUCTION_LENGTH = 16;

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
    cerr << "Invalide binary quartet, cannot convert to HEX (line 78 in .cpp file)" << endl;
    assert(0);
  }
}

string convertDecimalToBinary(int decimal, int digits){
  if (decimal>2047){
    cerr << "Too large memory location, we don't have that much memory for LDA/STA" << endl;
    assert(0);
  }
  string ans="";
  while(decimal>0){
    int rem = decimal%2;
    ans+=to_string(rem);
    decimal/=2;
  }
  while(ans.size()<digits){
    ans+="0";
  }
  reverse(ans.begin(), ans.end());
  return ans;
}

string convertInstructionToHex(string binaryInstruction){
  string ans="";
  string temp="";
  if (binaryInstruction.size()!=16){
    cerr << "Instruction needs to be exactly 16 bits long, crash in line 105" << endl;
    assert(0);
  }
  for (int i=0; i<16; i++){
    temp+=binaryInstruction.at(i);
    if(i==3 || i==7 || i==11 || i==15){
      ans+=convertBinaryToHex(temp);
      temp="";
    }
  }
  return ans;
}

string getRegisterBinary(string reg){
  if (reg.size()!=2){
    cerr << "Invalid register format, please use form RN, example R0, R3,...; crash in line 120" << endl;
    assert(0);
  }
  if(reg.at(1)=='0'){
    return "000";
  }else if(reg.at(1)=='1'){
    return "001";
  }else if(reg.at(1)=='2'){
    return "010";
  }else if(reg.at(1)=='3'){
    return "011";
  }else if(reg.at(1)=='4'){
    return "100";
  }else if(reg.at(1)=='5'){
    return "101";
  }else if(reg.at(1)=='6'){
    return "110";
  }else if(reg.at(1)=='7'){
    return "111";
  }else{
    cerr << "Unknown register input (not between 0 and 7), crash in line 140" << endl;
    assert(0);
  }
}

string getInstructionHex(string instruction){
  string opcode = instruction.substr(0, 3);
  string rd = instruction.substr(3, 2);
  string binary;

  if (opcode=="LDA" || opcode=="STA"){
    if (instruction.size()<6){
      cerr << "Instruction format not valid, crash at line 155" << endl;
      assert(0);
    }
    binary="1";
    if(opcode=="LDA"){
        binary+="0";
    }else if (opcode=="STA"){
        binary+="1";
    }else {
      cerr << "Unknown instruction, I think you wanted LDA or STA, crash in line 164" << endl;
      assert(0);
    }
    binary+=getRegisterBinary(rd);
    int lengthOfAddress = instruction.size()-5;
    binary+=convertDecimalToBinary(stoi(instruction.substr(5, lengthOfAddress)), 11);
  }else if(opcode=="JMA"){
    binary="0000001";
    int lengthOfAddress = instruction.size()-3;
    binary+=convertDecimalToBinary(stoi(instruction.substr(3, lengthOfAddress)), 9);
  }else{
    binary="0";
    string rs1, rs2;

    if(instruction.size()>=7){
      rs1 = instruction.substr(5, 2);
    }
    if(instruction.size()>=9){
      rs2 = instruction.substr(7, 2);
    }
    if(opcode=="JMP"){
      binary+="000000";
      rs1="R0";
      rs2="R0";
    }else if(opcode=="JC1"){
      binary+="000100";
    }else if(opcode=="JC2"){
      binary+="000101";
    }else if(opcode=="JC3"){
      binary+="000110";
    }else if(opcode=="JC4"){
      binary+="000111";
      rs2="R0";
    }else if(opcode=="JC5"){
      binary+="001000";
    }else if(opcode=="JC6"){
      binary+="001001";
    }else if(opcode=="JC7"){
      binary+="001010";
    }else if(opcode=="JC8"){
      binary+="001011";
      rs2="R0";
    }else if(opcode=="AND"){
      binary+="001100";
    }else if(opcode=="_OR"){
      binary+="001101";
    }else if(opcode=="XOR"){
      binary+="001110";
    }else if(opcode=="NOT"){
      binary+="001111";
      rs2="R0";
    }else if(opcode=="NND"){
      binary+="010000";
    }else if(opcode=="NOR"){
      binary+="010001";
    }else if(opcode=="XNR"){
      binary+="010010";
    }else if(opcode=="MOV"){
      binary+="010011";
      rs2="R0";
    }else if(opcode=="ADD"){
      binary+="010100";
    }else if(opcode=="ADC"){
      binary+="010101";
    }else if(opcode=="ADO"){
      binary+="010110";
      rs2="R0";
    }else if(opcode=="SUB"){
      binary+="011000";
    }else if(opcode=="SBC"){
      binary+="011001";
    }else if(opcode=="SBO"){
      binary+="011010";
      rs2="R0";
    }else if(opcode=="MUL"){
      binary+="011100";
    }else if(opcode=="MLA"){
      binary+="011101";
    }else if(opcode=="MLS"){
      binary+="011110";
    }else if(opcode=="MRT"){
      binary+="011111";
      rs1="R0";
      rs2="R0";
    }else if(opcode=="LSL"){
      binary+="100000";
    }else if(opcode=="LSR"){
      binary+="100001";
    }else if(opcode=="ASR"){
      binary+="100010";
    }else if(opcode=="ROR"){
      binary+="100100";
    }else if(opcode=="RRC"){
      binary+="100101";
    }else if(opcode=="CLL"){
      binary+="100110";
      rs1="R0";
      rs2="R0";
    }else if(opcode=="RTN"){
      binary+="100111";
      rd="R0";
      rs1="R0";
      rs2="R0";
    }else if(opcode=="PSH"){
      binary+="101000";
      rs1=rd;
      rd="R0";
      rs2="R0";
    }else if(opcode=="POP"){
      binary+="101001";
      rs1="R0";
      rs2="R0";
    }else if(opcode=="LDR"){
      binary+="101010";
      rs2="R0";
    }else if(opcode=="STR"){
      binary+="101011";
      rs2="R0";
    }else if(opcode=="NOP"){
      binary+="111110";
      rd="R0";
      rs1="R0";
      rs2="R0";
    }else if(opcode=="STP"){
      binary+="111111";
      rd="R0";
      rs1="R0";
      rs2="R0";
    }else{
      assert(0);
    }
    binary+=getRegisterBinary(rd);
    binary+=getRegisterBinary(rs1);
    binary+=getRegisterBinary(rs2);
  }
  return convertInstructionToHex(binary);
}

void generateMIF(vector<string> instructions){
  cout << "DEPTH = " << RAM_SIZE << ";" << endl;
  cout << "WIDTH = " << INSTRUCTION_LENGTH << ";" << endl;
  cout << "ADDRESS_RADIX = DEC;" << endl;
  cout << "DATA_RADIX = HEX;" << endl;
  cout << "CONTENT" << endl;
  cout << "BEGIN" << endl;
  int i=0;
  for (i; i < instructions.size(); i++){
    cout << i << " : " << instructions.at(i) << ";" << endl;
  }
  cout << "[" << i << "..2047]: 0;" << endl;
  cout << "END;" << endl;
}

int main(){
  IOS;
  string temp;
  vector<string> hexCodes;
  while(getline(cin, temp)){
    auto it = remove(temp.begin(), temp.end(), ' ');
    temp.erase(it, temp.end());
    if (temp.size()>=3){
      hexCodes.pb(getInstructionHex(temp));
    }
  }
  generateMIF(hexCodes);
}
