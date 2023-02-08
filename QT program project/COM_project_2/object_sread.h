#ifndef OBJECT_SREAD_H
#define OBJECT_SREAD_H
#include <QThread>
#include <QObject>
#include <QLabel>
//#include "mainwindow.h"
#include "ui_mainwindow.h"

extern volatile int itr;
extern volatile bool isThreading;

class Object_sread : public QObject
{
    Q_OBJECT
    Q_PROPERTY(bool running READ running WRITE setRunning NOTIFY runningChanged)
    Q_PROPERTY(QLabel* label READ label WRITE setLabel NOTIFY labelChanged)
    Q_PROPERTY(Ui::MainWindow* parentUI READ parentUI WRITE setParentUI NOTIFY parentUIChanged)

    bool m_running;
    QLabel* m_label;
    Ui::MainWindow* m_parentUI;

public:
    explicit Object_sread(QObject *parent = nullptr);
    bool running() const;
    QLabel* label() const;
    Ui::MainWindow* parentUI() const;

signals:
    void finished();
    void runningChanged(bool running);
    void labelChanged(QLabel* label);
    void parentUIChanged(Ui::MainWindow* parentUI);

public slots:
    void run();
    void setRunning(bool running);
    void setLabel(QLabel* label);
    void setParentUI(Ui::MainWindow* parentUI);

};

#endif // OBJECT_SREAD_H
