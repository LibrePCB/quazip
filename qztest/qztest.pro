TEMPLATE = app
QT -= gui
QT += network testlib
CONFIG += console
CONFIG -= app_bundle

# Use common project definitions
include(../../../common.pri)

DEPENDPATH += .
INCLUDEPATH += .
win32 {
    # workaround for qdatetime.h macro bug
    DEFINES += NOMINMAX
}

# Disable deprecation warnings
DEFINES+=QT_NO_DEPRECATED_WARNINGS

# Input
HEADERS += qztest.h \
testjlcompress.h \
testquachecksum32.h \
testquagzipfile.h \
testquaziodevice.h \
testquazipdir.h \
testquazipfile.h \
testquazip.h \
    testquazipnewinfo.h \
    testquazipfileinfo.h

SOURCES += qztest.cpp \
testjlcompress.cpp \
testquachecksum32.cpp \
testquagzipfile.cpp \
testquaziodevice.cpp \
testquazip.cpp \
testquazipdir.cpp \
testquazipfile.cpp \
    testquazipnewinfo.cpp \
    testquazipfileinfo.cpp

LIBS += -L$${DESTDIR} -lquazip -lz

INCLUDEPATH += $$PWD/..
DEPENDPATH += $$PWD/../quazip
