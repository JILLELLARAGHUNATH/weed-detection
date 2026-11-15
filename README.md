# Weed Detection in Crops Using MATLAB Image Processing

An image-processing prototype that identifies potential weed regions in crop images using colour-channel analysis, threshold segmentation, morphological operations, and region-based bounding boxes.

> **Project status:** Academic prototype / experimental implementation. Detection results depend on image quality, lighting, crop type, and the selected threshold. The current evaluation code should be reviewed before interpreting its printed metrics as validated accuracy.

## Overview

Weeds compete with crops for water, nutrients, sunlight, and growing space. Detecting weed regions in crop images can support more targeted monitoring and weed-management workflows.

This project explores a classical computer-vision approach in MATLAB. It processes a user-selected image, creates a binary segmentation, extracts connected regions, and displays candidate regions with red bounding boxes.

## Features

- Interactive selection of a JPG image.
- RGB image inspection and grayscale conversion.
- Green-channel and grayscale-based image processing.
- Median filtering for noise reduction.
- Automatic threshold selection using Otsu's method (`graythresh`).
- Binary image segmentation and morphological processing.
- Connected-component labelling and region measurements.
- Visualisation of candidate regions using red bounding boxes.

## Technology Stack

| Component | Technology |
|---|---|
| Programming language | MATLAB |
| Image processing | MATLAB Image Processing Toolbox |
| Input | JPG crop / field images |
| Detection approach | Colour-based segmentation and morphology |

## Repository Structure

```text
weed-detection/
├── README.md
└── weed detection in crops/
    └── Code/
        ├── main.m
        └── sample images/
            ├── weed1.jpg
            ├── weed2.jpg
            ├── ...
            └── weed11.JPG
```

## Requirements

- MATLAB.
- MATLAB **Image Processing Toolbox**.
- A desktop session capable of displaying MATLAB figures and opening the image-selection dialog.
- JPG input images.

The script uses functions such as `rgb2gray`, `medfilt2`, `graythresh`, `imfill`, `bwmorph`, `bwlabel`, `bwareaopen`, and `regionprops`, which require image-processing functionality.

## Getting Started

### 1. Clone the repository

```bash
git clone https://github.com/JILLELLARAGHUNATH/weed-detection.git
cd weed-detection
```

### 2. Open the project in MATLAB

Open MATLAB and navigate to:

```text
weed detection in crops/Code/
```

### 3. Run the script

Open `main.m` and click **Run**, or execute it from the MATLAB Command Window:

```matlab
run('main.m')
```

### 4. Select an image

When the file-selection dialog appears, choose a JPG image. Sample images are available in the `sample images` folder.

### 5. View the output

The script opens figures for intermediate processing stages and a final image with red rectangles around candidate regions. It also prints evaluation-related values in the MATLAB Command Window.

## Processing Workflow

1. **Image input:** Load the selected RGB image.
2. **Grayscale conversion:** Convert the RGB image to grayscale.
3. **Colour-channel extraction:** Separate the red, green, and blue channels.
4. **Green-channel subtraction:** Subtract the grayscale image from the green channel to emphasise colour differences.
5. **Noise reduction:** Apply a median filter to reduce local noise.
6. **Thresholding:** Estimate a threshold using Otsu's method and create a binary image.
7. **Morphological processing:** Fill holes and apply a morphological boundary operation.
8. **Connected components:** Label segmented regions and measure their properties.
9. **Region filtering and visualisation:** Use region measurements to select candidate regions and draw red bounding boxes on the original image.

## Output

The current script displays:

- The original input image.
- Intermediate grayscale, filtered, and segmented images.
- Morphological and labelled-region visualisations.
- A final image with red bounding boxes around candidate regions.
- Evaluation-related values in the MATLAB Command Window.

**Important:** A bounding box indicates a candidate segmented region; it does not prove that the region is a weed. The current implementation does not use a trained machine-learning model or distinguish weed species.

## Important Notes and Limitations

- **Lighting sensitivity:** Colour-based segmentation can change significantly under shadows, direct sunlight, and different camera settings.
- **Crop and weed variation:** Similar green colours between crops and weeds can cause false detections or missed regions.
- **Input assumptions:** The script is currently written around RGB JPG images. Other formats and image types may require additional handling.
- **Ground-truth evaluation:** The current script derives a comparison image from the input image itself rather than loading a manually annotated ground-truth mask. Therefore, its sensitivity, specificity, positive predictive value, and negative predictive value calculations are **not a validated measure of detection performance**.
- **Implementation review:** The region-cleaning and bounding-box selection logic should be validated with labelled test images before the project is used for quantitative claims or real agricultural decisions.

## Possible Future Improvements

- Use manually annotated ground-truth masks for reliable evaluation.
- Report precision, recall, F1-score, specificity, and intersection over union (IoU) on a separate test set.
- Improve segmentation under variable lighting using colour-space transformations and adaptive thresholding.
- Add robust input validation and support for common image formats.
- Compare the classical image-processing pipeline with trained object-detection or semantic-segmentation models.
- Build a simple user interface for batch processing and result export.

## Author

**Jillella Raghunath**

GitHub: [@JILLELLARAGHUNATH](https://github.com/JILLELLARAGHUNATH)

## License

No license is currently specified in this repository. Unless a license is added, the default copyright rules apply and reuse or redistribution is not automatically granted.
