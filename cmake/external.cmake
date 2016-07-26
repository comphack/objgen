# This file is part of COMP_hack.
#
# Copyright (C) 2010-2016 COMP_hack Team <compomega@tutanota.com>
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

# Enable the ExternalProject CMake module.
INCLUDE(ExternalProject)

ExternalProject_Add(
    sqrat

    GIT_REPOSITORY https://github.com/comphack/sqrat.git
    GIT_TAG comp_hack

    PREFIX ${CMAKE_CURRENT_BINARY_DIR}/sqrat
    CMAKE_ARGS -DCMAKE_INSTALL_PREFIX:PATH=<INSTALL_DIR> "-DCMAKE_CXX_FLAGS=-std=c++11 ${SPECIAL_COMPILER_FLAGS}"

    # Dump output to a log instead of the screen.
    LOG_DOWNLOAD ON
    LOG_CONFIGURE ON
    LOG_BUILD ON
    LOG_INSTALL ON
)

ExternalProject_Get_Property(sqrat INSTALL_DIR)

SET(SQRAT_INCLUDE_DIRS "${INSTALL_DIR}/include")

ExternalProject_Add(
    civet

    GIT_REPOSITORY https://github.com/comphack/civetweb.git
    GIT_TAG comp_hack

    PREFIX ${CMAKE_CURRENT_BINARY_DIR}/civetweb
    CMAKE_ARGS -DCMAKE_INSTALL_PREFIX:PATH=<INSTALL_DIR> -DBUILD_TESTING=OFF -DCIVETWEB_LIBRARIES_ONLY=ON -DCIVETWEB_ENABLE_SLL=ON -DCIVETWEB_ENABLE_SSL_DYNAMIC_LOADING=OFF -DCIVETWEB_ALLOW_WARNINGS=ON -DCIVETWEB_ENABLE_CXX=ON "-DCMAKE_CXX_FLAGS=-std=c++11 ${SPECIAL_COMPILER_FLAGS}"

    # Dump output to a log instead of the screen.
    LOG_DOWNLOAD OFF
    LOG_CONFIGURE OFF
    LOG_BUILD OFF
    LOG_INSTALL OFF

    #BUILD_BYPRODUCTS <INSTALL_DIR>/lib/libcivetweb.a
    #BUILD_BYPRODUCTS <INSTALL_DIR>/lib/libcxx-library.a
)

ExternalProject_Get_Property(civet INSTALL_DIR)

SET(CIVETWEB_INCLUDE_DIRS "${INSTALL_DIR}/include")

ADD_LIBRARY(civetweb STATIC IMPORTED)
ADD_DEPENDENCIES(civetweb civet)
SET_TARGET_PROPERTIES(civetweb PROPERTIES IMPORTED_LOCATION
    "${INSTALL_DIR}/lib/libcivetweb.a")

ADD_LIBRARY(civetweb-cxx STATIC IMPORTED)
ADD_DEPENDENCIES(civetweb-cxx civetweb)
SET_TARGET_PROPERTIES(civetweb-cxx PROPERTIES IMPORTED_LOCATION
    "${INSTALL_DIR}/lib/libcxx-library.a")

ExternalProject_Add(
    squirrel3

    GIT_REPOSITORY https://github.com/comphack/squirrel3.git
    GIT_TAG master

    PREFIX ${CMAKE_CURRENT_BINARY_DIR}/squirrel3
    CMAKE_ARGS -DCMAKE_INSTALL_PREFIX:PATH=<INSTALL_DIR> "-DCMAKE_CXX_FLAGS=-std=c++11 ${SPECIAL_COMPILER_FLAGS}"

    # Dump output to a log instead of the screen.
    LOG_DOWNLOAD ON
    LOG_CONFIGURE ON
    LOG_BUILD ON
    LOG_INSTALL ON

    #BUILD_BYPRODUCTS <INSTALL_DIR>/lib/libsquirrel.a
    #BUILD_BYPRODUCTS <INSTALL_DIR>/lib/libsqstdlib.a
)

ExternalProject_Get_Property(squirrel3 INSTALL_DIR)

SET(SQUIRREL_INCLUDE_DIRS "${INSTALL_DIR}/include")

ADD_LIBRARY(squirrel STATIC IMPORTED)
ADD_DEPENDENCIES(squirrel squirrel3)
SET_TARGET_PROPERTIES(squirrel PROPERTIES IMPORTED_LOCATION
    "${INSTALL_DIR}/lib/libsquirrel.a")

ADD_LIBRARY(sqstdlib STATIC IMPORTED)
ADD_DEPENDENCIES(sqstdlib squirrel3)
SET_TARGET_PROPERTIES(sqstdlib PROPERTIES IMPORTED_LOCATION
    "${INSTALL_DIR}/lib/libsqstdlib.a")

ExternalProject_Add(
    asio

    GIT_REPOSITORY https://github.com/chriskohlhoff/asio.git
    GIT_TAG asio-1-11-0

    PREFIX ${CMAKE_CURRENT_BINARY_DIR}/asio
    CMAKE_ARGS -DCMAKE_INSTALL_PREFIX:PATH=<INSTALL_DIR> "-DCMAKE_CXX_FLAGS=-std=c++11 ${SPECIAL_COMPILER_FLAGS}"

    CONFIGURE_COMMAND ""
    BUILD_COMMAND ""
    INSTALL_COMMAND ""

    # Dump output to a log instead of the screen.
    LOG_DOWNLOAD ON
    LOG_CONFIGURE ON
    LOG_BUILD ON
    LOG_INSTALL ON
)

ExternalProject_Get_Property(asio INSTALL_DIR)

SET(ASIO_INCLUDE_DIRS "${INSTALL_DIR}/src/asio/asio/include")

ExternalProject_Add(
    tinyxml2-ex

    GIT_REPOSITORY https://github.com/comphack/tinyxml2.git
    GIT_TAG comp_hack

    PREFIX ${CMAKE_CURRENT_BINARY_DIR}/tinyxml2
    CMAKE_ARGS -DCMAKE_INSTALL_PREFIX:PATH=<INSTALL_DIR> -DBUILD_SHARED_LIBS=OFF "-DCMAKE_CXX_FLAGS=-std=c++11 ${SPECIAL_COMPILER_FLAGS}"

    # Dump output to a log instead of the screen.
    LOG_DOWNLOAD ON
    LOG_CONFIGURE ON
    LOG_BUILD ON
    LOG_INSTALL ON

    #BUILD_BYPRODUCTS <INSTALL_DIR>/lib/libtinyxml2.a
)

ExternalProject_Get_Property(tinyxml2-ex INSTALL_DIR)

SET(TINYXML2_INCLUDE "${INSTALL_DIR}/include")

ADD_LIBRARY(tinyxml2 STATIC IMPORTED)
ADD_DEPENDENCIES(tinyxml2 tinyxml2-ex)
SET_TARGET_PROPERTIES(tinyxml2 PROPERTIES IMPORTED_LOCATION
    "${INSTALL_DIR}/lib/libtinyxml2.a")

ExternalProject_Add(
    yamlcpp

    GIT_REPOSITORY https://github.com/comphack/yaml-cpp.git
    GIT_TAG comp_hack

    PREFIX ${CMAKE_CURRENT_BINARY_DIR}/yaml-cpp
    CMAKE_ARGS -DCMAKE_INSTALL_PREFIX:PATH=<INSTALL_DIR> "-DCMAKE_CXX_FLAGS=-std=c++11 ${SPECIAL_COMPILER_FLAGS}"

    # Dump output to a log instead of the screen.
    LOG_DOWNLOAD ON
    LOG_CONFIGURE ON
    LOG_BUILD ON
    LOG_INSTALL ON

    #BUILD_BYPRODUCTS <INSTALL_DIR>/lib/libyaml-cpp.a
)

ExternalProject_Get_Property(yamlcpp INSTALL_DIR)

SET(YAML_INCLUDE "${INSTALL_DIR}/include")

ADD_LIBRARY(yaml-cpp STATIC IMPORTED)
ADD_DEPENDENCIES(yaml-cpp yamlcpp)
SET_TARGET_PROPERTIES(yaml-cpp PROPERTIES IMPORTED_LOCATION
    "${INSTALL_DIR}/lib/libyaml-cpp.a")

ExternalProject_Add(
    googletest

    GIT_REPOSITORY https://github.com/google/googletest.git

    PREFIX ${CMAKE_CURRENT_BINARY_DIR}/googletest
    CMAKE_ARGS -DCMAKE_INSTALL_PREFIX:PATH=<INSTALL_DIR> "-DCMAKE_CXX_FLAGS=-std=c++11 ${SPECIAL_COMPILER_FLAGS}"

    # Dump output to a log instead of the screen.
    LOG_DOWNLOAD ON
    LOG_CONFIGURE ON
    LOG_BUILD ON
    LOG_INSTALL ON

    #BUILD_BYPRODUCTS <INSTALL_DIR>/lib/libgtest.a <INSTALL_DIR>/lib/libgmock.a
        <INSTALL_DIR>/lib/libgmock_main.a
)

ExternalProject_Get_Property(googletest INSTALL_DIR)

SET(GTEST_INCLUDE_DIRS "${INSTALL_DIR}/include")

ADD_LIBRARY(gtest STATIC IMPORTED)
ADD_DEPENDENCIES(gtest googletest)
SET_TARGET_PROPERTIES(gtest PROPERTIES IMPORTED_LOCATION
    "${INSTALL_DIR}/lib/libgtest.a")

ADD_LIBRARY(gmock STATIC IMPORTED)
ADD_DEPENDENCIES(gmock googletest)
SET_TARGET_PROPERTIES(gmock PROPERTIES IMPORTED_LOCATION
    "${INSTALL_DIR}/lib/libgmock.a")

ADD_LIBRARY(gmock_main STATIC IMPORTED)
ADD_DEPENDENCIES(gmock_main googletest)
SET_TARGET_PROPERTIES(gmock_main PROPERTIES IMPORTED_LOCATION
    "${INSTALL_DIR}/lib/libgmock_main.a")

SET(GMOCK_DIR "${INSTALL_DIR}")

# Set the name of the project.
PROJECT(comphack)

# Determine if the system is FreeBSD.
IF(CMAKE_SYSTEM_NAME MATCHES "FreeBSD")
    SET(BSD TRUE)
ENDIF(CMAKE_SYSTEM_NAME MATCHES "FreeBSD")

FIND_PACKAGE(ZLIB REQUIRED)
FIND_PACKAGE(Threads REQUIRED)

SET(Boost_USE_STATIC_LIBS OFF)
FIND_PACKAGE(Boost "1.40" COMPONENTS thread system regex date_time
    program_options)

ExternalProject_Add(
    cucumbercpp

    GIT_REPOSITORY https://github.com/comphack/cucumber-cpp.git
    GIT_TAG comp_hack

    CMAKE_ARGS "-DGMOCK_DIR=${GMOCK_DIR}" -DCUKE_DISABLE_E2E_TESTS=ON
        -DCUKE_DISABLE_UNIT_TESTS=ON

    DEPENDS googletest

    PREFIX ${CMAKE_CURRENT_BINARY_DIR}/cucumber-cpp
    CMAKE_ARGS -DCMAKE_INSTALL_PREFIX:PATH=<INSTALL_DIR> "-DCMAKE_CXX_FLAGS=-std=c++11 ${SPECIAL_COMPILER_FLAGS}"

    # Dump output to a log instead of the screen.
    LOG_DOWNLOAD ON
    LOG_CONFIGURE ON
    LOG_BUILD ON
    LOG_INSTALL ON

    #BUILD_BYPRODUCTS <INSTALL_DIR>/lib/libcucumber-cpp.a
        <INSTALL_DIR>/lib/libcucumber-cpp-nomain.a
)

ExternalProject_Get_Property(cucumbercpp INSTALL_DIR)

ADD_LIBRARY(cucumber-cpp STATIC IMPORTED)
ADD_DEPENDENCIES(cucumber-cpp cucumbercpp)
SET_TARGET_PROPERTIES(cucumber-cpp PROPERTIES IMPORTED_LOCATION
    "${INSTALL_DIR}/lib/libcucumber-cpp.a")

ADD_LIBRARY(cucumber-cpp-nomain STATIC IMPORTED)
ADD_DEPENDENCIES(cucumber-cpp-nomain cucumbercpp)
SET_TARGET_PROPERTIES(cucumber-cpp-nomain PROPERTIES IMPORTED_LOCATION
    "${INSTALL_DIR}/lib/libcucumber-cpp-nomain.a")

SET(CUKE_INCLUDE_DIR "${INSTALL_DIR}/include" ${Boost_INCLUDE_DIRS})
SET(CUKE_LIBRARIES cucumber-cpp gmock gmock_main gtest
    ${Boost_THREAD_LIBRARY} ${Boost_SYSTEM_LIBRARY}
    ${Boost_REGEX_LIBRARY} ${Boost_DATE_TIME_LIBRARY}
    ${Boost_PROGRAM_OPTIONS_LIBRARY}
    ${CMAKE_THREAD_LIBS_INIT})
