#include <chunk.h>
#include <fstream>
#include <iostream>
#include <string>
#include <regex>
#include <sstream>


Chunk::~Chunk(){}
Chunk::Chunk(){}

void Chunk::setSize(int size){
    this->size = size;
}
void Chunk::setAddress(int address){
    this->address = address;
}
int Chunk::getSize(){
    return this->size;
}
int Chunk::getAddress(){
    return this->address;
}
