#
#  CMake for libspeex
#

cmake_minimum_required(VERSION 2.8 FATAL_ERROR)

project(libspeex)

#set(CMAKE_ALLOW_LOOSE_LOOP_CONSTRUCTS true)
#set(CMAKE_MODULE_PATH "${PROJECT_SOURCE_DIR}/../cmake" "${PROJECT_SOURCE_DIR}/cmake_modules")

#set(LINUX_PACKAGE_GENERATOR "DEB")
#set(LINUX_PACKAGE_GENERATOR "RPM")

#setting and check for OpenHRI
set(SRC_DIRS "${PROJECT_SOURCE_DIR}/libspeex")

list(APPEND INCLUDE_DIRS "${PROJECT_SOURCE_DIR}/libspeex")
#list(APPEND LIBRARY_DIRS)

if (WIN32)
#  list(APPEND LIBRARIES ${PORTAUDIO_LIBRARIES} "winmm.lib")
else (WIN32)
#  list(APPEND LIBRARIES ${PORTAUDIO_LIBRARIES})
endif(WIN32)


#add_definitions(-DWIN32 -D_LIB -DHAVE_CONFIG_H /W4 /Ox /Oi /Ot /GL /GF /MT /GS)
add_definitions(-DWIN32 -D_LIB -DHAVE_CONFIG_H /W4 /Oi /Ot /GL /GF /MT /GS)
#Error to Debug build with /Ox 

set(SPEEX_SRCS
	./libspeex/bits.c
	./libspeex/cb_search.c
	./libspeex/exc_10_16_table.c
	./libspeex/exc_10_32_table.c
	./libspeex/exc_20_32_table.c
	./libspeex/exc_5_256_table.c
	./libspeex/exc_5_64_table.c
	./libspeex/exc_8_128_table.c
	./libspeex/fftwrap.c
	./libspeex/filterbank.c
	./libspeex/filters.c
	./libspeex/gain_table.c
	./libspeex/gain_table_lbr.c
	./libspeex/hexc_10_32_table.c
	./libspeex/hexc_table.c
	./libspeex/high_lsp_tables.c
	./libspeex/jitter.c
	./libspeex/kiss_fft.c
	./libspeex/kiss_fftr.c
	./libspeex/lpc.c
	./libspeex/lsp.c
	./libspeex/lsp_tables_nb.c
	./libspeex/ltp.c
	./libspeex/mdf.c
	./libspeex/modes.c
	./libspeex/modes_wb.c
	./libspeex/nb_celp.c
	./libspeex/preprocess.c
	./libspeex/quant_lsp.c
	./libspeex/sb_celp.c
	./libspeex/smallft.c
	./libspeex/speex.c
	./libspeex/speex_callbacks.c
	./libspeex/speex_header.c
	./libspeex/stereo.c
	./libspeex/vbr.c
	./libspeex/vq.c
	./libspeex/window.c
	)

set(SPEEX_SRC
	bits.c
	cb_search.c
	exc_10_16_table.c
	exc_10_32_table.c
	exc_20_32_table.c
	exc_5_256_table.c
	exc_5_64_table.c
	exc_8_128_table.c
	fftwrap.c
	filterbank.c
	filters.c
	gain_table.c
	gain_table_lbr.c
	hexc_10_32_table.c
	hexc_table.c
	high_lsp_tables.c
	jitter.c
	kiss_fft.c
	kiss_fftr.c
	lpc.c
	lsp.c
	lsp_tables_nb.c
	ltp.c
	mdf.c
	modes.c
	modes_wb.c
	nb_celp.c
	preprocess.c
	quant_lsp.c
	sb_celp.c
	smallft.c
	speex.c
	speex_callbacks.c
	speex_header.c
	stereo.c
	vbr.c
	vq.c
	window.c
	)

include_directories(
	${PROJECT_SOURCE_DIR}/libspeex
	${PROJECT_SOURCE_DIR}/include
	${PROJECT_SOURCE_DIR}/Win32
	)

add_library(libspeex STATIC ${SPEEX_SRCS})

