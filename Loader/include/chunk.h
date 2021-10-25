#pragma once
#ifndef CHUNK_H
#define CHUNK_H

#include <fstream>
#include <iostream>
#include <map>
#include <string>

class Chunk {
    public:
        Chunk();
        ~Chunk();
        void setSize(int size);
        void setAddress(int address);
        
        int getSize();
        int getAddress();
        
    private:
        int size = 0;
        int address = 0;
};

#endif