#pragma once
#ifndef OBJFILE_H
#define OBJFILE_H

#include <fstream>
#include <iostream>
#include <map>
#include <string>

class ObjFile {
    public:
        ObjFile();
        ~ObjFile();
        
    private:


        void setSize(int size);
        void setAddress(int address);
        
        int getSize();
        int getAddress();

        
        std::string name = "";
        int size = 0;
        std::string relocationData = "";
        std::string text = "";
};

#endif