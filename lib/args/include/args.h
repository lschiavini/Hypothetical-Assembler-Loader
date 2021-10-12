#pragma once
#ifndef ARGS_H
#define ARGS_H

#include <fstream>

class Args {
    public:
        int argumentsExpected = 4;
        std::string fileName;
        Args();
        void checkArgsForErrors(std::fstream *source, int argc, char ** argv);
        ~Args();
        std::string getFileName();
        std::string getReallocationType();
    private:
        
        std::string originalFileName;
        std::string reallocationType;
        std::string rArg;
        std::string execPath;
        
        void openFile(std::fstream * sourceCodeContains);
        void checkFileNameError();
        void checkRArgError();
        void checkExecPathError();
        void checkReallocationTypeError();
        
};

#endif