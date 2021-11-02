#include <loader.h>
#include <fstream>
#include <iostream>
#include <string>
#include <regex>
#include <sstream>


Loader::~Loader(){}
Loader::Loader(
    std::vector<ObjFile> files, 
    std::vector<Chunk> chunks
){
    this->allFiles = files;
    this->allChunks = chunks;

}

void Loader::loadFiles() {
    
    for(auto &file : this->allFiles) {
        std::cout<< "HERE22222222" << std::endl;
        FileLines currentOutputFile;
        currentOutputFile = this->getFileInLines(file);
        currentOutputFile = this->getReallocBitmap(file, currentOutputFile);
        
        this->allOutputFiles.push_back(currentOutputFile);
    }
}

FileLines Loader::getFileInLines(ObjFile file) {
    FileLines currentFile;
    std::vector<std::string> fileWithoutSpace = split(file.code, ' ');
    for (int i = 0; i < file.size; ) {
        
        std::string myOpcode = fileWithoutSpace.at(i);
        std::string newArg1 = ""; 
        std::string newArg2 = ""; 
        if(this->instructToSizeInMemory[myOpcode] == 3) {
            i = i + 1;
            newArg1 = fileWithoutSpace.at(i);
            i = i + 1;
            newArg1 = fileWithoutSpace.at(i);
            i = i + 1;
        } else if(this->instructToSizeInMemory[myOpcode] == 2) { 
            i = i + 1;
            newArg1 = fileWithoutSpace.at(i);
            i = i + 1;
        } else {
            i++;
        }
        // else if(this->instructToSizeInMemory[myOpcode] == 1) { 
        //     i = i + 1;
        // }

        AddressOpcodeArgsLine newLine = make_tuple(
            i,
            myOpcode,
            newArg1,
            newArg2
        );
        currentFile[i] = newLine;
    }
    return currentFile;
}

FileLines Loader::getReallocBitmap(ObjFile file, FileLines currentOutputFile) {
    FileLines allocatedFile;
    int currentChunk = 0;
    FileLines::iterator it = currentOutputFile.begin();
    for (int i = 0; i < file.relocationData.length(); i++) { 
        
        AddressOpcodeArgsLine oldLine = it->second;
        uint16_t oldAddress  = std::get<ADDRESS_FILELINE>(oldLine);
        std::string oldOpCODE = std::get<OPCODE_FILELINE>(oldLine);
        std::string newArg1 = std::get<ARG1_FILELINE>(oldLine); 
        std::string newArg2 = std::get<ARG2_FILELINE>(oldLine); 

        uint16_t newAddress = oldAddress;
        
        // std::cout<< "HERE33333" << std::endl;  

        for(int j = 0; j < this->allChunks.at(currentChunk).getSize(); j++) {
            newAddress = oldAddress + this->allChunks.at(currentChunk).getAddress();
            if (file.relocationData.at(i) == '0') {  // ABSOLUTE VALUE

            } else if (file.relocationData.at(i) == '1') {  // RELATIVE VALUE
                if(i != it->first) {
                    if(i - it->first == 1) {
                        // newArg1 = std::to_string(std::stoi(newArg1) + this->allChunks.at(currentChunk).getAddress());
                    } else if(i - it->first == 2) {
                        // newArg2 = std::to_string(std::stoi(newArg2) + this->allChunks.at(currentChunk).getAddress());
                    }
                }
            }

        }


        AddressOpcodeArgsLine newLine = make_tuple(
            newAddress,
            oldOpCODE,
            newArg1,
            newArg2
        );
        allocatedFile[newAddress] = newLine;

    }
    return allocatedFile;
}


void Loader::outPutFiles() {
    std::string outputPath = "./tests/";
    std::vector<FileLines>::iterator outputFileIt =  this->allOutputFiles.begin();
    for(auto& inputFile : this->allFiles) {
        std::string finalFileName = outputPath + removeAllSpaces(inputFile.name.substr(0, inputFile.name.find_last_of('.'))+".out");
        std::fstream output;
        output.open(finalFileName,std::ios::out );

        FileLines::iterator it = (*outputFileIt).begin();
        while( it != (*outputFileIt).end()) {
            
        std::cout<< "HERE33333 " << finalFileName << std::endl; 
            uint16_t key = it->first;
            AddressOpcodeArgsLine lineToWrite = it->second;
            uint16_t address  = std::get<ADDRESS_FILELINE>(lineToWrite);
            std::string opCODE = std::get<OPCODE_FILELINE>(lineToWrite);
            std::string arg1 = std::get<ARG1_FILELINE>(lineToWrite); 
            std::string arg2 = std::get<ARG2_FILELINE>(lineToWrite); 

            bool isCONST = arg1 == opCODE;
            
            std::string outputString = opCODE + " ";
            if(!arg1.empty() && !isCONST) outputString += arg1 + " ";
            if(!arg2.empty()) outputString += arg2 + " ";
            
            output << outputString;
            it++;
        }

        outputFileIt++;
        output.close();

    }
}
