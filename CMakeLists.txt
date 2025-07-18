cmake_minimum_required(VERSION 3.25)

project("Biblioteca")



if(NOT DEFINED CMAKE_HOST_WIN32 OR NOT WIN32)
	message(FATAL_ERROR "Biblioteca only works on Windows hosts and targets")
endif()


set(CMAKE_CXX_STANDARD 20)

set(BINARY_OUTPUT_DIR "${CMAKE_CURRENT_SOURCE_DIR}/bin")
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${BINARY_OUTPUT_DIR})
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${BINARY_OUTPUT_DIR})
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${BINARY_OUTPUT_DIR})


# Windows Unicode
add_compile_definitions(UNICODE _UNICODE)


function(_add_library_gen TARGET DLL_PATH OUT_DIR)

	get_filename_component(DLL_ABS ${DLL_PATH} ABSOLUTE)
	get_filename_component(OUT_ABS ${OUT_DIR} ABSOLUTE)

	get_filename_component(DLL_DIR ${DLL_ABS} DIRECTORY)
	get_filename_component(DLL_NAME_WE ${DLL_ABS} NAME_WE)
	get_filename_component(DLL_NAME ${DLL_ABS} NAME)

	set(LIB_NAME "${DLL_NAME_WE}.lib")
	set(LIB_ABS "${OUT_ABS}/${LIB_NAME}")

	add_custom_command(
		OUTPUT ${LIB_ABS}
		COMMAND ${CMAKE_CURRENT_SOURCE_DIR}/tools/libgen.cmd ${DLL_NAME} ${OUT_ABS} x86
		WORKING_DIRECTORY ${DLL_DIR}
		DEPENDS ${DLL_ABS}
		COMMENT "Generating library \"${LIB_NAME}\" for target \"${TARGET}\""
		VERBATIM
	)

	add_custom_target(${LIB_NAME} DEPENDS ${LIB_ABS})

	add_library(${TARGET} INTERFACE)
	target_link_libraries(${TARGET} INTERFACE ${LIB_ABS})

endfunction()

function(_steam_library_path VARIABLE APPID)

	cmake_host_system_information(RESULT STEAM_PATH QUERY WINDOWS_REGISTRY "HKCU/Software/Valve/Steam" VALUE "SteamPath")

	if(NOT EXISTS ${STEAM_PATH})
		return()
	endif()

	file(READ "${STEAM_PATH}/steamapps/libraryfolders.vdf" VDF) # TODO Check what happens without the game installed

	set(REGEX_STR ".*\"path\"\t\t\"([^\"]*)\"[^}]*${APPID}.*")

	string(REGEX REPLACE ${REGEX_STR} "\\1" LIBRARY_PATH ${VDF})

	set(${VARIABLE} ${LIBRARY_PATH})
	return(PROPAGATE ${VARIABLE})

endfunction()


if(NOT EXISTS ${BIBLIOTECA_GAME_PATH})

	if(DEFINED BIBLIOTECA_GAME_PATH)
		message(WARNING "Specified game path does not exist, searching Steam library")
	endif()

	set(BIBLIOTECA_GAME_PATH "")

	_steam_library_path(BIBLIOTECA_GAME_PATH 18400)
	cmake_path(APPEND_STRING BIBLIOTECA_GAME_PATH "/steamapps/common/Crazy Machines 2/")

	if(NOT EXISTS ${BIBLIOTECA_GAME_PATH})
		message(FATAL_ERROR "Could not find game path from Steam, please provide a valid BIBLIOTECA_GAME_PATH")
	endif()

endif()

message(STATUS "Crazy Machines 2 path: \"${BIBLIOTECA_GAME_PATH}\"")


function(_add_game_dll TARGET PATH SHA256)

	cmake_path(APPEND_STRING BIBLIOTECA_GAME_PATH ${PATH} OUTPUT_VARIABLE PATH)

	if(NOT EXISTS ${PATH})
		message(FATAL_ERROR "Game DLL (${TARGET}) missing at \"${PATH}\", please verify game files integrity")
	endif()

	file(SHA256 ${PATH} HASH)

	if(NOT HASH STREQUAL SHA256)

		set(MESSAGE "Game DLL (${TARGET}) hash mismatch at \"${PATH}\"")

		if(BIBLIOTECA_IGNORE_HASH)
			message(WARNING "${MESSAGE}, ignoring")
		else()
			message(FATAL_ERROR "${MESSAGE}, your build may not be supported (check Biblioteca's README.md for compatibility information)")
		endif()

	endif()

	_add_library_gen(${TARGET} ${PATH} "${CMAKE_CURRENT_SOURCE_DIR}/bin")

	file(GLOB_RECURSE HEADERS RELATIVE ${CMAKE_CURRENT_SOURCE_DIR} "${CMAKE_CURRENT_SOURCE_DIR}/include/${TARGET}/*.hpp")
	target_sources(${TARGET} INTERFACE FILE_SET HEADERS BASE_DIRS "${CMAKE_CURRENT_SOURCE_DIR}/include" FILES ${HEADERS})

endfunction()

_add_game_dll(faktum	"faktum.dll"	"8351dd5f11d2a1ee02258f2f638fe55630f7476852864b7bfe746cab3f2c42a8")
_add_game_dll(cm2		"cm2.dll"		"d02eb73c7423bdcd091b889b15c3b514e269fc3bba2b0ce33bed0d7e54bb76d2")

target_link_libraries(cm2 INTERFACE faktum)


if(PROJECT_IS_TOP_LEVEL AND EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/main.cpp") # Fast testing

	add_executable(test "${CMAKE_CURRENT_SOURCE_DIR}/main.cpp")
	target_link_libraries(test faktum cm2)

endif()
