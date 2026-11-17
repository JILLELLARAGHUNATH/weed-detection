<div align="center">

<img src="assets/weed-detection-banner.svg" alt="Weed Detection in Crops — MATLAB Image Processing" width="100%"/>

# 🌱 Weed Detection in Crops

### MATLAB-Based Image Processing and Computer Vision

<p>
  <img src="https://img.shields.io/badge/MATLAB-Image%20Processing-orange?style=for-the-badge&logo=mathworks&logoColor=white" alt="MATLAB"/>
  <img src="https://img.shields.io/badge/Computer%20Vision-Image%20Segmentation-16a34a?style=for-the-badge" alt="Computer Vision"/>
  <img src="https://img.shields.io/badge/Project-Academic-2563eb?style=for-the-badge" alt="Academic project"/>
</p>

<p>
  <a href="#overview">Overview</a> ·
  <a href="#key-features">Features</a> ·
  <a href="#methodology">Methodology</a> ·
  <a href="#research-reference-results">Research Results</a> ·
  <a href="#sample-image-results">Sample Results</a> ·
  <a href="#getting-started">Run the Project</a>
</p>

</div>

---

## Overview

**Weed Detection in Crops** is an academic image-processing project that explores how computer-vision techniques can highlight vegetation regions in crop-field images. The workflow uses colour-channel information, filtering, threshold-based segmentation, morphological operations and connected-component analysis.

The repository contains the original MATLAB implementation, a separately maintained improved implementation, project documentation and visual previews for the supplied sample images.

The project is based on a published image-processing approach and is intended as a practical prototype for studying vegetation segmentation. Highlighted regions should be interpreted as **potential vegetation candidates**, not confirmed weed classifications.

## Project Objectives

- Process crop-field images using MATLAB image-processing techniques.
- Emphasise green vegetation regions against the surrounding background.
- Reduce image noise and segment vegetation using thresholding.
- Analyse connected regions and visualise candidate areas.
- Study the strengths and limitations of colour-based weed detection.

## Key Features

| Feature | What it does |
|---|---|
| Image selection | Allows the user to choose a crop-field image |
| Vegetation emphasis | Uses green-channel information in the original script and Excess Green (ExG) in the separate improved script |
| Noise filtering | Applies median filtering to reduce noise |
| Image segmentation | Uses Otsu thresholding to create a binary mask |
| Morphological processing | Cleans segmented regions and fills holes |
| Connected-component analysis | Labels regions and measures their properties |
| Visual output | Displays detected candidate regions using bounding boxes |
| Sample gallery | Provides visual previews for the 11 supplied sample images |

## Technologies and Techniques

- **Programming environment:** MATLAB
- **Toolbox:** MATLAB Image Processing Toolbox
- **Image-processing methods:** Colour-based vegetation emphasis, median filtering, Otsu thresholding, mathematical morphology and connected-component analysis
- **Additional documentation previews:** Python-generated visual previews

## Methodology

The project contains two MATLAB approaches. They are related, but their vegetation-emphasis calculations are different.

### 1. Original approach

The original MATLAB script uses the green channel minus the grayscale image:

**Iplant(x,y) = Igreen(x,y) - Igray(x,y)**

The resulting image is filtered and segmented, followed by morphological processing and connected-component analysis.

### 2. Improved approach

The separate improved MATLAB script uses the Excess Green index:

**ExG = 2G - R - B**

It then normalises the vegetation-emphasis image, applies median filtering and Otsu thresholding, cleans the binary mask, and analyses connected regions.

### Processing workflow

<p align="center">
  <img src="assets/processing-workflow.svg" alt="Original MATLAB image-processing workflow" width="100%"/>
</p>

The improved implementation follows these stages:

1. Read the input image and separate its colour channels.
2. Calculate the Excess Green index.
3. Normalise the ExG image.
4. Apply a median filter.
5. Determine a threshold using Otsu's method.
6. Apply morphological operations and hole filling.
7. Label connected components and measure candidate regions.
8. Display bounding boxes and save processing outputs.

<p align="center">
  <img src="assets/exg-processing-pipeline.svg" alt="Excess Green image-processing pipeline" width="100%"/>
</p>

> **Implementation note:** The original script is preserved as **main.m**. The ExG-based approach is provided separately as **main_improved.m**.

## Research Reference Results

The project documentation refers to the published paper **“Algorithm of Weed Detection in Crops by Computational Vision”** by A. J. Irías Tejeda and R. Castro Castro, presented at CONIELECOMP 2019.

The paper reports the following overall results for its evaluated method:

| Evaluation measure | Result reported in the paper |
|---|---:|
| Sensitivity | 97% |
| Specificity | 79% |
| Positive Predictive Value (PPV) | 99% |
| Negative Predictive Value (NPV) | 47% |
| Processing time | 2.98 seconds |

### Understanding the reported results

- **Sensitivity (97%):** The paper reports a high rate of correctly identifying weed regions.
- **Specificity (79%):** Some crop plants with sizes similar to weeds were identified as weeds, contributing to false positives.
- **PPV (99%):** The paper reports a high proportion of positive detections as correct.
- **NPV (47%):** Some weeds similar in size to crop plants were classified as crop plants.
- **Processing time (2.98 seconds):** The processing time reported by the paper for its evaluated setup.

**Source and attribution:** These figures are results reported by the referenced 2019 research paper. They are included as literature-review/reference results and are **not presented as measurements from this repository's MATLAB implementation**. The paper's method and evaluation setup should be consulted when interpreting or comparing these values.

## Sample Image Results

The repository includes 11 supplied sample images and a gallery of vegetation-candidate previews.

![Gallery of vegetation candidate previews](results/gallery.jpg)

### Individual sample previews

The table below lists the sample image dimensions and the candidate-region counts recorded by the preview-processing workflow.

| Sample image | Resolution | Candidate regions | Preview |
|---|---:|---:|---|
| weed1.jpg | 606 × 397 | 25 | [View image](results/preview_images/weed1_candidates.jpg) |
| weed2.jpg | 374 × 284 | 39 | [View image](results/preview_images/weed2_candidates.jpg) |
| weed3.jpg | 600 × 406 | 45 | [View image](results/preview_images/weed3_candidates.jpg) |
| weed4.jpg | 350 × 406 | 18 | [View image](results/preview_images/weed4_candidates.jpg) |
| weed5.jpg | 644 × 491 | 18 | [View image](results/preview_images/weed5_candidates.jpg) |
| weed6.jpg | 1200 × 800 | 13 | [View image](results/preview_images/weed6_candidates.jpg) |
| weed7.jpg | 721 × 497 | 10 | [View image](results/preview_images/weed7_candidates.jpg) |
| weed8.jpg | 375 × 500 | 75 | [View image](results/preview_images/weed8_candidates.jpg) |
| weed9.JPG | 240 × 320 | 20 | [View image](results/preview_images/weed9_candidates.jpg) |
| weed10.jpg | 400 × 322 | 58 | [View image](results/preview_images/weed10_candidates.jpg) |
| weed11.JPG | 293 × 389 | 14 | [View image](results/preview_images/weed11_candidates.jpg) |

- [View the processing summary](results/processing_summary.csv)
- [Browse all preview images](results/preview_images/)
- [Read the preview-processing notes](results/PROCESSING_NOTES.md)

*Preview note: The gallery images and candidate counts are supplementary Python-generated previews of the supplied sample images. They illustrate the segmentation workflow; candidate regions are not ground-truth weed labels or accuracy measurements.*

## Repository Structure

    weed-detection/
    ├── assets/
    │   ├── weed-detection-banner.svg
    │   ├── processing-workflow.svg
    │   └── exg-processing-pipeline.svg
    ├── results/
    │   ├── gallery.jpg
    │   ├── processing_summary.csv
    │   ├── PROCESSING_NOTES.md
    │   └── preview_images/
    ├── README.md
    └── weed detection in crops/
        └── Code/
            ├── main.m
            ├── main_improved.m
            └── sample images/
                └── weed1 ... weed11

## Getting Started

### Prerequisites

- MATLAB
- MATLAB Image Processing Toolbox
- Desktop MATLAB session for image selection and figure display

### 1. Clone the repository

    git clone https://github.com/JILLELLARAGHUNATH/weed-detection.git
    cd weed-detection

### 2. Open the code folder

In MATLAB, set the current folder to:

    weed detection in crops/Code/

### 3. Run the improved implementation

Open **main_improved.m** in MATLAB and select **Run**, or execute:

    run('main_improved.m')

Select an image when the file-selection dialog appears. The script displays the processing stages and saves intermediate outputs and candidate-region information beside the selected image.

To inspect the original implementation, open and run **main.m**.

## Validation Status

The repository includes MATLAB source code and supplementary sample-image previews. **The MATLAB scripts have not been executed or runtime-validated as part of this update**, because a MATLAB environment was not available.

The sample gallery and candidate counts are Python-generated previews, not MATLAB execution outputs or verified weed-detection results. They are provided to illustrate the image-processing concept only. No project-specific accuracy, precision, recall, F1-score or processing-time claim is made.

To validate the MATLAB implementation, run the original scripts in MATLAB with the Image Processing Toolbox and record outputs from the actual execution.

## Limitations and Scope

1. **Similar appearance:** Crop plants and weeds can have similar colour and size characteristics, which can lead to incorrect candidate regions.
2. **Lighting conditions:** Shadows, reflections, exposure and soil colour can affect threshold-based segmentation.
3. **Candidate detection, not semantic recognition:** The colour-based workflow highlights vegetation regions; it does not reliably identify weed species or distinguish every crop plant from a weed.
4. **Ground-truth evaluation:** Project-specific accuracy metrics require independently annotated reference masks and a documented evaluation procedure.
5. **Execution environment:** Run the MATLAB scripts with the required toolbox to verify their behaviour in your MATLAB environment.

The sensitivity, specificity, PPV and NPV listed in the research section belong to the cited paper. They should not be interpreted as validated performance measurements for this repository.

## Future Enhancements

- Prepare manually annotated ground-truth masks for the sample images.
- Evaluate segmentation using precision, recall, F1-score and Intersection over Union (IoU).
- Improve robustness to changing lighting and soil conditions.
- Explore methods to distinguish crop plants from weeds more reliably.
- Compare classical image processing with machine-learning and deep-learning approaches.

## Reference

A. J. Irías Tejeda and R. Castro Castro, **“Algorithm of Weed Detection in Crops by Computational Vision,”** *2019 International Conference on Electronics, Communications and Computers (CONIELECOMP)*, 2019, pp. 124–128.

## Author

<div align="center">

**Jillella Raghunath**

<a href="https://github.com/JILLELLARAGHUNATH">
  <img src="https://img.shields.io/badge/GitHub-JILLELLARAGHUNATH-181717?style=for-the-badge&logo=github" alt="GitHub profile"/>
</a>

</div>

## License

No license file is currently present. Until a license is added, the repository remains subject to default copyright rules; reuse and redistribution are not automatically permitted.

---

<div align="center">

**MATLAB · Image Processing · Computer Vision 🌱**

</div>
