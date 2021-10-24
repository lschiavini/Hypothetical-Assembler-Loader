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

    int i = 0;

    for (; i < numOfArgs; ++i) {
        if(this->isFileName(argv[i]) ) {
            
        } else {
            break;
        }
    }
    int chunksQuantity = std::atoi(argv[i]);
    std::vector<Chunk> chunks;
    int j = 0;
    for (; j < chunksQuantity/2; j++) {

        Chunk currentChunk;
        chunks.insert(chunks.begin(), currentChunk);
    }

    for (; j < chunksQuantity; j++) {
        Chunk currentChunk;
        chunks.insert(chunks.begin() + j/2, currentChunk);
    }


        // cout << argv[i] << "\n";
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




