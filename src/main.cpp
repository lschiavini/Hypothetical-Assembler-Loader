#include <iostream>
#include <fstream>
#include <args.h>
#include <utils.h>
#include <assembler.h>
#include <simulator.h>

int main(int argc, char ** argv)
{
    Args myArgs;
    std::string fileName, reallocationType;
    std::fstream sourceCode, assembledCode;
    try {
        myArgs.checkArgsForErrors(&sourceCode, argc, argv);
        fileName = myArgs.getFileName();
        reallocationType = myArgs.getReallocationType();

        Assembler myAssembler(&sourceCode, fileName, reallocationType);
        myAssembler.assembleFile();

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