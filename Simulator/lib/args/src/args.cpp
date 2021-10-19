#include <args.h>
#include <fstream>
#include <iostream>
#include <string>

Args::~Args(){}
Args::Args(){}

std::string Args::getFileName() {
    return this->fileName;
}

std::string Args::getReallocationType() {
    return this->reallocationType;
}

void Args::checkArgsForErrors(std::fstream *source, int argc, char ** argv) {
    if(argc == NULL) throw "nullPointer";
    std::fstream* sourceCodeContains = source;
    std::string error = "";
    if (argc != this->argumentsExpected)
    {
        error = "Arguments non compliant, requires three arguments, as in '[executablepath] -r 0|1 filename.asm' for 0 to mean bitmap reallocation and 1 as address list";
        throw error;
    } else
    {
        this->originalFileName = std::string(argv[3]);
        this->reallocationType = std::string(argv[2]);
        this->rArg = std::string(argv[1]);
        this->execPath = std::string(argv[0]);

        this->fileName = this->originalFileName; 

        this->checkFileNameError();
        this->checkRArgError();
        this->checkExecPathError();
        this->checkReallocationTypeError();
     
        this->openFile(sourceCodeContains);
    }
}

void Args::openFile(std::fstream * sourceCodeContains){
    std::string error = "";
    (*(sourceCodeContains)).open(this->originalFileName,std::ios::in);
    if ((*(sourceCodeContains)).good())
    {
        std::cout<<"File '"<< this->originalFileName<<"' opened successfully."<<std::endl;
    }else
    {
        error = "File not found.";
        throw error;
    }   
}

void Args::checkFileNameError(){
    std::string error = "";
    std::string originalFileName(this->fileName);
    if (originalFileName.substr(originalFileName.find_last_of(".") + 1) != "asm") {
        error = "Only accepts .asm files.";
        throw error;
    }
}

void Args::checkRArgError(){
    std::string error = "";
    if (this->rArg.compare("-r") != 0) {
        error = "Needs -r argument";
        throw error;
    }
}

void Args::checkExecPathError() {
    // TODO checkexecPath Error
    // std::string error = "";
    // if (this->execPath.compare("-r") != 0) {
    //     error = "Needs -r argument";
    //     throw error;
    // }
}

void Args::checkReallocationTypeError(){
    std::string error = "";
    if (!(this->reallocationType.compare("0") == 0 || this->reallocationType.compare("1") == 0)) {
        error = "Got as reallocation type: "
        + this->reallocationType 
        + ". Expected reallocation type should be 0(bitMap) or 1(list of addresses) ";
        throw error;
    }
}


