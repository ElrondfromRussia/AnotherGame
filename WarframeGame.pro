TEMPLATE = app

QT += qml quick widgets network core

SOURCES += main.cpp \
    mygame.cpp \
    gameroom.cpp \
    player.cpp

RESOURCES += qml.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Default rules for deployment.
include(deployment.pri)

HEADERS += \
    mygame.h \
    gameroom.h \
    player.h
