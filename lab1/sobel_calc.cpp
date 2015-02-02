#include "opencv2/imgproc/imgproc.hpp"
#include "sobel_alg.h"
using namespace cv;

/*******************************************
 * Model: grayScale
 * Input: Mat img
 * Output: None directly. Modifies a ref parameter img_gray_out
 * Desc: This module converts the image to grayscale
 ********************************************/
void grayScale(Mat& img, Mat& img_gray_out, int mt_thread /*default -1*/)
{
  // Convert to grayscale
    for (int i=0; i<img.rows; i++) {
      for (int j=0; j<img.cols; j++) {
  //       img_gray_out.data[IMG_WIDTH*i + j] = .114*img.data[STEP0*i + STEP1*j] + 
  // .587*img.data[STEP0*i + STEP1*j + 1]+
  // .299*img.data[STEP0*i + STEP1*j + 2];
        img_gray_out.data[IMG_WIDTH*i + j] = 1;
      }
  }
  // int start_i = mt_thread > 0 ? img.rows*mt_thread/NUM_THREADS : 0;
  // int end_i = mt_thread >= 0 ? (mt_thread+1)*img.rows/NUM_THREADS : img.rows;
  // for (int i=start_i; i<end_i; i++) {
  //   for (int j=0; j<img.cols; j++) {
  //     img_gray_out.data[IMG_WIDTH*i + j] = .114*img.data[STEP0*i + STEP1*j] + 
  // .587*img.data[STEP0*i + STEP1*j + 1]+
  // .299*img.data[STEP0*i + STEP1*j + 2];
  //   }
  // }
} 

/*******************************************
 * Model: sobelCalc
 * Input: Mat img_in
 * Output: None directly. Modifies a ref parameter img_sobel_out
 * Desc: This module performs a sobel calculation on an image. It first
 *  converts the image to grayscale, calculates the gradient in the x 
 *  direction, calculates the gradient in the y direction and sum it with Gx
 *  to finish the Sobel calculation
 ********************************************/
void sobelCalc(Mat& img_gray, Mat& img_sobel_out, int mt_thread /*default -1*/)
{  
  // Apply Sobel filter to black & white image
  unsigned short sobel;

  int start_i = mt_thread > 0 ? img_gray.rows*mt_thread/NUM_THREADS : 1;
  int end_i = mt_thread >= 0 ? (mt_thread*img_gray.rows+1)/NUM_THREADS : img_gray.rows;
  for (int i=start_i; i<end_i; i++) {
    for (int j=1; j<img_gray.cols; j++) {
      sobel = abs(img_gray.data[IMG_WIDTH*(i-1) + (j-1)]- 
      img_gray.data[IMG_WIDTH*(i+1) + (j-1)] + 
      2*img_gray.data[IMG_WIDTH*(i-1) + (j)] - 
      2*img_gray.data[IMG_WIDTH*(i+1) + (j)] + 
      img_gray.data[IMG_WIDTH*(i-1) + (j+1)] - 
      img_gray.data[IMG_WIDTH*(i+1) + (j+1)]) + abs(img_gray.data[IMG_WIDTH*(i-1) + (j-1)] - 
       img_gray.data[IMG_WIDTH*(i-1) + (j+1)] + 
       2*img_gray.data[IMG_WIDTH*(i) + (j-1)] - 
       2*img_gray.data[IMG_WIDTH*(i) + (j+1)] + 
       img_gray.data[IMG_WIDTH*(i+1) + (j-1)] - 
       img_gray.data[IMG_WIDTH*(i+1) + (j+1)]);

      img_sobel_out.data[IMG_WIDTH*(i) + j] = (sobel > 255) ? 255 : sobel;
    }
  }
}
