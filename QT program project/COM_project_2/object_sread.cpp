#include "object_sread.h"
#include "COMp_WinAPI.h"

volatile bool isThreading = true;
volatile int itr = 1;

Object_sread::Object_sread(QObject *parent) : QObject(parent)
{

}

bool Object_sread::running() const
{
    //
    return m_running;
}

QLabel *Object_sread::label() const
{
    return m_label;
}

Ui::MainWindow *Object_sread::parentUI() const
{
    return m_parentUI;
}

void Object_sread::run()
{
    DWORD BytesIterated;

    CloseHandle(
        CreateFileA(
            path_COMp_output,
            GENERIC_WRITE,
            0,
            NULL,
            CREATE_ALWAYS,
            FILE_ATTRIBUTE_NORMAL,
            NULL)
    );
    while (m_running)
    {

        if (!isConnected)
        {
            continue;
        }

        if (!SetCommMask(connectedPort, EV_RXCHAR))
        {
            ConnectedRequest(m_parentUI);
            continue;
        }

        std::string Buffer_Thread = {};
        Buffer_Thread.resize(COM_read_size);

        if (ReadFile(connectedPort, &Buffer_Thread[0], COM_read_size, &BytesIterated, NULL))
        {
            if (BytesIterated)
            {
                SaveData(&Buffer_Thread[0], COM_read_size, path_COMp_output);
                //Buffer_Thread.resize(COM_read_size);
                //LoadData(&Buffer_Thread[0], COM_read_size, path_COMp_output);
            }
        }
    }

    emit finished();
}

void Object_sread::setRunning(bool running)
{
    if (m_running == running)
        return;

    m_running = running;
    emit runningChanged(m_running);
}

void Object_sread::setLabel(QLabel *label)
{
    if (m_label == label)
        return;

    m_label = label;
    emit labelChanged(m_label);
}

void Object_sread::setParentUI(Ui::MainWindow *parentUI)
{
    if (m_parentUI == parentUI)
        return;

    m_parentUI = parentUI;
    emit parentUIChanged(m_parentUI);
}
