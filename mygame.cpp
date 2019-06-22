#include "mygame.h"
#include "stdio.h"
#include <QDebug>


MyGame::MyGame(QObject *QMLObject):
    viewer(QMLObject)
{
    emit go_new();
    size = 8;
    connect(viewer, SIGNAL(go_new()), this, SLOT(on_new_Game()));
    connect(this, SIGNAL(set_size(QVariant)), viewer, SLOT(on_set_size(QVariant)));
    connect(viewer, SIGNAL(setConnection()), this, SLOT(on_setConnection()));

    on_new_Game();
}

void MyGame::on_new_Game()
{
    emit set_size(size);
}

void MyGame::on_setConnection()
{

}


