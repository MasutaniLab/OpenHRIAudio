#
#  CMake for libspeex
#

cmake_minimum_required(VERSION 2.8 FATAL_ERROR)

project(libresample)

set(SRC_DIRS "${PROJECT_SOURCE_DIR}/src")

list(APPEND INCLUDE_DIRS "${PROJECT_SOURCE_DIR}/libspeex")
#list(APPEND LIBRARY_DIRS)

if (WIN32)
#  list(APPEND LIBRARIES ${PORTAUDIO_LIBRARIES} "winmm.lib")
else (WIN32)
#  list(APPEND LIBRARIES ${PORTAUDIO_LIBRARIES})
endif(WIN32)


add_definitions(-DWIN32 -DNDEBUG -D_LIB -DHAVE_CONFIG_H 
			/W4 /Ox /Oi /Ot /GL /GF /MT /GS)

#include_directories(
#	${PROJECT_SOURCE_DIR}/libspeex
#	${PROJECT_SOURCE_DIR}/include
#	${PROJECT_SOURCE_DIR}/Win32
#	)

set(SRC filterkit.c
	resample.c
	resamplesubs.c)

add_library(libresample STATIC ./src/resample.c ./src/resamplesubs.c ./src/filterkit.c)

