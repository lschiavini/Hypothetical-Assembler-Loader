#include <loaderargs.h>

LoaderArgs::~LoaderArgs(){}
LoaderArgs::LoaderArgs(){}

std::vector<ObjFile> LoaderArgs::getFiles() {
    return this->objFiles;
}
std::vector<Chunk> LoaderArgs::getChunks() {
    return this->chunks;
}

bool LoaderArgs::isFileName(std::string fileName){
    if (fileName.substr(fileName.find_last_of(".") + 1) != "obj") {
        return false;
    }
    return true;
}

void LoaderArgs::processArgs(std::fstream *source, int numOfArgs, char ** argv) {
    this->checkArgsForErrors(source, numOfArgs, argv);
    std::vector<std::string> fileNames;
    int i = 1;

    for (; i < numOfArgs; ++i) {
        if(this->isFileName(argv[i]) ) {
            fileNames.push_back(argv[i]);
        } else {
            break;
        }
    }

    std::cout << getListAsString(fileNames) << std::endl;

    int chunksQuantity = std::atoi(argv[i]);
    
    std::cout << "chunksQuantity " << chunksQuantity << std::endl;
    std::vector<Chunk> chunks;
    
    for (int j = 0; j < chunksQuantity; j++) {
        Chunk currentChunk;
        currentChunk.setSize(std::stoi(argv[i+j+1]));
        chunks.push_back(currentChunk);
        std::cout << chunks.at(j).getSize() << std::endl;
    }
    i+= chunksQuantity;

    for (int j = 0; j < chunksQuantity; j++) {
        chunks.at(j).setAddress(std::stoi(argv[i+j+1]));
        std::cout<< "Size: " 
            << chunks.at(j).getSize() 
            << " Address: " 
            << chunks.at(j).getAddress() 
            << std::endl;
    }

    this->chunks = chunks;
    // this->objFiles = fileNames;
    this->getFiles(fileNames);
}

void LoaderArgs::getFiles(std::vector<std::string> fileNames) {
    std::fstream sourceCode;
    for(auto &fileName : fileNames) {
        this->openFile(&sourceCode, fileName);
        std::string outputBuffer = "";
        while(std::getline(sourceCode, outputBuffer)) {
            std::cout << outputBuffer << std::endl;
        }
        sourceCode.close();
    }


}

void LoaderArgs::parseFileData(std::string fileLine) {

    // *(sourceCode)

}

void LoaderArgs::checkArgsForErrors(std::fstream *source, int numOfArgs, char ** argv) {
    if(numOfArgs == NULL) throw "nullPointer";
    std::fstream* sourceCodeContains = source;
    std::string error = "";

    // if (argc != this->argumentsExpected)
    // {
    //     error = "Arguments non compliant, requires three arguments, as in '[executablepath] -r 0|1 filename.asm' for 0 to mean bitmap reallocation and 1 as address list";
    //     throw error;
    // } else
    // {

        // this->checkHowManyFiles(argv);
        // this->getChunkFromArgs();

            



        // this->originalFileName = std::string(argv[3]);
        // this->reallocationType = std::string(argv[2]);
        // this->rArg = std::string(argv[1]);
        // this->execPath = std::string(argv[0]);

        // this->fileName = this->originalFileName; 

     
        // this->openFile(sourceCodeContains);
    // }
}

// numOfArgs = 1 + 2n + 1
// numOfArgs = 1 + 2n + 2
// numOfArgs = 1 + 2n + 3

// files 1 ->3 
// chunks quantity 1
// chunkssize n
// chunkaddresses n 

void LoaderArgs::checkHowManyFiles(char ** argv) {

}
void LoaderArgs::getChunkFromArgs() {

}


void LoaderArgs::openFile(std::fstream * sourceCodeContains, std::string originalFileName){
    std::string error = "";
    (*(sourceCodeContains)).open(originalFileName,std::ios::in);
    if ((*(sourceCodeContains)).good())
    {
        std::cout<<"File '"<< originalFileName<<"' opened successfully."<<std::endl;
    }else
    {
        error = "File not found.";
        throw error;
    }   
}




