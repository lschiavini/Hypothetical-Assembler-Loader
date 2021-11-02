#pragma once
#ifndef LOADER_H
#define LOADER_H

#include <fstream>
#include <iostream>
#include <map>
#include <string>
#include <chunk.h>
#include <objfile.h>


#define REALLOC_BITMAP "0"
#define REALLOC_LISTADDRESS "1"

#define ADDRESS_FILELINE 0
#define OPCODE_FILELINE 1
#define ARG1_FILELINE 2
#define ARG2_FILELINE 3

typedef std::tuple<
    uint16_t, 
    std::string,
    std::string,
    std::string
> AddressOpcodeArgsLine;


// map<[addressKey] [address, opcode, arg1, arg2]>
// address opcode/value arg1 arg2 lineOriginalFile 
typedef std::map<uint16_t, AddressOpcodeArgsLine > FileLines;

typedef std::map<std::string, uint16_t> DirectiveToNumber;

class Loader {
    public:
        Loader(std::vector<ObjFile> files, std::vector<Chunk> chunks);
        ~Loader();
        
    private:
        DirectiveToNumber instructToSizeInMemory = { // shows Number of arguments valueMap.second-1 
            {"1", 2},
            {"2", 2},
            {"3", 2},
            {"4", 2},
            {"5", 2},
            {"6", 2},
            {"7", 2},
            {"8", 2},
            {"9", 3},
            {"10", 2},
            {"11", 2},
            {"12", 2},
            {"13", 2},
            {"14", 1},
            {"0", 1},
            {"CONST", 1},
        };  


        std::vector<Chunk> allChunks;
        std::vector<ObjFile> allFiles;
        
        std::vector<FileLines> allOutputFiles;
        
        void loadCurrentFile(ObjFile file);
        void loadFiles();
        void outPutFiles();
        FileLines getFileInLines(ObjFile file);

        FileLines getReallocBitmap(ObjFile file, FileLines currentOutputFile);
        FileLines getReallocListOfAddress();
};

#endif