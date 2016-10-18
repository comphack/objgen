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
    zlib-lib

    GIT_REPOSITORY https://github.com/comphack/zlib.git
    GIT_TAG comp_hack

    PREFIX ${CMAKE_CURRENT_BINARY_DIR}/zlib
    CMAKE_ARGS -DCMAKE_INSTALL_PREFIX:PATH=<INSTALL_DIR> -DSKIP_INSTALL_FILES=ON -DUSE_STATIC_RUNTIME=${USE_STATIC_RUNTIME}

    # Dump output to a log instead of the screen.
    LOG_DOWNLOAD ON
    LOG_CONFIGURE ON
    LOG_BUILD ON
    LOG_INSTALL ON

    BUILD_BYPRODUCTS <INSTALL_DIR>/lib/libz.a
    BUILD_BYPRODUCTS <INSTALL_DIR>/lib/zlibstatic.lib
    BUILD_BYPRODUCTS <INSTALL_DIR>/lib/zlibstaticd.lib
)

ExternalProject_Get_Property(zlib-lib INSTALL_DIR)

SET_TARGET_PROPERTIES(zlib-lib PROPERTIES FOLDER "Dependencies")

SET(ZLIB_INCLUDES "${INSTALL_DIR}/include")
SET(ZLIB_LIBRARIES zlib)

ADD_LIBRARY(zlib STATIC IMPORTED)
ADD_DEPENDENCIES(zlib zlib-lib)

IF(WIN32)
    SET_TARGET_PROPERTIES(zlib PROPERTIES
        IMPORTED_LOCATION_RELEASE "${INSTALL_DIR}/lib/zlibstatic.lib"
        IMPORTED_LOCATION_DEBUG "${INSTALL_DIR}/lib/zlibstaticd.lib")
ELSE()
    SET_TARGET_PROPERTIES(zlib PROPERTIES
        IMPORTED_LOCATION "${INSTALL_DIR}/lib/libz.a")
ENDIF()

ExternalProject_Add(
    openssl

    GIT_REPOSITORY https://github.com/comphack/openssl.git
    GIT_TAG comp_hack

    PREFIX ${CMAKE_CURRENT_BINARY_DIR}/openssl
    CMAKE_ARGS -DCMAKE_INSTALL_PREFIX:PATH=<INSTALL_DIR> -DUSE_STATIC_RUNTIME=${USE_STATIC_RUNTIME} -DCMAKE_DEBUG_POSTFIX=d

    # Dump output to a log instead of the screen.
    LOG_DOWNLOAD ON
    LOG_CONFIGURE ON
    LOG_BUILD ON
    LOG_INSTALL ON

    BUILD_BYPRODUCTS <INSTALL_DIR>/lib/${CMAKE_STATIC_LIBRARY_PREFIX}ssl${CMAKE_STATIC_LIBRARY_SUFFIX}
    BUILD_BYPRODUCTS <INSTALL_DIR>/lib/${CMAKE_STATIC_LIBRARY_PREFIX}crypto${CMAKE_STATIC_LIBRARY_SUFFIX}

    BUILD_BYPRODUCTS <INSTALL_DIR>/lib/${CMAKE_STATIC_LIBRARY_PREFIX}ssleay32${CMAKE_STATIC_LIBRARY_SUFFIX}
    BUILD_BYPRODUCTS <INSTALL_DIR>/lib/${CMAKE_STATIC_LIBRARY_PREFIX}libeay32${CMAKE_STATIC_LIBRARY_SUFFIX}

    BUILD_BYPRODUCTS <INSTALL_DIR>/lib/${CMAKE_STATIC_LIBRARY_PREFIX}ssleay32d${CMAKE_STATIC_LIBRARY_SUFFIX}
    BUILD_BYPRODUCTS <INSTALL_DIR>/lib/${CMAKE_STATIC_LIBRARY_PREFIX}libeay32d${CMAKE_STATIC_LIBRARY_SUFFIX}
)

ExternalProject_Get_Property(openssl INSTALL_DIR)

SET_TARGET_PROPERTIES(openssl PROPERTIES FOLDER "Dependencies")

SET(OPENSSL_INCLUDE_DIR "${INSTALL_DIR}/include")
SET(OPENSSL_ROOT_DIR "${INSTALL_DIR}")

IF(WIN32)
    SET(OPENSSL_LIBRARIES ssleay32 libeay32)
ELSE()
    SET(OPENSSL_LIBRARIES ssl crypto)
ENDIF()

IF(WIN32)
    ADD_LIBRARY(ssleay32 STATIC IMPORTED)
    ADD_DEPENDENCIES(ssleay32 openssl)
    SET_TARGET_PROPERTIES(ssleay32 PROPERTIES
        IMPORTED_LOCATION_RELEASE "${INSTALL_DIR}/lib/${CMAKE_STATIC_LIBRARY_PREFIX}ssleay32${CMAKE_STATIC_LIBRARY_SUFFIX}"
        IMPORTED_LOCATION_DEBUG "${INSTALL_DIR}/lib/${CMAKE_STATIC_LIBRARY_PREFIX}ssleay32d${CMAKE_STATIC_LIBRARY_SUFFIX}")

    ADD_LIBRARY(libeay32 STATIC IMPORTED)
    ADD_DEPENDENCIES(libeay32 openssl)
    SET_TARGET_PROPERTIES(libeay32 PROPERTIES
        IMPORTED_LOCATION_RELEASE "${INSTALL_DIR}/lib/${CMAKE_STATIC_LIBRARY_PREFIX}libeay32${CMAKE_STATIC_LIBRARY_SUFFIX}"
        IMPORTED_LOCATION_DEBUG "${INSTALL_DIR}/lib/${CMAKE_STATIC_LIBRARY_PREFIX}libeay32d${CMAKE_STATIC_LIBRARY_SUFFIX}")
ELSE()
    ADD_LIBRARY(ssl STATIC IMPORTED)
    ADD_DEPENDENCIES(ssl openssl)
    SET_TARGET_PROPERTIES(ssl PROPERTIES IMPORTED_LOCATION
        "${INSTALL_DIR}/lib/${CMAKE_STATIC_LIBRARY_PREFIX}ssl${CMAKE_STATIC_LIBRARY_SUFFIX}")

    ADD_LIBRARY(crypto STATIC IMPORTED)
    ADD_DEPENDENCIES(crypto openssl)
    SET_TARGET_PROPERTIES(crypto PROPERTIES IMPORTED_LOCATION
        "${INSTALL_DIR}/lib/${CMAKE_STATIC_LIBRARY_PREFIX}crypto${CMAKE_STATIC_LIBRARY_SUFFIX}")
ENDIF()

ExternalProject_Add(
    libuv

    GIT_REPOSITORY https://github.com/comphack/libuv.git
    GIT_TAG comp_hack

    PREFIX ${CMAKE_CURRENT_BINARY_DIR}/libuv
    CMAKE_ARGS -DCMAKE_INSTALL_PREFIX:PATH=<INSTALL_DIR> -DUSE_STATIC_RUNTIME=${USE_STATIC_RUNTIME} -DCMAKE_DEBUG_POSTFIX=d

    # Dump output to a log instead of the screen.
    LOG_DOWNLOAD ON
    LOG_CONFIGURE ON
    LOG_BUILD ON
    LOG_INSTALL ON

    BUILD_BYPRODUCTS <INSTALL_DIR>/lib/${CMAKE_STATIC_LIBRARY_PREFIX}uv${CMAKE_STATIC_LIBRARY_SUFFIX}
    BUILD_BYPRODUCTS <INSTALL_DIR>/lib/${CMAKE_STATIC_LIBRARY_PREFIX}uvd${CMAKE_STATIC_LIBRARY_SUFFIX}
)

ExternalProject_Get_Property(libuv INSTALL_DIR)

SET_TARGET_PROPERTIES(libuv PROPERTIES FOLDER "Dependencies")

SET(LIBUV_INCLUDE_DIRS "${INSTALL_DIR}/include")
SET(LIBUV_ROOT_DIR "${INSTALL_DIR}")

ADD_LIBRARY(uv STATIC IMPORTED)
ADD_DEPENDENCIES(uv libuv)

IF(WIN32)
    SET_TARGET_PROPERTIES(uv PROPERTIES
        IMPORTED_LOCATION_RELEASE "${INSTALL_DIR}/lib/${CMAKE_STATIC_LIBRARY_PREFIX}uv${CMAKE_STATIC_LIBRARY_SUFFIX}"
        IMPORTED_LOCATION_DEBUG "${INSTALL_DIR}/lib/${CMAKE_STATIC_LIBRARY_PREFIX}uvd${CMAKE_STATIC_LIBRARY_SUFFIX}")
ELSE()
    SET_TARGET_PROPERTIES(uv PROPERTIES IMPORTED_LOCATION
        "${INSTALL_DIR}/lib/${CMAKE_STATIC_LIBRARY_PREFIX}uv${CMAKE_STATIC_LIBRARY_SUFFIX}")
ENDIF()

ExternalProject_Add(
    cassandra-cpp

    GIT_REPOSITORY https://github.com/comphack/cpp-driver.git
    GIT_TAG comp_hack

    DEPENDS libuv openssl zlib-lib

    PREFIX ${CMAKE_CURRENT_BINARY_DIR}/cassandra
    CMAKE_ARGS -DCMAKE_INSTALL_PREFIX:PATH=<INSTALL_DIR> "-DCMAKE_CXX_FLAGS=-std=c++11 ${SPECIAL_COMPILER_FLAGS}" "-DLIBUV_ROOT_DIR=${LIBUV_ROOT_DIR}" "-DOPENSSL_ROOT_DIR=${OPENSSL_ROOT_DIR}" -DCASS_BUILD_SHARED=OFF -DCASS_BUILD_STATIC=ON -DCASS_USE_STATIC_LIBS=ON -DCASS_USE_STD_ATOMIC=ON -DCASS_USE_ZLIB=ON -DUSE_STATIC_RUNTIME=${USE_STATIC_RUNTIME} -DCMAKE_DEBUG_POSTFIX=d

    # Dump output to a log instead of the screen.
    LOG_DOWNLOAD ON
    LOG_CONFIGURE ON
    LOG_BUILD ON
    LOG_INSTALL ON

    BUILD_BYPRODUCTS <INSTALL_DIR>/lib/${CMAKE_STATIC_LIBRARY_PREFIX}cassandra_static${CMAKE_STATIC_LIBRARY_SUFFIX}
    BUILD_BYPRODUCTS <INSTALL_DIR>/lib/${CMAKE_STATIC_LIBRARY_PREFIX}cassandra_staticd${CMAKE_STATIC_LIBRARY_SUFFIX}
)

ExternalProject_Get_Property(cassandra-cpp INSTALL_DIR)

SET_TARGET_PROPERTIES(cassandra-cpp PROPERTIES FOLDER "Dependencies")

SET(CASSANDRA_INCLUDE_DIRS "${INSTALL_DIR}/include")

ADD_LIBRARY(cassandra STATIC IMPORTED)
ADD_DEPENDENCIES(cassandra cassandra-cpp)

IF(WIN32)
    SET_TARGET_PROPERTIES(cassandra PROPERTIES
        IMPORTED_LOCATION_RELEASE "${INSTALL_DIR}/lib/${CMAKE_STATIC_LIBRARY_PREFIX}cassandra_static${CMAKE_STATIC_LIBRARY_SUFFIX}"
        IMPORTED_LOCATION_DEBUG "${INSTALL_DIR}/lib/${CMAKE_STATIC_LIBRARY_PREFIX}cassandra_staticd${CMAKE_STATIC_LIBRARY_SUFFIX}")
ELSE()
    SET_TARGET_PROPERTIES(cassandra PROPERTIES IMPORTED_LOCATION
        "${INSTALL_DIR}/lib/${CMAKE_STATIC_LIBRARY_PREFIX}cassandra_static${CMAKE_STATIC_LIBRARY_SUFFIX}")
ENDIF()

ExternalProject_Add(
    ttvfs-ex

    GIT_REPOSITORY https://github.com/comphack/ttvfs.git
    GIT_TAG comp_hack

    PREFIX ${CMAKE_CURRENT_BINARY_DIR}/ttvfs
    CMAKE_ARGS -DCMAKE_INSTALL_PREFIX:PATH=<INSTALL_DIR> "-DCMAKE_CXX_FLAGS=-std=c++11 ${SPECIAL_COMPILER_FLAGS}" -DUSE_STATIC_RUNTIME=${USE_STATIC_RUNTIME} -DCMAKE_DEBUG_POSTFIX=d

    # Dump output to a log instead of the screen.
    LOG_DOWNLOAD ON
    LOG_CONFIGURE ON
    LOG_BUILD ON
    LOG_INSTALL ON

    BUILD_BYPRODUCTS <INSTALL_DIR>/lib/${CMAKE_STATIC_LIBRARY_PREFIX}ttvfs${CMAKE_STATIC_LIBRARY_SUFFIX}
    BUILD_BYPRODUCTS <INSTALL_DIR>/lib/${CMAKE_STATIC_LIBRARY_PREFIX}ttvfs_cfileapi${CMAKE_STATIC_LIBRARY_SUFFIX}
    BUILD_BYPRODUCTS <INSTALL_DIR>/lib/${CMAKE_STATIC_LIBRARY_PREFIX}ttvfs_zip${CMAKE_STATIC_LIBRARY_SUFFIX}

    BUILD_BYPRODUCTS <INSTALL_DIR>/lib/${CMAKE_STATIC_LIBRARY_PREFIX}ttvfsd${CMAKE_STATIC_LIBRARY_SUFFIX}
    BUILD_BYPRODUCTS <INSTALL_DIR>/lib/${CMAKE_STATIC_LIBRARY_PREFIX}ttvfs_cfileapid${CMAKE_STATIC_LIBRARY_SUFFIX}
    BUILD_BYPRODUCTS <INSTALL_DIR>/lib/${CMAKE_STATIC_LIBRARY_PREFIX}ttvfs_zipd${CMAKE_STATIC_LIBRARY_SUFFIX}
)

ExternalProject_Get_Property(ttvfs-ex INSTALL_DIR)

SET_TARGET_PROPERTIES(ttvfs-ex PROPERTIES FOLDER "Dependencies")

SET(TTVFS_INCLUDE_DIRS "${INSTALL_DIR}/include")

ADD_LIBRARY(ttvfs STATIC IMPORTED)
ADD_DEPENDENCIES(ttvfs ttvfs-ex)

IF(WIN32)
    SET_TARGET_PROPERTIES(ttvfs PROPERTIES
        IMPORTED_LOCATION_RELEASE "${INSTALL_DIR}/lib/${CMAKE_STATIC_LIBRARY_PREFIX}ttvfs${CMAKE_STATIC_LIBRARY_SUFFIX}"
        IMPORTED_LOCATION_DEBUG "${INSTALL_DIR}/lib/${CMAKE_STATIC_LIBRARY_PREFIX}ttvfsd${CMAKE_STATIC_LIBRARY_SUFFIX}")
ELSE()
    SET_TARGET_PROPERTIES(ttvfs PROPERTIES IMPORTED_LOCATION
        "${INSTALL_DIR}/lib/${CMAKE_STATIC_LIBRARY_PREFIX}ttvfs${CMAKE_STATIC_LIBRARY_SUFFIX}")
ENDIF()

ADD_LIBRARY(ttvfs_cfileapi STATIC IMPORTED)
ADD_DEPENDENCIES(ttvfs_cfileapi ttvfs-ex)

IF(WIN32)
    SET_TARGET_PROPERTIES(ttvfs_cfileapi PROPERTIES
        IMPORTED_LOCATION_RELEASE "${INSTALL_DIR}/lib/${CMAKE_STATIC_LIBRARY_PREFIX}ttvfs_cfileapi${CMAKE_STATIC_LIBRARY_SUFFIX}"
        IMPORTED_LOCATION_DEBUG "${INSTALL_DIR}/lib/${CMAKE_STATIC_LIBRARY_PREFIX}ttvfs_cfileapid${CMAKE_STATIC_LIBRARY_SUFFIX}")
ELSE()
    SET_TARGET_PROPERTIES(ttvfs_cfileapi PROPERTIES IMPORTED_LOCATION
        "${INSTALL_DIR}/lib/${CMAKE_STATIC_LIBRARY_PREFIX}ttvfs_cfileapi${CMAKE_STATIC_LIBRARY_SUFFIX}")
ENDIF()

ADD_LIBRARY(ttvfs_zip STATIC IMPORTED)
ADD_DEPENDENCIES(ttvfs_zip ttvfs-ex)

IF(WIN32)
    SET_TARGET_PROPERTIES(ttvfs_zip PROPERTIES
        IMPORTED_LOCATION_RELEASE "${INSTALL_DIR}/lib/${CMAKE_STATIC_LIBRARY_PREFIX}ttvfs_zip${CMAKE_STATIC_LIBRARY_SUFFIX}"
        IMPORTED_LOCATION_DEBUG "${INSTALL_DIR}/lib/${CMAKE_STATIC_LIBRARY_PREFIX}ttvfs_zipd${CMAKE_STATIC_LIBRARY_SUFFIX}")
ELSE()
    SET_TARGET_PROPERTIES(ttvfs_zip PROPERTIES IMPORTED_LOCATION
        "${INSTALL_DIR}/lib/${CMAKE_STATIC_LIBRARY_PREFIX}ttvfs_zip${CMAKE_STATIC_LIBRARY_SUFFIX}")
ENDIF()

SET(TTVFS_GEN_PATH "${INSTALL_DIR}/bin/ttvfs_gen")

ExternalProject_Add(
    sqrat

    GIT_REPOSITORY https://github.com/comphack/sqrat.git
    GIT_TAG comp_hack

    PREFIX ${CMAKE_CURRENT_BINARY_DIR}/sqrat
    CMAKE_ARGS -DCMAKE_INSTALL_PREFIX:PATH=<INSTALL_DIR> "-DCMAKE_CXX_FLAGS=-std=c++11 ${SPECIAL_COMPILER_FLAGS}" -DUSE_STATIC_RUNTIME=${USE_STATIC_RUNTIME} -DCMAKE_DEBUG_POSTFIX=d

    # Dump output to a log instead of the screen.
    LOG_DOWNLOAD ON
    LOG_CONFIGURE ON
    LOG_BUILD ON
    LOG_INSTALL ON
)

ExternalProject_Get_Property(sqrat INSTALL_DIR)

SET_TARGET_PROPERTIES(sqrat PROPERTIES FOLDER "Dependencies")

SET(SQRAT_INCLUDE_DIRS "${INSTALL_DIR}/include")
SET(SQRAT_DEFINES "-DSCRAT_USE_CXX11_OPTIMIZATIONS=1")

ExternalProject_Add(
    civet

    GIT_REPOSITORY https://github.com/comphack/civetweb.git
    GIT_TAG comp_hack

    DEPENDS openssl

    PREFIX ${CMAKE_CURRENT_BINARY_DIR}/civetweb
    CMAKE_ARGS -DCMAKE_INSTALL_PREFIX:PATH=<INSTALL_DIR> "-DOPENSSL_ROOT_DIR=${OPENSSL_ROOT_DIR}" -DBUILD_TESTING=OFF -DCIVETWEB_LIBRARIES_ONLY=ON -DCIVETWEB_ENABLE_SLL=ON -DCIVETWEB_ENABLE_SSL_DYNAMIC_LOADING=OFF -DCIVETWEB_ALLOW_WARNINGS=ON -DCIVETWEB_ENABLE_CXX=ON "-DCMAKE_CXX_FLAGS=-std=c++11 ${SPECIAL_COMPILER_FLAGS}" -DUSE_STATIC_RUNTIME=${USE_STATIC_RUNTIME} -DCMAKE_DEBUG_POSTFIX=d

    # Dump output to a log instead of the screen.
    LOG_DOWNLOAD ON
    LOG_CONFIGURE ON
    LOG_BUILD ON
    LOG_INSTALL ON

    BUILD_BYPRODUCTS <INSTALL_DIR>/lib/${CMAKE_STATIC_LIBRARY_PREFIX}civetweb${CMAKE_STATIC_LIBRARY_SUFFIX}
    BUILD_BYPRODUCTS <INSTALL_DIR>/lib/${CMAKE_STATIC_LIBRARY_PREFIX}cxx-library${CMAKE_STATIC_LIBRARY_SUFFIX}

    BUILD_BYPRODUCTS <INSTALL_DIR>/lib/${CMAKE_STATIC_LIBRARY_PREFIX}civetwebd${CMAKE_STATIC_LIBRARY_SUFFIX}
    BUILD_BYPRODUCTS <INSTALL_DIR>/lib/${CMAKE_STATIC_LIBRARY_PREFIX}cxx-libraryd${CMAKE_STATIC_LIBRARY_SUFFIX}
)

ExternalProject_Get_Property(civet INSTALL_DIR)

SET_TARGET_PROPERTIES(civet PROPERTIES FOLDER "Dependencies")

SET(CIVETWEB_INCLUDE_DIRS "${INSTALL_DIR}/include")

ADD_LIBRARY(civetweb STATIC IMPORTED)
ADD_DEPENDENCIES(civetweb civet)

IF(WIN32)
    SET_TARGET_PROPERTIES(civetweb PROPERTIES
        IMPORTED_LOCATION_RELEASE "${INSTALL_DIR}/lib/${CMAKE_STATIC_LIBRARY_PREFIX}civetweb${CMAKE_STATIC_LIBRARY_SUFFIX}"
        IMPORTED_LOCATION_DEBUG "${INSTALL_DIR}/lib/${CMAKE_STATIC_LIBRARY_PREFIX}civetwebd${CMAKE_STATIC_LIBRARY_SUFFIX}")
ELSE()
    SET_TARGET_PROPERTIES(civetweb PROPERTIES IMPORTED_LOCATION
        "${INSTALL_DIR}/lib/${CMAKE_STATIC_LIBRARY_PREFIX}civetweb${CMAKE_STATIC_LIBRARY_SUFFIX}")
ENDIF()

ADD_LIBRARY(civetweb-cxx STATIC IMPORTED)
ADD_DEPENDENCIES(civetweb-cxx civetweb)

IF(WIN32)
    SET_TARGET_PROPERTIES(civetweb-cxx PROPERTIES
        IMPORTED_LOCATION_RELEASE "${INSTALL_DIR}/lib/${CMAKE_STATIC_LIBRARY_PREFIX}cxx-library${CMAKE_STATIC_LIBRARY_SUFFIX}"
        IMPORTED_LOCATION_DEBUG "${INSTALL_DIR}/lib/${CMAKE_STATIC_LIBRARY_PREFIX}cxx-libraryd${CMAKE_STATIC_LIBRARY_SUFFIX}")
ELSE()
    SET_TARGET_PROPERTIES(civetweb-cxx PROPERTIES IMPORTED_LOCATION
        "${INSTALL_DIR}/lib/${CMAKE_STATIC_LIBRARY_PREFIX}cxx-library${CMAKE_STATIC_LIBRARY_SUFFIX}")
ENDIF()

ExternalProject_Add(
    squirrel3

    GIT_REPOSITORY https://github.com/comphack/squirrel3.git
    GIT_TAG comp_hack

    PREFIX ${CMAKE_CURRENT_BINARY_DIR}/squirrel3
    CMAKE_ARGS -DCMAKE_INSTALL_PREFIX:PATH=<INSTALL_DIR> "-DCMAKE_CXX_FLAGS=-std=c++11 ${SPECIAL_COMPILER_FLAGS}" -DUSE_STATIC_RUNTIME=${USE_STATIC_RUNTIME} -DCMAKE_DEBUG_POSTFIX=d

    # Dump output to a log instead of the screen.
    LOG_DOWNLOAD ON
    LOG_CONFIGURE ON
    LOG_BUILD ON
    LOG_INSTALL ON

    BUILD_BYPRODUCTS <INSTALL_DIR>/lib/${CMAKE_STATIC_LIBRARY_PREFIX}squirrel${CMAKE_STATIC_LIBRARY_SUFFIX}
    BUILD_BYPRODUCTS <INSTALL_DIR>/lib/${CMAKE_STATIC_LIBRARY_PREFIX}sqstdlib${CMAKE_STATIC_LIBRARY_SUFFIX}

    BUILD_BYPRODUCTS <INSTALL_DIR>/lib/${CMAKE_STATIC_LIBRARY_PREFIX}squirreld${CMAKE_STATIC_LIBRARY_SUFFIX}
    BUILD_BYPRODUCTS <INSTALL_DIR>/lib/${CMAKE_STATIC_LIBRARY_PREFIX}sqstdlibd${CMAKE_STATIC_LIBRARY_SUFFIX}
)

ExternalProject_Get_Property(squirrel3 INSTALL_DIR)

SET_TARGET_PROPERTIES(squirrel3 PROPERTIES FOLDER "Dependencies")

SET(SQUIRREL_INCLUDE_DIRS "${INSTALL_DIR}/include")

ADD_LIBRARY(squirrel STATIC IMPORTED)
ADD_DEPENDENCIES(squirrel squirrel3)

IF(WIN32)
    SET_TARGET_PROPERTIES(squirrel PROPERTIES
        IMPORTED_LOCATION_RELEASE "${INSTALL_DIR}/lib/${CMAKE_STATIC_LIBRARY_PREFIX}squirrel${CMAKE_STATIC_LIBRARY_SUFFIX}"
        IMPORTED_LOCATION_DEBUG "${INSTALL_DIR}/lib/${CMAKE_STATIC_LIBRARY_PREFIX}squirreld${CMAKE_STATIC_LIBRARY_SUFFIX}")
ELSE()
    SET_TARGET_PROPERTIES(squirrel PROPERTIES IMPORTED_LOCATION
        "${INSTALL_DIR}/lib/${CMAKE_STATIC_LIBRARY_PREFIX}squirrel${CMAKE_STATIC_LIBRARY_SUFFIX}")
ENDIF()

ADD_LIBRARY(sqstdlib STATIC IMPORTED)
ADD_DEPENDENCIES(sqstdlib squirrel3)

IF(WIN32)
    SET_TARGET_PROPERTIES(sqstdlib PROPERTIES
        IMPORTED_LOCATION_RELEASE "${INSTALL_DIR}/lib/${CMAKE_STATIC_LIBRARY_PREFIX}sqstdlib${CMAKE_STATIC_LIBRARY_SUFFIX}"
        IMPORTED_LOCATION_DEBUG "${INSTALL_DIR}/lib/${CMAKE_STATIC_LIBRARY_PREFIX}sqstdlibd${CMAKE_STATIC_LIBRARY_SUFFIX}")
ELSE()
    SET_TARGET_PROPERTIES(sqstdlib PROPERTIES IMPORTED_LOCATION
        "${INSTALL_DIR}/lib/${CMAKE_STATIC_LIBRARY_PREFIX}sqstdlib${CMAKE_STATIC_LIBRARY_SUFFIX}")
ENDIF()

ExternalProject_Add(
    asio

    GIT_REPOSITORY https://github.com/comphack/asio.git
    GIT_TAG comp_hack

    PREFIX ${CMAKE_CURRENT_BINARY_DIR}/asio
    CMAKE_ARGS -DCMAKE_INSTALL_PREFIX:PATH=<INSTALL_DIR> "-DCMAKE_CXX_FLAGS=-std=c++11 ${SPECIAL_COMPILER_FLAGS}" -DUSE_STATIC_RUNTIME=${USE_STATIC_RUNTIME} -DCMAKE_DEBUG_POSTFIX=d

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

SET_TARGET_PROPERTIES(asio PROPERTIES FOLDER "Dependencies")

SET(ASIO_INCLUDE_DIRS "${INSTALL_DIR}/src/asio/asio/include")

ExternalProject_Add(
    tinyxml2-ex

    GIT_REPOSITORY https://github.com/comphack/tinyxml2.git
    GIT_TAG comp_hack

    PREFIX ${CMAKE_CURRENT_BINARY_DIR}/tinyxml2
    CMAKE_ARGS -DCMAKE_INSTALL_PREFIX:PATH=<INSTALL_DIR> -DBUILD_SHARED_LIBS=OFF "-DCMAKE_CXX_FLAGS=-std=c++11 ${SPECIAL_COMPILER_FLAGS}" -DUSE_STATIC_RUNTIME=${USE_STATIC_RUNTIME} -DCMAKE_DEBUG_POSTFIX=d

    # Dump output to a log instead of the screen.
    LOG_DOWNLOAD ON
    LOG_CONFIGURE ON
    LOG_BUILD ON
    LOG_INSTALL ON

    BUILD_BYPRODUCTS <INSTALL_DIR>/lib/${CMAKE_STATIC_LIBRARY_PREFIX}tinyxml2${CMAKE_STATIC_LIBRARY_SUFFIX}
    BUILD_BYPRODUCTS <INSTALL_DIR>/lib/${CMAKE_STATIC_LIBRARY_PREFIX}tinyxml2d${CMAKE_STATIC_LIBRARY_SUFFIX}
)

ExternalProject_Get_Property(tinyxml2-ex INSTALL_DIR)

SET_TARGET_PROPERTIES(tinyxml2-ex PROPERTIES FOLDER "Dependencies")

SET(TINYXML2_INCLUDE_DIRS "${INSTALL_DIR}/include")

ADD_LIBRARY(tinyxml2 STATIC IMPORTED)
ADD_DEPENDENCIES(tinyxml2 tinyxml2-ex)

IF(WIN32)
    SET_TARGET_PROPERTIES(tinyxml2 PROPERTIES
        IMPORTED_LOCATION_RELEASE "${INSTALL_DIR}/lib/${CMAKE_STATIC_LIBRARY_PREFIX}tinyxml2${CMAKE_STATIC_LIBRARY_SUFFIX}"
        IMPORTED_LOCATION_DEBUG "${INSTALL_DIR}/lib/${CMAKE_STATIC_LIBRARY_PREFIX}tinyxml2d${CMAKE_STATIC_LIBRARY_SUFFIX}")
ELSE()
    SET_TARGET_PROPERTIES(tinyxml2 PROPERTIES IMPORTED_LOCATION
        "${INSTALL_DIR}/lib/${CMAKE_STATIC_LIBRARY_PREFIX}tinyxml2${CMAKE_STATIC_LIBRARY_SUFFIX}")
ENDIF()

ExternalProject_Add(
    googletest

    GIT_REPOSITORY https://github.com/comphack/googletest.git
    GIT_TAG comp_hack

    PREFIX ${CMAKE_CURRENT_BINARY_DIR}/googletest
    CMAKE_ARGS -DCMAKE_INSTALL_PREFIX:PATH=<INSTALL_DIR> "-DCMAKE_CXX_FLAGS=-std=c++11 ${SPECIAL_COMPILER_FLAGS}" -DUSE_STATIC_RUNTIME=${USE_STATIC_RUNTIME} -DCMAKE_DEBUG_POSTFIX=d

    # Dump output to a log instead of the screen.
    LOG_DOWNLOAD ON
    LOG_CONFIGURE ON
    LOG_BUILD ON
    LOG_INSTALL ON

    BUILD_BYPRODUCTS <INSTALL_DIR>/lib/${CMAKE_STATIC_LIBRARY_PREFIX}gtest${CMAKE_STATIC_LIBRARY_SUFFIX}
    BUILD_BYPRODUCTS <INSTALL_DIR>/lib/${CMAKE_STATIC_LIBRARY_PREFIX}gmock${CMAKE_STATIC_LIBRARY_SUFFIX}
    BUILD_BYPRODUCTS <INSTALL_DIR>/lib/${CMAKE_STATIC_LIBRARY_PREFIX}gmock_main${CMAKE_STATIC_LIBRARY_SUFFIX}

    BUILD_BYPRODUCTS <INSTALL_DIR>/lib/${CMAKE_STATIC_LIBRARY_PREFIX}gtestd${CMAKE_STATIC_LIBRARY_SUFFIX}
    BUILD_BYPRODUCTS <INSTALL_DIR>/lib/${CMAKE_STATIC_LIBRARY_PREFIX}gmockd${CMAKE_STATIC_LIBRARY_SUFFIX}
    BUILD_BYPRODUCTS <INSTALL_DIR>/lib/${CMAKE_STATIC_LIBRARY_PREFIX}gmock_maind${CMAKE_STATIC_LIBRARY_SUFFIX}
)

ExternalProject_Get_Property(googletest INSTALL_DIR)

SET_TARGET_PROPERTIES(googletest PROPERTIES FOLDER "Dependencies")

SET(GTEST_INCLUDE_DIRS "${INSTALL_DIR}/include")

ADD_LIBRARY(gtest STATIC IMPORTED)
ADD_DEPENDENCIES(gtest googletest)

IF(WIN32)
    SET_TARGET_PROPERTIES(gtest PROPERTIES
        IMPORTED_LOCATION_RELEASE "${INSTALL_DIR}/lib/${CMAKE_STATIC_LIBRARY_PREFIX}gtest${CMAKE_STATIC_LIBRARY_SUFFIX}"
        IMPORTED_LOCATION_DEBUG "${INSTALL_DIR}/lib/${CMAKE_STATIC_LIBRARY_PREFIX}gtestd${CMAKE_STATIC_LIBRARY_SUFFIX}")
ELSE()
    SET_TARGET_PROPERTIES(gtest PROPERTIES IMPORTED_LOCATION
        "${INSTALL_DIR}/lib/${CMAKE_STATIC_LIBRARY_PREFIX}gtest${CMAKE_STATIC_LIBRARY_SUFFIX}")
ENDIF()

ADD_LIBRARY(gmock STATIC IMPORTED)
ADD_DEPENDENCIES(gmock googletest)

IF(WIN32)
    SET_TARGET_PROPERTIES(gmock PROPERTIES
        IMPORTED_LOCATION_RELEASE "${INSTALL_DIR}/lib/${CMAKE_STATIC_LIBRARY_PREFIX}gmock${CMAKE_STATIC_LIBRARY_SUFFIX}"
        IMPORTED_LOCATION_DEBUG "${INSTALL_DIR}/lib/${CMAKE_STATIC_LIBRARY_PREFIX}gmockd${CMAKE_STATIC_LIBRARY_SUFFIX}")
ELSE()
    SET_TARGET_PROPERTIES(gmock PROPERTIES IMPORTED_LOCATION
        "${INSTALL_DIR}/lib/${CMAKE_STATIC_LIBRARY_PREFIX}gmock${CMAKE_STATIC_LIBRARY_SUFFIX}")
ENDIF()

ADD_LIBRARY(gmock_main STATIC IMPORTED)
ADD_DEPENDENCIES(gmock_main googletest)

IF(WIN32)
    SET_TARGET_PROPERTIES(gmock_main PROPERTIES
        IMPORTED_LOCATION_RELEASE "${INSTALL_DIR}/lib/${CMAKE_STATIC_LIBRARY_PREFIX}gmock_main${CMAKE_STATIC_LIBRARY_SUFFIX}"
        IMPORTED_LOCATION_DEBUG "${INSTALL_DIR}/lib/${CMAKE_STATIC_LIBRARY_PREFIX}gmock_maind${CMAKE_STATIC_LIBRARY_SUFFIX}")
ELSE()
    SET_TARGET_PROPERTIES(gmock_main PROPERTIES IMPORTED_LOCATION
        "${INSTALL_DIR}/lib/${CMAKE_STATIC_LIBRARY_PREFIX}gmock_main${CMAKE_STATIC_LIBRARY_SUFFIX}")
ENDIF()

SET(GMOCK_DIR "${INSTALL_DIR}")
