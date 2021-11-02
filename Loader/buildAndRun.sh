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
./bin/assemblerMain ./tests/program1.obj ./tests/program2.obj ./tests/program3.obj 3 15 20 30 1000 2000 3000
# ./bin/assemblerMain ./tests/program1.obj ./tests/program2.obj 3 15 20 30 1000 2000 3000