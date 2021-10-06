#include <fstream>
#include <iostream>
#include <vector>
#include <unordered_set>

void resetsReadAndWritePositions(std::fstream *sourceFile) {
    sourceFile->clear();
    sourceFile->seekg( 0, sourceFile->beg);
    sourceFile->seekp( 0, sourceFile->beg);
}

void printFile(std::fstream *source) {
    std::string line;
    while (*(source) >> line) {
        std::cout << line << std::endl;
    }
    resetsReadAndWritePositions(source);
}

void eliminateDuplicates(std::vector <uint16_t> &v) {
    // TODO change to any type of vector
    if(v.size() > 0) {
        std::unordered_set<uint16_t> s(v.begin(), v.end());
        v.assign(s.begin(), s.end());
    }
}