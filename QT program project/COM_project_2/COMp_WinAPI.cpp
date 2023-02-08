#include "COMp_WinAPI.h"

//volatile Ui::MainWindow* m_parentUI;

volatile HANDLE connectedPort;
volatile bool isConnected = false;
int targetBaudRate = 256000*2;
int selectedPort = 3;


void LoadData(char* buffer, int lenth, LPCSTR path)
{
    HANDLE FileToLoad = CreateFileA(
        path,
        GENERIC_READ,
        0,
        NULL,
        OPEN_EXISTING,
        FILE_ATTRIBUTE_NORMAL,
        NULL);

    //std::string data;
    //data.resize(String_max);
    DWORD bytesIterated;
    ReadFile(FileToLoad, buffer, lenth, &bytesIterated, NULL);
    //data.resize(bytesIterated);
    //SetWindowTextA(hEditDataRead, &data[0]);

    CloseHandle(FileToLoad);
}

void SaveData(char* buffer, int lenth, LPCSTR path)
{
    HANDLE FileToSave = CreateFileA(
        path,
        GENERIC_WRITE,
        0,
        NULL,
        OPEN_ALWAYS,
        FILE_ATTRIBUTE_NORMAL,
        NULL);

    //int saveLenght = GetWindowTextLengthA(hEditDataRead);
    //std::string data;
    //data.resize(saveLenght + 1)
    SetFilePointer(FileToSave, 0, NULL, FILE_END);
    DWORD bytesIterated;
    WriteFile(FileToSave, buffer, lenth, &bytesIterated, NULL);

    CloseHandle(FileToSave);
}


int SerialBegin(int BaudRate, int Comport)
{
    CloseHandle(connectedPort);

    connectedPort = CreateFileA(
        ("\\\\.\\COM" + std::to_string(Comport)).c_str(),
        GENERIC_READ | GENERIC_WRITE,
        0,
        NULL,
        OPEN_EXISTING,
        FILE_ATTRIBUTE_NORMAL,
        NULL);

    if (connectedPort == INVALID_HANDLE_VALUE)
    {
        return -4;
    }

    DCB SerialParams;
    SerialParams.DCBlength = sizeof(SerialParams);
    if (!GetCommState(connectedPort, &SerialParams))
    {
        return -3;
    }

    SerialParams.BaudRate = BaudRate;
    SerialParams.ByteSize = 8;
    SerialParams.StopBits = ONESTOPBIT;
    SerialParams.Parity = NOPARITY;

    if (!SetCommState(connectedPort, &SerialParams))
    {
        return -2;
    }

    COMMTIMEOUTS SerialTimeouts;
    SerialTimeouts.ReadIntervalTimeout = 1;
    SerialTimeouts.ReadTotalTimeoutConstant = 1;
    SerialTimeouts.ReadTotalTimeoutMultiplier = 1;
    SerialTimeouts.WriteTotalTimeoutConstant = 1;
    SerialTimeouts.WriteTotalTimeoutMultiplier = 1;

    if (!SetCommTimeouts(connectedPort, &SerialTimeouts))
    {
        return -1;
    }

    return 0;

}

void ConnectedRequest(Ui::MainWindow* ui)
{
    if (isConnected)
    {
        CloseHandle(connectedPort);
        //SetWindowStatus("Disconected");
        ui->label->setText("Disconected");

        isConnected = false;
        return;
    }

    switch (SerialBegin(targetBaudRate, selectedPort))
    {

    case -4:
        //SetWindowStatus("Device not connected!");
        ui->label->setText("Device not connected!");
        break;

    case -3:
        //SetWindowStatus("GetState error!");
        ui->label->setText("GetState error!");
        break;

    case -2:
        //SetWindowStatus("SetState error!");
        ui->label->setText("SetState error!");
        break;

    case -1:
        //SetWindowStatus("SetTimeouts error!");
        ui->label->setText("SetTimeouts error!");
        break;

    case 0:
        //SetWindowStatus( "Connected to: COM" + std::to_string(selectedPort));
        ui->label->setText("Connected to: COM" + QString::number(selectedPort));
        isConnected = true;
        return;
        break;

    default:
        //SetWindowStatus("Undefine error!!!");
        ui->label->setText("Undefine error!!!");
        break;
    }

    CloseHandle(connectedPort);

}

void ConnectedRequest(int BaudRate, int Comport)
{
    if (isConnected)
    {
        CloseHandle(connectedPort);
        //SetWindowStatus("Disconected");
        isConnected = false;
        return;
    }

    switch (SerialBegin(BaudRate, Comport))
    {

    case -4:
        //SetWindowStatus("Device not connected!");
        break;

    case -3:
        //SetWindowStatus("GetState error!");
        break;

    case -2:
        //SetWindowStatus("SetState error!");
        break;

    case -1:
        //SetWindowStatus("SetTimeouts error!");
        break;

    case 0:
        //SetWindowStatus("Connected to: COM" + std::to_string(selectedPort));
        isConnected = true;
        return;
        break;

    default:
        //SetWindowStatus("Undefine error!!!");
        break;
    }

    CloseHandle(connectedPort);

}


int SerialWrite(char* buffer, int lenth)
{
    if (!isConnected)
    {
        return EXIT_FAILURE;
    }

    DWORD BytesIterated;
    WriteFile(connectedPort, buffer, lenth, &BytesIterated, NULL);
    return EXIT_SUCCESS;
}
void pre_RLE_adressed_decode(Ui::MainWindow* ui,LPCSTR path_from)//, LPCSTR path_to)
{
    int count = 0;
    HANDLE FileToLoad = CreateFileA(
        path_from,
        GENERIC_READ,
        0,
        NULL,
        OPEN_EXISTING,
        FILE_ATTRIBUTE_NORMAL,
        NULL);

    HANDLE FileToWrite;

    for (int i = 0; i < CountPins; i++)
    {
        std::string res_path = Path_COMp_res;
        res_path = res_path + std::to_string(i);
        res_path = res_path + ".txt";
        FileToWrite = CreateFileA(
            &res_path[0],
            GENERIC_WRITE,
            0,
            NULL,
            CREATE_ALWAYS,
            FILE_ATTRIBUTE_NORMAL,
            NULL);
        CloseHandle(FileToWrite);
    }

    std::string data;
    data.resize(1);//1
    DWORD bytesIterated;
    //for(int i=0,k=0;i<4 && k<1024;k++)
    //{
    //    ReadFile(FileToLoad, &data[0], 1, &bytesIterated, NULL);	//skip frst bytes
    //    unsigned char temp = data[0];
    //    if(temp == 0xAB)
    //    {
    //        i++;
    //    }
    //}
    //ReadFile(FileToLoad, &data[0], 1, &bytesIterated, NULL);	//skip frst bytes
    data.resize(2);
    while (ReadFile(FileToLoad, &data[0], 2, &bytesIterated, NULL))
    {
        if (bytesIterated==2)
        {
            unsigned char msb = data[0];
            unsigned char lsb = data[1];
            std::string res_path = Path_COMp_res;
            res_path = res_path + std::to_string((msb&0x7F) >> 3);
            res_path = res_path + ".txt";
            FileToWrite = CreateFileA(
                &res_path[0],
                GENERIC_WRITE,
                0,
                NULL,
                OPEN_ALWAYS,
                FILE_ATTRIBUTE_NORMAL,
                NULL);
            SetFilePointer(FileToWrite, 0, NULL, FILE_END);
            msb = msb & 0x87;
            WriteFile(FileToWrite, &msb, 1, NULL, NULL);
            WriteFile(FileToWrite, &lsb, 1, NULL, NULL);
            //WriteFile(FileToWrite, &data[0], 2, NULL, NULL);
            CloseHandle(FileToWrite);
            count += 2;
        }
        else
        {
            CloseHandle(FileToLoad);
            ui->label_2->setNum(count*8);

            return;
        }
    }
    //data.resize(bytesIterated);
    //SetWindowTextA(hEditDataRead, &data[0]);

    ui->label_2->setNum(count);
    CloseHandle(FileToLoad);
    //CloseHandle(FileToWrite);
}

void create_grapf(Ui::MainWindow* ui, int port)//, LPCSTR path_from)
{
    std::string res_path = Path_COMp_res;
    //res_path = res_path + std::to_string((msb&0x7F) >> 3);
    res_path = res_path + std::to_string(port);
    res_path = res_path + ".txt";

    HANDLE FileToLoad = CreateFileA(
        &res_path[0],//path_from,
        GENERIC_READ,
        0,
        NULL,
        OPEN_EXISTING,
        FILE_ATTRIBUTE_NORMAL,
        NULL);

    std::string data;
    data.resize(2);
    DWORD bytesIterated;

    QVector<double> value;
    QVector<double> coordinate;
    while (ReadFile(FileToLoad, &data[0], 2, &bytesIterated, NULL))
    {
        if (bytesIterated)
        {
            unsigned char msb = data[0];
            unsigned char lsb = data[1];

            if(msb & 0x80)
            {
                for(int i=0; i<8;i++)
                {

                    if(coordinate.empty())
                    {
                        value.push_back( (lsb & (1<<i)) >> i );
                        coordinate.push_back(0);
                    }else
                    {
                        value.push_back( value.last() );
                        double temp = ((lsb & (1<<i)) >> i);
                        value.push_back( temp>0.1 ? (value.last()>0.1?0:1): value.last());//(~((lsb & (1<<i)) >> i)) & 1 );
                        coordinate.push_back(coordinate.last()+1*time_scale-0.01);
                        coordinate.push_back(coordinate.last()+0.01);
                    }
                }

                for(int i=0; i<3;i++)
                {
                    if(coordinate.empty())
                    {
                        value.push_back( (msb & (1<<i)) >> i );
                        coordinate.push_back(0);
                    }else
                    {
                        value.push_back( value.last() );
                        double temp = ((lsb & (1<<i)) >> i);
                        value.push_back( temp>0.1 ? (value.last()>0.1?0:1): value.last());//value.push_back( (msb & (1<<i)) >> i );
                        coordinate.push_back(coordinate.last()+1*time_scale-0.01);
                        coordinate.push_back(coordinate.last()+0.01);

                    }
                }

            }
            else
            {
                int b = ((msb&07)<<8) + lsb;
                for(int i = 0; i<b; i++)
                {
                    if(coordinate.empty())
                    {
                        value.push_back( 0 );
                        coordinate.push_back(0);
                    }else
                    {
                        value.push_back( value.last() );
                        value.push_back( value.last() );
                        coordinate.push_back(coordinate.last()+1*time_scale-0.01);
                        coordinate.push_back(coordinate.last()+0.01);
                    }
                }
            }

        }
        else
        {
            QCustomPlot *widget_t = ret_QWidget_plot( ui, port);
            QLabel *label_t = ret_QLabel(ui, port);
            label_t->setNum((coordinate.size()+1)/2);
            widget_t->xAxis->setRange(-(time_scale)*0.1, time_scale*12.5);
            widget_t->yAxis->setRange(-0.1, 1.25);
            widget_t->addGraph();
            widget_t->graph(0)->addData(coordinate, value);
            widget_t->replot();
            widget_t->setInteraction(QCP::iRangeZoom, true);
            widget_t->setInteraction(QCP::iRangeDrag, true);
            CloseHandle(FileToLoad);
            return;
        }
    }
}

QCustomPlot* ret_QWidget_plot(Ui::MainWindow* ui, int port)
{
    QCustomPlot *widget_t;
    switch (port) {
    case 0:
        widget_t = ui->widget;
        break;

    case 1:
        widget_t = ui->widget_2;
        break;

    case 2:
        widget_t = ui->widget_3;
        break;

    case 3:
        widget_t = ui->widget_4;
        break;

    case 4:
        widget_t = ui->widget_5;
        break;

    case 5:
        widget_t = ui->widget_6;
        break;

    case 6:
        widget_t = ui->widget_7;
        break;

    case 7:
        widget_t = ui->widget_8;
        break;

    case 8:
        widget_t = ui->widget_9;
        break;

    case 9:
        widget_t = ui->widget_10;
        break;

    case 10:
        widget_t = ui->widget_11;
        break;

    case 11:
        widget_t = ui->widget_12;
        break;

    case 12:
        widget_t = ui->widget_13;
        break;

    case 13:
        widget_t = ui->widget_14;
        break;

    case 14:
        widget_t = ui->widget_15;
        break;

    case 15:
        widget_t = ui->widget_16;
        break;

    default:
        widget_t = ui->widget;
        break;
    }

    return widget_t;
}

QLabel * ret_QLabel(Ui::MainWindow* ui, int port)
{

    QLabel * label_t;
    switch (port) {
    case 0:
        label_t = ui->label_19;
        break;

    case 1:
        label_t = ui->label_20;
        break;

    case 2:
        label_t = ui->label_21;
        break;

    case 3:
        label_t = ui->label_22;
        break;

    case 4:
        label_t = ui->label_23;
        break;

    case 5:
        label_t = ui->label_24;
        break;

    case 6:
        label_t = ui->label_25;
        break;

    case 7:
        label_t = ui->label_26;
        break;

    case 8:
        label_t = ui->label_27;
        break;

    case 9:
        label_t = ui->label_28;
        break;

    case 10:
        label_t = ui->label_29;
        break;

    case 11:
        label_t = ui->label_30;
        break;

    case 12:
        label_t = ui->label_31;
        break;

    case 13:
        label_t = ui->label_32;
        break;

    case 14:
        label_t = ui->label_33;
        break;

    case 15:
        label_t = ui->label_34;
        break;

    default:
        label_t = ui->label_34;
        break;
    }

    return label_t;
}

void RLE_decode(Ui::MainWindow* ui,LPCSTR path_from)
{
    {
        int count = 0;
        HANDLE FileToLoad = CreateFileA(
            path_from,
            GENERIC_READ,
            0,
            NULL,
            OPEN_EXISTING,
            FILE_ATTRIBUTE_NORMAL,
            NULL);

        HANDLE FileToWrite;

        for (int i = 0; i < CountPins; i++)
        {
            std::string res_path = Path_COMp_res;
            res_path = res_path + std::to_string(i);
            res_path = res_path + ".txt";
            FileToWrite = CreateFileA(
                &res_path[0],
                GENERIC_WRITE,
                0,
                NULL,
                CREATE_ALWAYS,
                FILE_ATTRIBUTE_NORMAL,
                NULL);
            CloseHandle(FileToWrite);
        }

        std::string data;
        data.resize(2); //1
        DWORD bytesIterated;

        while (ReadFile(FileToLoad, &data[0], 2, &bytesIterated, NULL))
        {
            if (bytesIterated)
            {
                unsigned char msb = data[0];
                unsigned char lsb = data[1];
                std::string res_path = Path_COMp_res;
                res_path = res_path + std::to_string((msb&0x7F) >> 3);
                res_path = res_path + ".txt";
                FileToWrite = CreateFileA(
                    &res_path[0],
                    GENERIC_WRITE,
                    0,
                    NULL,
                    OPEN_ALWAYS,
                    FILE_ATTRIBUTE_NORMAL,
                    NULL);
                SetFilePointer(FileToWrite, 0, NULL, FILE_END);
                msb = msb & 0x87;
                WriteFile(FileToWrite, &msb, 1, NULL, NULL);
                WriteFile(FileToWrite, &lsb, 1, NULL, NULL);
                //WriteFile(FileToWrite, &data[0], 2, NULL, NULL);
                CloseHandle(FileToWrite);
                count += 2;
            }
            else
            {
                CloseHandle(FileToLoad);
                ui->label_2->setNum(count);
                return;
            }
        }
        //data.resize(bytesIterated);
        //SetWindowTextA(hEditDataRead, &data[0]);

        ui->label_2->setNum(count);
        CloseHandle(FileToLoad);
        //CloseHandle(FileToWrite);
    }
}

void LZ77_decode(Ui::MainWindow* ui,LPCSTR path_from){
    //unsigned char LZ_NextWnd[LZ_SIZE_NextWnd];
    //unsigned char LZ_Wnd[LZ_SIZE_Wnd];
    QVector<unsigned char> LZ_Wnd;
    QVector<unsigned char> temp;
    int LZ_count;

    HANDLE FileToLoad = CreateFileA(
        path_from,
        GENERIC_READ,
        0,
        NULL,
        OPEN_EXISTING,
        FILE_ATTRIBUTE_NORMAL,
        NULL);

    HANDLE FileToWrite;

    std::string res_path = Path_COMp_LZ;
    res_path = res_path + "LZ.txt";
    FileToWrite = CreateFileA(
        &res_path[0],
        GENERIC_WRITE,
        0,
        NULL,
        CREATE_ALWAYS,
        FILE_ATTRIBUTE_NORMAL,
        NULL);
    SetFilePointer(FileToWrite, 0, NULL, FILE_END);
    //CloseHandle(FileToWrite);

    std::string data;
    data.resize(2);
    DWORD bytesIterated;
    while (ReadFile(FileToLoad, &data[0], 2, &bytesIterated, NULL))
    {
        if (bytesIterated)
        {
            unsigned char msb = data[0];
            unsigned char lsb = data[1];

            if(msb==0)
            {
                LZ_Wnd.push_back(lsb);
                LZ_count++;
                WriteFile(FileToWrite, &lsb, 1, NULL, NULL);
                if(LZ_count>LZ_SIZE_Wnd)
                {
                    LZ_Wnd.pop_front();
                    LZ_count--;
                }
            }
            else
            {
                if(LZ_count<msb)
                    continue;
                for(int i=0; i<msb; i++)
                {
                    temp.push_back(LZ_Wnd.at(LZ_count-lsb+i));
                }
                while(!(temp.isEmpty()))
                {
                    LZ_Wnd.push_back(temp.first());
                    temp.pop_front();
                    LZ_count++;
                    unsigned char k = LZ_Wnd.last();
                    WriteFile(FileToWrite, &k, 1, NULL, NULL);
                }
                while(LZ_count>LZ_SIZE_Wnd)
                {
                    LZ_count--;
                    LZ_Wnd.pop_front();
                }
            }

        }
        else
        {
            CloseHandle(FileToLoad);
            CloseHandle(FileToWrite);
        }

    }
    CloseHandle(FileToLoad);
    CloseHandle(FileToWrite);

}
