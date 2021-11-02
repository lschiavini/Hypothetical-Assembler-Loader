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
        FileLines currentOutputFile;
        currentOutputFile = this->getFileInLines(file);

        std::cout<< "FileLines: " << std::endl;  
        this->printFileLines(currentOutputFile);

        currentOutputFile = this->getReallocBitmap(file, currentOutputFile);
        
        std::cout<< "FileLines After Realloc: " << std::endl;  
        this->printFileLines(currentOutputFile);

        this->allOutputFiles.push_back(currentOutputFile);
    }
}

FileLines Loader::getFileInLines(ObjFile file) {
    FileLines currentFile;
    std::vector<std::string> fileWithoutSpace = split(file.code, ' ');
    
    fileWithoutSpace.erase(fileWithoutSpace.begin());
    
    // std::cout<< "fileWithoutSpace: " << getListAsString(fileWithoutSpace) << std::endl;  
    // std::cout<< "fileWithoutSpace SIZE: " << fileWithoutSpace.size() << std::endl;  
    for (int i = 0; i < file.size - 1; ) {
        int lineAddress = i;
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
            lineAddress,
            myOpcode,
            newArg1,
            newArg2
        );
        currentFile[lineAddress] = newLine;
    }
    return currentFile;
}

FileLines Loader::getReallocBitmap(ObjFile file, FileLines currentOutputFile) {
    FileLines allocatedFile;
    int currentChunkPos = 0;
    int chunkSizeUsed = 0;
    FileLines::iterator it = currentOutputFile.begin();
    for (int i = 0; i < file.relocationData.length(); i++) { 
        
        std::cout<< "Realloquing: " << i << std::endl;  
        AddressOpcodeArgsLine oldLine = it->second;
        uint16_t oldAddress  = std::get<ADDRESS_FILELINE>(oldLine);
        std::string oldOpCODE = std::get<OPCODE_FILELINE>(oldLine);
        std::string newArg1 = std::get<ARG1_FILELINE>(oldLine); 
        std::string newArg2 = std::get<ARG2_FILELINE>(oldLine); 

        uint16_t newAddress = oldAddress;

        
        Chunk currentChunk = this->allChunks.at(currentChunkPos);
        // if(i > currentChunk.getSize()) {
        //     currentChunkPos++;
        //     currentChunk = this->allChunks.at(currentChunkPos);
        // }

        newAddress = oldAddress + currentChunk.getAddress();
        if (file.relocationData.at(i) == '0') {  // ABSOLUTE VALUE

        } else if (file.relocationData.at(i) == '1') {  // RELATIVE VALUE
            // std::cout<< "file.relocationData.at(i): " << file.relocationData.at(i) << std::endl;  
            std::cout<< "it->first: " << it->first << std::endl; 
            std::cout<< "i: " << i << std::endl; 
            // std::cout<< "newArg1: " << newArg1 << std::endl;  
            // std::cout<< "newArg2: " << newArg2 << std::endl;  
            if(i != it->first) {
                // std::cout<< "i - it->first: " << i - it->first << std::endl;  
                if(i - it->first == 2) {
                    int argInt = std::stoi(newArg1) + currentChunk.getAddress();
                    newArg1 = std::to_string(argInt);
                    
                    it++;
                } else if(i - it->first == 3) {
                    int argInt = std::stoi(newArg2) + currentChunk.getAddress();
                    newArg2 = std::to_string(argInt);
                    
                    it++;
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
            
            // std::cout<< "HERE33333 " << finalFileName << std::endl; 
            uint16_t key = it->first;
            AddressOpcodeArgsLine lineToWrite = it->second;
            uint16_t address  = std::get<ADDRESS_FILELINE>(lineToWrite);
            std::string opCODE = std::get<OPCODE_FILELINE>(lineToWrite);
            std::string arg1 = std::get<ARG1_FILELINE>(lineToWrite); 
            std::string arg2 = std::get<ARG2_FILELINE>(lineToWrite); 

            bool isCONST = arg1 == opCODE;
            
            std::string outputString = std::to_string(address) + " " + opCODE + " ";
            if(!arg1.empty() && !isCONST) outputString += arg1 + " ";
            if(!arg2.empty()) outputString += arg2 + " ";
            
            output << outputString << std::endl;
            it++;
        }

        outputFileIt++;
        output.close();

    }
}

void Loader::printFileLines(FileLines file) {
    FileLines::iterator it = file.begin();
    uint16_t pc = 0;
    std::string instruction = "";
    std::string arg1 = "";
    std::string arg2 = "";
    do {
        uint16_t key = it->first;
        AddressOpcodeArgsLine currentLine = it->second;
        pc = std::get<0>(currentLine);
        instruction = std::get<1>(currentLine);
        arg1 = std::get<2>(currentLine);
        arg2 = std::get<3>(currentLine);
        this->printTuple(
            pc,
            instruction,
            arg1,
            arg2
        );
        it++;
    } while(it != file.end());
}

void Loader::printTuple(
    uint16_t pc,
    std::string instruction,
    std::string arg1,
    std::string arg2
) {
    std::cout << "map[" << pc << "] : "
    << instruction << " " 
    << arg1 << " " 
    << arg2 << " "    
    <<std::endl;
}