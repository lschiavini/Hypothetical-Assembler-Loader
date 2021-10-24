cmake_minimum_required( VERSION 3.0 )

project( Hypothetical-Assembler-Loader VERSION 1.2)

# flags


# variables

set( loaderargsLib "lib/loaderargs/include")
set( simulatorLib "lib/simulator/include")
set( assemblerLib "lib/assembler/include")
set( loaderLib "lib/loader/include")

# include files
include_directories( include ${assemblerLib} ${loaderargsLib} ${simulatorLib} ${loaderLib} )
include(CTest)
enable_testing()
set (CMAKE_CXX_STANDARD 11)
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/libbin)
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/libbin)
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}./../bin)


# target
add_executable( assemblerMain 
./src/main.cpp 
./src/utils.cpp 
./src/stringUtils.cpp 
./src/chunk.cpp 
./src/objfile.cpp 
)

# 3rd party lib
add_subdirectory( ./lib/loaderargs )
target_link_libraries( assemblerMain loaderargs )

# 3rd party lib
add_subdirectory( ./lib/simulator )
target_link_libraries( assemblerMain simulator )

# 3rd party lib
add_subdirectory( ./lib/assembler )
target_link_libraries( assemblerMain assembler )

# 3rd party lib
add_subdirectory( ./lib/loader )
target_link_libraries( assemblerMain loader )

# # Statical libs
# add_library (utils STATIC src/utils.cpp)