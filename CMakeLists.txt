# require 3.15 for GNUInstallDirs
#
# Note: Upstream quazip requires version 3.15+, because of some features related
# to the installation paths. See https://github.com/stachenov/quazip/issues/104
# for details. In LibrePCB we don't install directly from the vendored repository,
# so CMake 3.5+ should work fine.
cmake_minimum_required(VERSION 3.5...3.18)

project(QuaZip VERSION 1.1)

set(CMAKE_CXX_STANDARD 14)

set(QUAZIP_LIB_VERSION ${QuaZip_VERSION})
set(QUAZIP_LIB_SOVERSION 1.0.0)

option(BUILD_SHARED_LIBS "" ON)
option(QUAZIP_INSTALL "" ON)
set(QUAZIP_QT_MAJOR_VERSION 5 CACHE STRING "Qt version to use (4 or 5), defaults to 5")

if(NOT CMAKE_BUILD_TYPE)
	set(CMAKE_BUILD_TYPE RELEASE)
endif()

enable_testing()
set(CMAKE_AUTOMOC ON)
set(CMAKE_INCLUDE_CURRENT_DIR ON)
set(CMAKE_DEBUG_POSTFIX d)

set(QUAZIP_SOURCE_DIR ${CMAKE_CURRENT_SOURCE_DIR})
set(QUAZIP_BINARY_DIR ${CMAKE_CURRENT_BINARY_DIR})
set(QUAZIP_LIB_FILE_NAME quazip${QuaZip_VERSION_MAJOR}-qt${QUAZIP_QT_MAJOR_VERSION})
set(QUAZIP_LIB_TARGET_NAME QuaZip)
set(QUAZIP_DIR_NAME QuaZip-Qt${QUAZIP_QT_MAJOR_VERSION}-${QUAZIP_LIB_VERSION})
set(QUAZIP_PACKAGE_NAME QuaZip-Qt${QUAZIP_QT_MAJOR_VERSION})
set(QUAZIP_ENABLE_TESTS OFF)
if(QUAZIP_QT_MAJOR_VERSION EQUAL 6)
	find_package(Qt6 REQUIRED COMPONENTS Core Core5Compat
                         OPTIONAL_COMPONENTS Network Test)
	set(QUAZIP_LIB_LIBRARIES Qt6::Core Qt6::Core5Compat)
	set(QUAZIP_TEST_QT_LIBRARIES Qt6::Core Qt6::Core5Compat Qt6::Network Qt6::Test)
	set(QUAZIP_PKGCONFIG_REQUIRES Qt6Core)
	if (Qt6Network_FOUND AND Qt6Test_FOUND)
                set(QUAZIP_ENABLE_TESTS ON)
        endif()
elseif(QUAZIP_QT_MAJOR_VERSION EQUAL 5)
	find_package(Qt5 REQUIRED COMPONENTS Core
                         OPTIONAL_COMPONENTS Network Test)
	set(QUAZIP_LIB_LIBRARIES Qt5::Core)
	set(QUAZIP_TEST_QT_LIBRARIES Qt5::Core Qt5::Network Qt5::Test)
	set(QUAZIP_PKGCONFIG_REQUIRES Qt5Core)
        if (Qt5Network_FOUND AND Qt5Test_FOUND)
                set(QUAZIP_ENABLE_TESTS ON)
        endif()
elseif(QUAZIP_QT_MAJOR_VERSION EQUAL 4)
	find_package(Qt4 4.5.0 REQUIRED COMPONENTS QtCore
                           OPTIONAL_COMPONENTS QtNetwork QtTest)
	set(QUAZIP_LIB_LIBRARIES Qt4::QtCore)
	set(QUAZIP_TEST_QT_LIBRARIES Qt4::QtCore Qt4::QtNetwork Qt4::QtTest)
	set(QUAZIP_PKGCONFIG_REQUIRES QtCore)
    if (QT_QTNETWORK_FOUND AND QT_QTTEST_FOUND)
            set(QUAZIP_ENABLE_TESTS ON)
    endif()
else()
	message(FATAL_ERROR "Qt version ${QUAZIP_QT_MAJOR_VERSION} is not supported")
endif()

find_package(Qt${QUAZIP_QT_MAJOR_VERSION} OPTIONAL_COMPONENTS Zlib)
if (Qt${QUAZIP_QT_MAJOR_VERSION}Zlib_FOUND)
	set(QUAZIP_LIB_LIBRARIES ${QUAZIP_LIB_LIBRARIES} Qt${QUAZIP_QT_MAJOR_VERSION}::Zlib)
else()
	find_package(ZLIB REQUIRED)
	set(QUAZIP_LIB_LIBRARIES ${QUAZIP_LIB_LIBRARIES} ZLIB::ZLIB)
endif()

add_subdirectory(quazip)

if(QUAZIP_ENABLE_TESTS)
        add_subdirectory(qztest EXCLUDE_FROM_ALL)
endif()

