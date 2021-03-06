#
#  CMake for DSArray Component
#

cmake_minimum_required(VERSION 2.8 FATAL_ERROR)

project(DSArray)

#file(TO_CMAKE_PATH $ENV{RTM_ROOT} rtm_root)

set(CMAKE_ALLOW_LOOSE_LOOP_CONSTRUCTS true)
set(CMAKE_MODULE_PATH "${PROJECT_SOURCE_DIR}/../cmake" "${PROJECT_SOURCE_DIR}/cmake_modules" )

set(LINUX_PACKAGE_GENERATOR "DEB")
#set(LINUX_PACKAGE_GENERATOR "RPM")

#setting  for OpenHRI
set(SRC_DIRS "${PROJECT_SOURCE_DIR}/../../src")

# check LIB installed for OpenHRI
find_package(Speex REQUIRED)

if (WIN32)
    list(APPEND INCLUDE_DIRS  ${SPEEX_INCLUDE_DIR})
    list(APPEND LIBRARY_DIRS  ${SPEEX_LIB_DIR})
    list(APPEND LIBRARIES ${SPEEX_LIB} "winmm.lib")
else (WIN32)
    list(APPEND LIBRARIES fftwrap)
    add_definitions(-DUSE_SMALLFT)
endif (WIN32)

ADD_DEFINITIONS(-DPACKAGE="${PACKAGE}" -DLOCALEDIR="${LOCALEDIR}")


# component settings
set(RTC_NAME "${PROJECT_NAME}")
set(RTC_VERSION "1.0.0")
set(RTC_LANG "c++")
set(RTC_DESCRIPTION "Sound localization Module by using microphone array, and, PortAudio and Speex Library.")
set(RTC_VENDOR "AIST")
set(RTC_MAINTAINER "openrtp@m.aist.go.jp")

string(TOLOWER ${RTC_NAME} PACKAGE_NAME)
set(PACKAGE_VERSION "${RTC_VERSION_MAJOR}.${RTC_VERSION_MINOR}.${RTC_VERSION_PATCH}")


set(LIBS_SRCS ${SRC_DIRS}/${PROJECT_NAME}.cpp  ${SRC_DIRS}/windowing.cpp )

set(LIBS_INCS ${SRC_DIRS}/${PROJECT_NAME}.h )

set(EXEC_SRCS ${SRC_DIRS}/${PROJECT_NAME}Comp.cpp )

set(OTHER_SRCS CMakeLists.txt Doxyfile.in
               ${PROJECT_NAME}.conf rtc.conf)

#set_target_properties(${PROJECT_NAME}Comp COMPILE_FLAGS -Wall)
include(RTC)
