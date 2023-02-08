#include "mainwindow.h"
#include "ui_mainwindow.h"


MainWindow::MainWindow(QWidget *parent)
    : QMainWindow(parent)
    , ui(new Ui::MainWindow)
{
    ui->setupUi(this);

    connect(&thread_1, &QThread::started, &Object_sread_1, &Object_sread::run);
    //connect(&thread_2, &QThread::started, &Object_sread_2, &Object_sread::run);
    connect(&Object_sread_1, &Object_sread::finished, &thread_1, &QThread::terminate);
    //connect(&Object_sread_2, &Object_sread::finished, &thread_1, &QThread::terminate);

    Object_sread_1.moveToThread(&thread_1);
    //Object_sread_2.moveToThread(&thread_2);

    Object_sread_1.setRunning(true);
    Object_sread_1.setLabel(ui->label);
    Object_sread_1.setParentUI(ui);
    thread_1.start();
}

MainWindow::~MainWindow()
{
    delete ui;
}

void MainWindow::closeEvent(QCloseEvent *event)
{
    event->ignore();
    if (QMessageBox::Yes == QMessageBox::question(this, "Закрыть?",
                          "Уверены?",
                          QMessageBox::Yes|QMessageBox::No))
    {
    Object_sread_1.setRunning(false);
    event->accept();
    }

}


void MainWindow::on_pushButton_clicked()
{
    ConnectedRequest(ui);
}

void MainWindow::on_pushButton_2_clicked()
{
    CloseHandle(connectedPort);
    ui->label->setText("Disconected");
    isConnected = false;
}

void MainWindow::on_pushButton_3_clicked()
{
    Object_sread_1.setRunning(true);
    Object_sread_1.setLabel(ui->label);
    thread_1.start();
}

void MainWindow::on_pushButton_4_clicked()
{
    char temp = 0xAB; //'«'
    SerialWrite(&temp, 1);
}

void MainWindow::on_pushButton_5_clicked()
{
    pre_RLE_adressed_decode(ui, path_COMp_output);
}

void MainWindow::on_pushButton_6_clicked()
{
    for(int i=0; i<CountPins; i++)
    {
        create_grapf(ui, i);
    }
    int cnt_all_data = 0;
    cnt_all_data += ui->label_19->text().toInt();
    cnt_all_data += ui->label_20->text().toInt();
    cnt_all_data += ui->label_21->text().toInt();
    cnt_all_data += ui->label_22->text().toInt();
    cnt_all_data += ui->label_23->text().toInt();
    cnt_all_data += ui->label_24->text().toInt();
    cnt_all_data += ui->label_25->text().toInt();
    cnt_all_data += ui->label_26->text().toInt();
    cnt_all_data += ui->label_27->text().toInt();
    cnt_all_data += ui->label_28->text().toInt();
    cnt_all_data += ui->label_29->text().toInt();
    cnt_all_data += ui->label_30->text().toInt();
    cnt_all_data += ui->label_31->text().toInt();
    cnt_all_data += ui->label_32->text().toInt();
    cnt_all_data += ui->label_33->text().toInt();
    cnt_all_data += ui->label_34->text().toInt();
    ui->label_35->setNum(cnt_all_data);
    int compr_cnt = ui->label_2->text().toInt();
    int compr_param = (cnt_all_data-compr_cnt)*100/cnt_all_data;
    ui->label_36->setNum(compr_param);
}

void MainWindow::on_pushButton_7_clicked()
{
    //LZ77_decode(ui, path_COMp_output);
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

    ui->widget->graph(0)->data()->clear();
    ui->widget_2->graph(0)->data()->clear();
    ui->widget_3->graph(0)->data()->clear();
    ui->widget_4->graph(0)->data()->clear();
    ui->widget_5->graph(0)->data()->clear();
    ui->widget_6->graph(0)->data()->clear();
    ui->widget_7->graph(0)->data()->clear();
    ui->widget_8->graph(0)->data()->clear();
    ui->widget_9->graph(0)->data()->clear();
    ui->widget_10->graph(0)->data()->clear();
    ui->widget_11->graph(0)->data()->clear();
    ui->widget_12->graph(0)->data()->clear();
    ui->widget_13->graph(0)->data()->clear();
    ui->widget_14->graph(0)->data()->clear();
    ui->widget_15->graph(0)->data()->clear();
    ui->widget_16->graph(0)->data()->clear();

    ui->widget->replot();
    ui->widget_2->replot();
    ui->widget_3->replot();
    ui->widget_4->replot();
    ui->widget_5->replot();
    ui->widget_6->replot();
    ui->widget_7->replot();
    ui->widget_8->replot();
    ui->widget_9->replot();
    ui->widget_10->replot();
    ui->widget_11->replot();
    ui->widget_12->replot();
    ui->widget_13->replot();
    ui->widget_14->replot();
    ui->widget_15->replot();
    ui->widget_16->replot();
}
