#include <iostream>
#include <fstream>
#include <vector>
#include <utils.h>
#include <assembler.h>
#include <loader.h>
#include <simulator.h>
#include <chunk.h>
#include <loaderargs.h>
#include <objfile.h>

int main(int argc, char ** argv)
{
    LoaderArgs myArgs;
    std::vector<ObjFile> files;
    std::vector<Chunk> chunks;

    std::string fileName, reallocationType;
    std::fstream sourceCode, assembledCode;
    try {
        myArgs.processArgs(&sourceCode, argc, argv);
        files = myArgs.getFiles();
        chunks = myArgs.getChunks();
        
        Loader myLoader(files, chunks);

        // Assembler myAssembler(&sourceCode, fileName, reallocationType);
        // myAssembler.assembleFile();

        


        // if(myAssembler.canSimulate) {
        // Simulator mySim(fileName);
        // mySim.simulate();
        // }
    } catch(std::string error) {
        std::cout << error << std::endl;
    }
    
    std::cout << "End of Show"<< std::endl;
    return 0;
}