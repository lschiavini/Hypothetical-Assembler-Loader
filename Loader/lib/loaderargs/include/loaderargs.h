#pragma once
#ifndef LOADERARGS_H
#define LOADERARGS_H

#include <fstream>
#include <objfile.h>
#include <chunk.h>
#include <stringUtils.h>
#include <vector>
#include <iostream>
#include <string>


typedef std::tuple<
    uint16_t, 
    std::string,
    std::string,
    std::string
> AddressOpcodeArgsLine;


// map<[PC] [PC, opcode, arg1, arg2]>
// address opcode/value arg1 arg2 lineOriginalFile 
typedef std::map<uint16_t, AddressOpcodeArgsLine > FileLines;

class LoaderArgs {
    public:
        char ** argsProvided;
        int numOfArgs = 0;
        std::string fileNames[3];
        ~LoaderArgs();
        LoaderArgs();
        std::vector<ObjFile> getFiles();
        std::vector<Chunk> getChunks();

        void processArgs(std::fstream *source, int numOfArgs, char ** argv);

    private:
        std::vector<ObjFile> objFiles;
        std::vector<Chunk> chunks;

        void labelArgs(std::fstream *source, int numOfArgs, char ** argv);
        void checkArgsForErrors(std::fstream *source, int numOfArgs, char ** argv);

        void openFile(std::fstream * sourceCodeContains, std::string originalFileName);
        void checkHowManyFiles(char ** argv);
        void getChunkFromArgs();
        bool isFileName(std::string fileName);
        void getFiles(std::vector<std::string> fileNames);
        void parseFileData(std::fstream * sourceCode) ;

        
            // for chunk in chunks:
            //     chunk.size = argv[pos]
            //     chunk.address = argv[pos]

        // TODO: get file sizes
        // TODO: get file text
        // TODO: get file relocation type 
        
};

#endif