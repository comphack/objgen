# This file is part of COMP_hack.
#
# Copyright (C) 2010-2018 COMP_hack Team <compomega@tutanota.com>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

CMAKE_MINIMUM_REQUIRED(VERSION 3.2.3)

#
# START OF VERSION CONSTANTS
#

# Last year the code was changed.
SET(VERSION_YEAR  2018)

# Major release (1 = pixie.)
SET(VERSION_MAJOR 3)

# Minor release (1 = SP1).
SET(VERSION_MINOR 8)

# Patch version (a hotfix).
SET(VERSION_PATCH 9)

# Codename for the version.
SET(VERSION_CODENAME "Hathor (UNSTABLE)")

#
# END OF VERSION CONSTANTS
#

# Make the code name friendly for the installer filename.
STRING(TOLOWER "${VERSION_CODENAME}" VERSION_CODENAME_C)
STRING(REPLACE " " "-" VERSION_CODENAME_C "${VERSION_CODENAME_C}")

# Use folders to organize the projects and files.
SET_PROPERTY(GLOBAL PROPERTY USE_FOLDERS ON)

# Only show Debug and Release configurations in Visual Studio.
IF(CMAKE_CUSTOM_CONFIGURATION_TYPES)
    SET(CMAKE_CONFIGURATION_TYPES "${CMAKE_CUSTOM_CONFIGURATION_TYPES}" CACHE STRING "" FORCE)
ELSEIF(CMAKE_CONFIGURATION_TYPES)
    SET(CMAKE_CONFIGURATION_TYPES "Debug;Release;RelWithDebInfo" CACHE STRING "" FORCE)
ENDIF()

PROJECT(comp_hack)

# Print the CMake version for debugging.
MESSAGE("-- CMake version: ${CMAKE_VERSION}")

# Our custom cmake modules.
SET(COMP_MODULE_PATH ${CMAKE_SOURCE_DIR}/cmake)

# Include our custom cmake modules.
SET(CMAKE_MODULE_PATH
    ${COMP_MODULE_PATH}
)

SET(CPACK_PACKAGE_NAME "objgen (${VERSION_CODENAME})")
SET(CPACK_PACKAGE_VENDOR "COMP_hack Team")
SET(CPACK_PACKAGE_CONTACT "compomega@tutanota.com")
SET(CPACK_PACKAGE_FILE_NAME "objgen-${VERSION_MAJOR}.${VERSION_MINOR}.${VERSION_PATCH}-${VERSION_CODENAME_C}")
SET(CPACK_RESOURCE_FILE_LICENSE "${CMAKE_SOURCE_DIR}/LICENSE.txt")
SET(CPACK_PACKAGE_VERSION_MAJOR ${VERSION_MAJOR})
SET(CPACK_PACKAGE_VERSION_MINOR ${VERSION_MINOR})
SET(CPACK_PACKAGE_VERSION_PATCH ${VERSION_PATCH})

IF(WIN32)
    SET(COMP_INSTALL_DIR "/")
    SET(CPACK_GENERATOR "ZIP;WIX")

    #SET(CPACK_WIX_ROOT "C:\\Program Files (x86)\\WiX Toolset v3.11")
    SET(CPACK_WIX_UPGRADE_GUID "A253D8BE-ED6C-43EF-A1C5-F378F269C9E4")
    SET(CPACK_WIX_PRODUCT_ICON "${CMAKE_SOURCE_DIR}/tools/bdpatch/res/bdpatch.ico")
    SET(CPACK_WIX_PROGRAM_MENU_FOLDER "COMP_hack")
    SET(CPACK_WIX_PROPERTY_ARPHELPLINK "https://github.com/comphack/objgen")
    SET(CPACK_PACKAGE_INSTALL_DIRECTORY "COMP_hack")
    SET(CPACK_PACKAGE_EXECUTABLES "comp_objgen;Object Generator")

    SET(CMAKE_INSTALL_SYSTEM_RUNTIME_LIBS_SKIP TRUE)

    INCLUDE(InstallRequiredSystemLibraries)

    INSTALL(
        PROGRAMS ${CMAKE_INSTALL_SYSTEM_RUNTIME_LIBS}
        DESTINATION /
    )
ELSE()
    SET(COMP_INSTALL_DIR "bin")
    SET(CPACK_GENERATOR "TGZ;TBZ2;DEB")
ENDIF()

IF(NOT WIN32)
    INCLUDE(GNUInstallDirs)
ENDIF(NOT WIN32)

# Enable the CPack module for building installers.
INCLUDE(CPack)

# Utilities to add and remove compiler flags.
INCLUDE(${COMP_MODULE_PATH}/flags.cmake)

# Utilities for building with MSVC.
INCLUDE(${COMP_MODULE_PATH}/msvc.cmake)

# Option to disable build warnings/errors.
OPTION(NO_WARNINGS "Disable the compiler warnings and errors." OFF)

# Option to disable all tests.
OPTION(DISABLE_TESTING "Disable all tests." OFF)

# Option for the static runtime on Windows.
OPTION(USE_STATIC_RUNTIME "Use the static MSVC runtime." OFF)

IF(WIN32)
    OPTION(GENERATE_DOCUMENTATION "Generate documentation for the project." OFF)
ELSE()
    OPTION(GENERATE_DOCUMENTATION "Generate documentation for the project." ON)
ENDIF()

# Make sure MSVC uses the right runtime.
IF(USE_STATIC_RUNTIME)
    MSVC_RUNTIME(STATIC)
ELSE()
    MSVC_RUNTIME(DYNAMIC)
ENDIF()

# http://stackoverflow.com/questions/14933172/
IF("${CMAKE_CXX_COMPILER_ID}" STREQUAL "GNU")
    # Require at least GCC 4.9.
    IF(CMAKE_CXX_COMPILER_VERSION VERSION_LESS 4.9)
        MESSAGE(FATAL_ERROR "GCC version must be at least 4.9!")
    ENDIF()

    ADD_COMPILER_FLAGS(AUTO -fno-strict-aliasing)
ELSEIF("${CMAKE_CXX_COMPILER_ID}" STREQUAL "Clang")
    SET(SPECIAL_COMPILER_FLAGS "-stdlib=libc++")

    # Require at least Clang 3.4.
    IF(CMAKE_CXX_COMPILER_VERSION VERSION_LESS 3.4)
        MESSAGE(FATAL_ERROR "Clang version must be at least 3.4!")
    ENDIF()
ELSEIF("${CMAKE_CXX_COMPILER_ID}" STREQUAL "MSVC")
    # There is nothing special needed for MSVC.
ELSE()
    MESSAGE(WARNING "You are using an unsupported compiler!")
ENDIF()

INCLUDE(${COMP_MODULE_PATH}/DetermineOS.cmake)

# If the build should be optimized.
OPTION(BUILD_OPTIMIZED "Build an optimized release of the server." ON)

IF(BUILD_OPTIMIZED)
    SET(BUILD_VALGRIND_FRIENDLY OFF)
ELSE()
    SET(BUILD_VALGRIND_FRIENDLY ON)
ENDIF()

# Include all build code for external projects.
IF(EXISTS "${CMAKE_SOURCE_DIR}/binaries")
    MESSAGE("-- Using pre-built binaries.")

    INCLUDE(${COMP_MODULE_PATH}/binaries.cmake)

    IF(IS_DIRECTORY "${CMAKE_SOURCE_DIR}/dream" AND BUILD_DREAM)
        INCLUDE(${CMAKE_SOURCE_DIR}/dream/cmake/binaries.cmake)
    ENDIF(IS_DIRECTORY "${CMAKE_SOURCE_DIR}/dream" AND BUILD_DREAM)
ELSE()
    MESSAGE("-- Building external binaries.")

    INCLUDE(${COMP_MODULE_PATH}/external.cmake)

    IF(IS_DIRECTORY "${CMAKE_SOURCE_DIR}/dream" AND BUILD_DREAM)
        INCLUDE(${CMAKE_SOURCE_DIR}/dream/cmake/external.cmake)
    ENDIF(IS_DIRECTORY "${CMAKE_SOURCE_DIR}/dream" AND BUILD_DREAM)
ENDIF()

# PDB not found for library.
ADD_LINKER_FLAGS(AUTO /ignore:4099)

# UTF-8 source encoding for MSVC.
ADD_COMPILER_FLAGS(AUTO /utf-8 /bigobj)

# Build for Windows 7 and higher.
# See: https://msdn.microsoft.com/en-us/library/6sehtctf.aspx
ADD_COMPILER_FLAGS(WIN32 -DWINVER=0x601 -D_WIN32_WINNT=0x0601)

# Enable testing.
IF(NOT DISABLE_TESTING)
    INCLUDE(CTest)
ENDIF(NOT DISABLE_TESTING)

# Determine if the system is big or little endian.
INCLUDE(TestBigEndian)
TEST_BIG_ENDIAN(LIBCOMP_ENDIAN)
IF(${LIBCOMP_ENDIAN})
    ADD_DEFINITIONS(-DLIBCOMP_BIGENDIAN)
ELSE(${LIBCOMP_ENDIAN})
    ADD_DEFINITIONS(-DLIBCOMP_LITTLEENDIAN)
ENDIF(${LIBCOMP_ENDIAN})

# Default Linux (gcc/clang) builds to debug and MinGW builds to release.
IF(NOT MSVC)
    # Ensure C++14 support is on.
    ADD_CXX_FLAGS(AUTO -std=c++14)

    IF(NOT ("${SPECIAL_COMPILER_FLAGS}" STREQUAL ""))
        ADD_CXX_FLAGS(AUTO "${SPECIAL_COMPILER_FLAGS}")
    ENDIF()

    # Determine basic gcc/clang/mingw flags for release mode.
    IF(BUILD_OPTIMIZED)
        ADD_COMPILER_FLAGS(AUTO -O3 -msse3)
    ENDIF(BUILD_OPTIMIZED)

    # Strip release builds.
    ADD_LINKER_FLAGS_RELEASE(AUTO -s)
ENDIF(NOT MSVC)

# Disable MSVC warnings about the secure CRT functions.
ADD_COMPILER_FLAGS(WIN32 -D_CRT_SECURE_NO_WARNINGS)

# Specifies the kind of exception handling with MSVC.
ADD_COMPILER_FLAGS(AUTO /EHsc)

# If we are building in debug mode, define the debug flag.
ADD_COMPILER_FLAGS_DEBUG(AUTO -DCOMP_HACK_DEBUG)

# If we are using gcc/clang/mingw, enable warnings under debug mode.
IF(NO_WARNINGS)
    ADD_COMPILER_FLAGS(AUTO -g)
ELSE()
    ADD_COMPILER_FLAGS(AUTO -Werror -Wall -Wextra -Wshadow
        -Wconversion -Wsign-conversion -g)
ENDIF()

# Warning level 4 and treat warnings as errors (MSVC).
# ADD_COMPILER_FLAGS(AUTO /W4 /WX)

# When using gcc/clang/mingw, make sure everything defined is linked into
# the application or library.
ADD_EXE_LINKER_FLAGS(AUTO -Wl,--no-undefined)

# Place all executables in the same directory.
SET(EXECUTABLE_OUTPUT_PATH "${CMAKE_CURRENT_BINARY_DIR}/bin")

# List of common include paths for every project using libobjgen.
SET(LIBOBJGEN_INCLUDES
    ${GSL_INCLUDE_DIRS}
    ${CMAKE_SOURCE_DIR}/libobjgen/src
    # Needed for PushIgnore.h and PopIgnore.h.
    ${CMAKE_SOURCE_DIR}/libcomp/src
)

# List of common include paths for every project using libcomp.
SET(LIBCOMP_INCLUDES
    ${OPENSSL_INCLUDE_DIR}
    ${CMAKE_SOURCE_DIR}/libcomp/src
    ${CMAKE_BINARY_DIR}/libcomp/objgen
)

# This macro will create a target to generate the documentation using the
# specified Doxyfile.in file.
MACRO(GENERATE_DOCS doxyfile)
    # Make sure we have Doxygen.
    FIND_PACKAGE(Doxygen)

    # Only do something if we have Doxygen.
    If(DOXYGEN_FOUND AND GENERATE_DOCUMENTATION)
        # Replace CMake variables in the input Doxyfile.
        CONFIGURE_FILE(${doxyfile} ${CMAKE_CURRENT_BINARY_DIR}/Doxyfile @ONLY)

        # Create the target that will run Doxygen. The working directory is
        # the build directory so all the documentation ends up in the same
        # directory structure.
        IF(${PROJECT_NAME} MATCHES "libcomp")
            ADD_CUSTOM_TARGET(doc-${PROJECT_NAME} ${DOXYGEN_EXECUTABLE}
                ${CMAKE_CURRENT_BINARY_DIR}/Doxyfile WORKING_DIRECTORY
                ${CMAKE_BINARY_DIR} COMMENT
                "Generating ${PROJECT_NAME} API documentation" VERBATIM)
        ELSE(${PROJECT_NAME} MATCHES "libcomp")
            ADD_CUSTOM_TARGET(doc-${PROJECT_NAME} ${DOXYGEN_EXECUTABLE}
                ${CMAKE_CURRENT_BINARY_DIR}/Doxyfile WORKING_DIRECTORY
                ${CMAKE_BINARY_DIR} DEPENDS doc-libcomp COMMENT
                "Generating ${PROJECT_NAME} API documentation" VERBATIM)
        ENDIF(${PROJECT_NAME} MATCHES "libcomp")

        # Add the target to a list of documentation targets.
        GET_PROPERTY(targets GLOBAL PROPERTY DOC_TARGETS)
        SET_PROPERTY(GLOBAL PROPERTY DOC_TARGETS
            doc-${PROJECT_NAME} ${targets})
    ENDIF(DOXYGEN_FOUND AND GENERATE_DOCUMENTATION)
ENDMACRO(GENERATE_DOCS doxyfile)

# When building Windows executables, this macro packs the executable. This
# works by simply passing the same name you passed to ADD_EXECUTABLE to this
# macro. The executable will be packed in place. UPX is not used when using
# Microsoft Visual C++ or if DISABLE_UPX is defined.
MACRO(UPX_WRAP exefile)
IF(WIN32 AND NOT MSVC AND NOT DISABLE_UPX)
    # Get the path to the executable.
    GET_PROPERTY(exefile_path TARGET ${exefile} PROPERTY LOCATION)

    # Add a command to run UPX passing a compression of 9 and the path to
    # the target executable.
    ADD_CUSTOM_COMMAND(TARGET ${exefile} POST_BUILD
        COMMAND upx -9 ${exefile_path} 1> nul 2>&1)
ENDIF(WIN32 AND NOT MSVC AND NOT DISABLE_UPX)
ENDMACRO(UPX_WRAP exefile)

# If we are using mingw and the path to windres is not set, add a default path.
IF(MINGW AND NOT CMAKE_WINDRES_PATH)
    SET(CMAKE_WINDRES_PATH windres.exe)
ENDIF(MINGW AND NOT CMAKE_WINDRES_PATH)

# This macro is used to compile Windows resource files for either Microsoft
# Visual C++ or MinGW. Simply pass the name of the output variable followed
# by a list of resource file paths. The output variable will be filled and
# should then be passed as source files to the ADD_EXECUTABLE command.
MACRO(RES_WRAP outfiles)
IF(WIN32)
    IF(MINGW) # MinGW
        FOREACH(it ${ARGN}) # Process each resource file
            # Get the name of the file (without the extension) and the path
            # to the file. These are needed for the custom command.
            GET_FILENAME_COMPONENT(fn ${it} NAME_WE)
            GET_FILENAME_COMPONENT(fp ${it} PATH)

            # This command calls windres with the resource file and outputs
            # an object file with the _res.o suffix. This object file is then
            # linked to the executable (by adding the object file to the output
            # variable). The object file depends on the resource file.
            ADD_CUSTOM_COMMAND(OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/${fn}_res.o
                COMMAND ${CMAKE_WINDRES_PATH}
                -I${CMAKE_CURRENT_SOURCE_DIR}/${fp}
                -i${CMAKE_CURRENT_SOURCE_DIR}/${it}
                -o ${CMAKE_CURRENT_BINARY_DIR}/${fn}_res.o
                DEPENDS ${CMAKE_CURRENT_SOURCE_DIR}/${it})

            # Add the object file to the list of output files that will be
            # added to the ADD_EXECUTABLE command (and thus linked to the app).
            SET(${outfiles} ${${outfiles}}
                ${CMAKE_CURRENT_BINARY_DIR}/${fn}_res.o)
        ENDFOREACH(it ${ARGN})
    ELSE(MINGW) # Microsoft Visual C++
        FOREACH(it ${ARGN}) # Process each resource file
            # Simply add the resource file to the output variable and let cmake
            # handle it for us.
            SET(${outfiles} ${${outfiles}}
                ${CMAKE_CURRENT_SOURCE_DIR}/${it})
        ENDFOREACH(it ${ARGN})
    ENDIF(MINGW)
ENDIF(WIN32)
ENDMACRO(RES_WRAP outfiles)

# This macro takes a list of test names (for google-test, not cucumber), builds
# them, and adds them to the CTest framework. Note that the test file should
# be in the "tests" subdirectory of the project with the test name and a ".cpp"
# extension for this macro to work.
MACRO(CREATE_GTESTS)
    SET(EXPECT_TARGET False)
    SET(TEST_TARGET "test")
    SET(TEST_LIBS "")
    SET(HAVE_LIBS False)

    # Create a test based on each test name.
    FOREACH(test ${ARGN})
        IF("${test}" MATCHES "LIBS")
            SET(HAVE_LIBS False)
        ELSEIF("${test}" MATCHES "SRCS")
            SET(HAVE_LIBS True)
        ELSEIF("${test}" MATCHES "TARGET")
            SET(EXPECT_TARGET True)
        ELSEIF(EXPECT_TARGET)
            SET(TEST_TARGET ${test})
            SET(EXPECT_TARGET False)
        ELSEIF(HAVE_LIBS)
            # Prefix the test name with "Test".
            SET(ttest "Test${test}")

            # Generate the test executable.
            ADD_EXECUTABLE(${ttest} "tests/${test}.cpp")

            # Add this to the project folder.
            SET_TARGET_PROPERTIES(${ttest} PROPERTIES FOLDER
                "Tests/${PROJECT_NAME}")

            # Link the libraries to the test executable.
            TARGET_LINK_LIBRARIES(${ttest} gtest ${TEST_LIBS}
                ${CMAKE_THREAD_LIBS_INIT} ${ZLIB_LIBRARIES})

            # Add the test to CTest.
            IF("${TEST_TARGET}" STREQUAL "test")
                ADD_TEST(NAME ${test} COMMAND
                    ${EXECUTABLE_OUTPUT_PATH}/${ttest}
                    WORKING_DIRECTORY ${CMAKE_BINARY_DIR})
            ELSE()
                ADD_CUSTOM_COMMAND(TARGET ${TEST_TARGET} COMMAND
                    ${EXECUTABLE_OUTPUT_PATH}/${ttest}
                    WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
                    DEPENDS ${ttest})
            ENDIF()
        ELSE() # Must be a library.
            # Add the library to the list.
            SET(TEST_LIBS ${TEST_LIBS} ${test})
        ENDIF("${test}" MATCHES "LIBS")
    ENDFOREACH(test ${ARGN})
ENDMACRO(CREATE_GTESTS)

# This must come first so that objgen is found for the macro bellow. As a
# consequence, none of the tools can define their own structures to be
# generated by objgen. This is not a big deal because for the most part
# these should be defined in libcomp.
ADD_SUBDIRECTORY(libobjgen)
ADD_SUBDIRECTORY(tools)

# Make sure we have Doxygen.
FIND_PACKAGE(Doxygen)
