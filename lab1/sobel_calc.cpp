#include "opencv2/imgproc/imgproc.hpp"
#include "sobel_alg.h"
using namespace cv;

/*******************************************
 * Model: grayScale
 * Input: Mat img
 * Output: None directly. Modifies a ref parameter img_gray_out
 * Desc: This module converts the image to grayscale
 ********************************************/
void grayScale(Mat& img, Mat& img_gray_out)
{
  // Convert to grayscale
  for (int i=0; i<img.rows; i++) {
    for (int j=0; j<img.cols; j++) {
      img_gray_out.data[IMG_WIDTH*i + j] = .114*img.data[STEP0*i + STEP1*j] + 
  .587*img.data[STEP0*i + STEP1*j + 1]+
  .299*img.data[STEP0*i + STEP1*j + 2];
    }
  }
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
void sobelCalc(Mat& img_gray, Mat& img_sobel_out)
{  
  // Apply Sobel filter to black & white image
  unsigned short sobel;

  for (int i=1; i<img_gray.rows; i++) {
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
