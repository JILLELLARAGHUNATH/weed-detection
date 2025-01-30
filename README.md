Steps Involved

Image Selection: User selects an image file.

RGB to Grayscale Conversion: Converts the image to grayscale.

Extract RGB Components: Extracts red, green, and blue channels.

Subtraction: Subtracts the grayscale image from the green channel.

Denoising: Applies a median filter to remove noise.

Threshold Segmentation: Converts the image to binary using thresholding.

Morphological Operations: Performs hole filling and edge removal.

Labeling and Small Object Removal: Labels objects and removes small ones.

Bounding Box Application: Draws red rectangles around detected weed regions.

Performance Evaluation: Computes sensitivity, specificity, positive predictive value, and negative predictive value.

Dependencies

MATLAB with Image Processing Toolbox

Usage

Run the script in MATLAB.

Select an image file when prompted.

View processed images and detection results.

Check console for calculated performance metrics.

Output

Processed images displayed in figures.

Bounding boxes around detected weed regions.

Sensitivity, specificity, and predictive values printed in the MATLAB console.

Author

JILLELLA RAGHUNATH
