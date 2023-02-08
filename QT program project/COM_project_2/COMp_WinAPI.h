#ifndef COMP_WINAPI_H
#define COMP_WINAPI_H

#include <windows.h>
#include <string>
#include <QMessageBox>
#include "ui_mainwindow.h"
#include <QVector>
//
#define		path_COMp_output	"C:\\Users\\hard_\\Desktop\\Program\\QT\\University\\COM_project_2\\Temp\\Kasandra.txt"
#define		Path_COMp_res		"C:\\Users\\hard_\\Desktop\\Program\\QT\\University\\COM_project_2\\Temp\\Kasandra_COMp_num_"
#define		Path_COMp_LZ		"C:\\Users\\hard_\\Desktop\\Program\\QT\\University\\COM_project_2\\Temp\\Kasandra_COMp_"
#define		CountPins			16

#define     ComPortAmount		50
#define     ComSelectedIndex	120
#define     ComSelectedIndex_max	ComSelectedIndex + ComPortAmount

#define     TextBufferSize		100
#define     String_max			10000000

#define     COM_read_size		1//10

#define     expected_clk        100
#define     time_scale          1*100/expected_clk//*1000 // 1/clk

#define     LZ_SIZE_NextWnd     1
#define     LZ_SIZE_Wnd         127

extern volatile HANDLE connectedPort;
extern volatile bool isConnected;
extern int targetBaudRate;
extern int selectedPort;

extern volatile int CharsRead;
extern volatile std::string Buffer;
extern volatile std::string Buffer_Thread;
extern volatile std::string Buffer_wr;
//extern volatile Ui::MainWindow* m_parentUI;

void SaveData(char* buffer, int lenth, LPCSTR path);
void LoadData(char* buffer, int lenth, LPCSTR path);
int SerialBegin(int BaudRate, int Comport);
//void ConnectedRequest(void);
void ConnectedRequest(Ui::MainWindow* ui);
void ConnectedRequest(int BaudRate, int Comport);
int SerialWrite(char* buffer, int lenth);
void pre_RLE_adressed_decode(Ui::MainWindow* ui, LPCSTR path_from);//, LPCSTR path_to);
void create_grapf(Ui::MainWindow* ui, int port);//, LPCSTR path_from);
QCustomPlot* ret_QWidget_plot(Ui::MainWindow* ui, int port);
QLabel * ret_QLabel(Ui::MainWindow* ui, int port);
void LZ77_decode(Ui::MainWindow* ui,LPCSTR path_from);

#endif // COMP_WINAPI_H
