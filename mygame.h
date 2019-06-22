#ifndef MYGAME_H
#define MYGAME_H

#include <QObject>
#include <QVector>
#include <QVariant>
#include <gameroom.h>

class MyGame : public QObject
{
    Q_OBJECT
public:
    explicit MyGame(QObject *parent = 0);

signals:
    void go_new();
    void reset();
    void make_cell(QVariant, QVariant);
    void fill_cell(QVariant, QVariant);
    void set_size(QVariant);

public slots:
    void on_new_Game();
    void on_setConnection();
protected:
    QObject *viewer;
private:
    QVector<GameRoom> gamePairs;
    int size;
    int active_p;
};

#endif // MYGAME_H
