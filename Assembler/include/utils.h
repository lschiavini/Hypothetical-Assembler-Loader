
#pragma once
#ifndef UTILS_H
#define UTILS_H


#include <fstream>
#include <iostream>
#include <vector>
#include <unordered_set>

void resetsReadAndWritePositions(std::fstream *sourceFile);
void printFile(std::fstream *source);
void eliminateDuplicates(std::vector <uint16_t> &v);

#endif