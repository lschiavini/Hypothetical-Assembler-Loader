
#include <fstream>
#include <iostream>

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

// template <typename T>
// void Append(std::vector<T>& a, const std::vector<T>& b)
// {
//     a.reserve(a.size() + b.size());
//     a.insert(a.end(), b.begin(), b.end());
// }