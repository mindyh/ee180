#ifndef SOBEL_ALG_H
#define SOBEL_ALG_H

#include <stdio.h>
#include <stdlib.h>
#include "opencv2/imgproc/imgproc.hpp"
#include "opencv2/highgui/highgui.hpp"
#include <iostream>
#include <fstream>
#include <unistd.h>
#include <string.h>
#include <locale.h>
#include <err.h>

#define IMG_WIDTH 640
#define IMG_HEIGHT 480
#define STEP0 1920
#define STEP1 3
#define PROC_FREQ 866000000
#define PROC_EPC 1.4
#define NCORES 1
#define NUM_THREADS 2

using namespace cv;
using namespace std;

//This mutex will be used to allow threads to contest for thread 0 status
extern pthread_barrier_t endSobel;
extern pthread_barrier_t syncSobel1;
extern pthread_barrier_t syncSobel2;
extern pthread_mutex_t thread0;
extern pthread_t thread0_id;

void sobelCalc(Mat& img_gray, Mat& img_sobel_out, int mt_thread=-1);
void grayScale(Mat& img, Mat& img_gray_out, int mt_thread=-1);

void runSobelST();
void *runSobelMT(void *ptr);
#endif
