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
        
            // for chunk in chunks:
            //     chunk.size = argv[pos]
            //     chunk.address = argv[pos]

        
};

#endif