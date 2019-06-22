#ifndef GAMEROOM_H
#define GAMEROOM_H

#include <QObject>
#include <player.h>
#include <QPair>

class GameRoom : public QObject
{
    Q_OBJECT
public:
    explicit GameRoom(QObject *parent = 0);

signals:

public slots:
    void addPlayer(Player *pl);
    void deletePlayer(Player *pl);

private:
   QPair<Player*, Player*> playersPair;
   bool full;
};

#endif // GAMEROOM_H
