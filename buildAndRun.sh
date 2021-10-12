#clear terminal
clear
rm ./bin/assemblerMain

# build steps
mkdir build
cd build
make clean
cmake ..
make
cd ..
rm -rf build

# run
./bin/assemblerMain -r 1 ./tests/bin.asm