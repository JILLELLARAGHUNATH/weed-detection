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

### Algorithm details

#### Original script: `main.m`

The original implementation performs the following operations:

1. Reads a user-selected JPG image and converts it to grayscale with `rgb2gray`.
2. Extracts the red, green and blue channels.
3. Subtracts the grayscale image from the green channel: `greenChannel - grayImage`.
4. Applies a median filter using `medfilt2`.
5. Calculates an Otsu threshold with `graythresh` and creates a binary image with `im2bw`.
6. Fills holes, applies the `remove` morphological operation, labels regions and calls `bwareaopen`.
7. Measures region areas and draws bounding boxes for regions smaller than the calculated average area.

The final size-based selection is a heuristic in the source code. It does not establish that a region is a weed. The original script also applies `bwareaopen` to the labelled image rather than explicitly to a logical binary mask, so its region-cleanup behaviour should be checked in MATLAB before relying on the output.

#### Improved script: `main_improved.m`

The improved implementation uses a more explicit vegetation-candidate segmentation pipeline:

| Stage | Implementation | Purpose |
|---|---|---|
| Input normalization | Converts input to 8-bit RGB; grayscale images are replicated across three channels and extra channels are discarded | Provides a three-channel image for colour calculations |
| Excess Green | `ExG = 2G - R - B` | Emphasises green relative to red and blue |
| Normalization | `mat2gray` | Scales the ExG image for subsequent processing |
| Smoothing | 3 × 3 median filter with symmetric padding | Reduces local noise |
| Thresholding | Otsu threshold from `graythresh`, applied with `imbinarize` | Produces an initial binary candidate mask |
| Morphological opening | Disk structuring element, radius 2 | Removes small foreground details and narrow connections |
| Morphological closing | Disk structuring element, radius 3 | Closes small gaps in foreground regions |
| Hole filling | `imfill(..., 'holes')` | Fills enclosed holes in candidate regions |
| Small-region removal | `bwareaopen` with minimum area `max(10, round(imagePixels × 0.0001))` | Removes connected foreground components below the configured size |
| Region analysis | 8-connected components and `regionprops` | Measures area, bounding box, centroid and eccentricity |

The improved script uses a per-image Otsu threshold. Its output therefore depends on the distribution of pixel values in each selected image. The morphological size settings are fixed relative to the image dimensions only for the minimum-area threshold; the disk radii remain fixed pixel values.

### How to interpret the algorithms

Both implementations rely on colour and connected-region geometry. Neither uses labelled training data, a learned classifier, plant-species recognition or a crop-versus-weed decision model. A green region can belong to a crop, weed or another object. Soil, shadows, illumination, camera white balance, overlapping leaves and image resolution can affect the masks.

The two scripts should be treated as separate approaches, not as interchangeable versions of one identical algorithm. The improved script's more explicit preprocessing and output handling do not, by themselves, prove higher detection accuracy. A fair comparison requires the same test images, a defined reference annotation, and a documented evaluation procedure.

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

## Visual walkthrough

<p align="center">
  <img src="assets/exg-processing-pipeline.svg" alt="Animated Excess Green image-processing pipeline" width="100%"/>
</p>

<p align="center">
  <sub>Follow the image from RGB input to a cleaned vegetation-candidate mask. The animated arrows show the processing flow; they do not represent live model execution.</sub>
</p>

---

## Quick Project Summary

| Item | Details |
|---|---|
| Project type | Academic image-processing prototype |
| Main environment | MATLAB |
| Main toolbox | Image Processing Toolbox |
| Input | Crop-field image selected by the user |
| Processing | Vegetation emphasis, filtering, thresholding and morphology |
| Output | Visualised vegetation-candidate regions |
| Current validation | MATLAB runtime validation is pending |

This project currently performs **colour-based vegetation segmentation**. It does not yet provide a validated, general-purpose weed-versus-crop classifier.

<details>
<summary><strong>Technical details: script comparison, compatibility, input guidance and troubleshooting</strong></summary>

## Which MATLAB Script Should I Run?

| Script | Method | Purpose |
|---|---|---|
| `main.m` | Green channel minus grayscale | Original implementation |
| `main_improved.m` | Excess Green (ExG = 2G − R − B) | Separate improved vegetation-segmentation approach |

The two scripts use different vegetation-emphasis calculations. Run them separately when comparing their behaviour; do not treat their outputs as directly equivalent.

### Script compatibility and implementation notes

| Detail | `main.m` | `main_improved.m` |
|---|---|---|
| File selection | JPG files only | JPG, JPEG, PNG, TIF and TIFF |
| Input handling | Expects a colour RGB image | Converts grayscale input to RGB and uses the first three channels if extra channels are present |
| Cancellation handling | Does not explicitly handle cancelling the file picker | Cancelling the file picker safely stops processing |
| Saved files | Displays figures; does not create the structured output folder used by the improved script | Creates an `<image-name>_weed_detection_output` folder beside the selected image |

**Recommendation:** Start with `main_improved.m`. It has clearer input handling and saves the intermediate masks and candidate-region data. The original `main.m` is retained for comparison and contains older assumptions; for example, it expects a JPG RGB image and should be tested carefully with different inputs.

The original script also calculates sensitivity, specificity, PPV and NPV using a thresholded version of the input image as its comparison mask. That is not manually annotated ground truth, so those printed values must not be treated as a valid project evaluation. Use independently labelled reference masks for any performance evaluation.

The original script also has a fragile region-count assumption: it accesses `region_img(2)` directly. If fewer than two regions are available, execution can stop at that line. It also suppresses MATLAB warnings globally with `warning off`, which can make troubleshooting harder. These are additional reasons to use `main_improved.m` as the starting point.

## Input Image Guidance

For a useful first test:

- Choose a clear crop-field image in a supported common image format such as JPG or PNG.
- Prefer an image with visible vegetation and soil/background.
- Avoid starting with heavily blurred, extremely dark, or overexposed images.
- Keep the original sample image unchanged so that results can be compared consistently.
- Record the image filename and its dimensions when documenting a test.

Lighting, shadows, soil colour, camera angle and overlapping leaves can all change the segmentation result. A highlighted region should therefore be treated as a candidate, not as a confirmed weed.

## Understanding the Processing Output

The workflow is intended to make intermediate image-processing stages inspectable:

1. **Input image:** the original crop-field photograph.
2. **Vegetation emphasis:** a representation that increases the contrast of green vegetation.
3. **Filtered image:** a noise-reduced representation.
4. **Binary mask:** pixels selected by thresholding.
5. **Morphological result:** a mask refined by shape-based operations.
6. **Connected components:** separate regions measured as candidate objects.
7. **Overlay:** candidate regions visualised on the input image.

A connected component is only a region in the binary mask. It is not proof that the region is a weed. Crop plants, weeds, shadows and other green objects may be included.

## Reproducible Testing Checklist

When MATLAB becomes available, use this checklist for each test:

- [ ] Record the MATLAB release and operating system.
- [ ] Confirm that Image Processing Toolbox is installed.
- [ ] Record which script was run: `main.m` or `main_improved.m`.
- [ ] Record the exact input image filename and dimensions.
- [ ] Save the original input image and generated output separately.
- [ ] Record any warnings or errors shown in the MATLAB Command Window.
- [ ] Inspect the binary mask and overlay, not only the final bounding boxes.
- [ ] Repeat the test with more than one lighting condition.
- [ ] Compare candidate regions against manually annotated ground truth before calculating metrics.

Do not report accuracy, precision, recall, F1-score, IoU or execution time until the evaluation data, procedure and actual measurements are available.

</details>

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

Select a JPG, JPEG, PNG, TIF or TIFF image when the file-selection dialog appears. The script displays the processing stages and creates an output folder beside the selected image, named `<image-name>_weed_detection_output`.

The improved script saves these outputs:

- `01_original.png` — normalized RGB input image.
- `02_excess_green.png` — normalized Excess Green image.
- `03_filtered.png` — median-filtered vegetation index.
- `04_initial_segmentation.png` — thresholded binary mask.
- `05_cleaned_mask.png` — mask after morphological cleanup.
- `candidate_regions.csv` — region ID, area in pixels and eccentricity; created when at least one candidate region is found.
- `06_detection_result.png` — annotated candidate overlay. If figure export is unavailable, the script falls back to `07_detection_result.png`.

To inspect the original implementation, open and run **main.m** separately. It accepts JPG input only and does not create the same structured output folder.

## Troubleshooting

| Symptom | Likely explanation | What to check |
|---|---|---|
| MATLAB reports that a function such as `imbinarize`, `imopen`, `bwconncomp` or `regionprops` is undefined | The required Image Processing Toolbox may be missing or unavailable | Confirm that Image Processing Toolbox is installed and licensed in your MATLAB environment |
| The file-selection dialog closes without processing | No input image was selected | In `main_improved.m`, cancelling the dialog intentionally stops the script; run it again and choose a supported image |
| An image does not appear in the file picker | Its extension may not be supported by the selected script | `main.m` accepts JPG files; `main_improved.m` accepts JPG, JPEG, PNG, TIF and TIFF |
| The output folder or image files are not created | MATLAB may not have permission to write beside the selected input image, or the destination may be unavailable | Choose an input image in a folder where you have write permission, then run the improved script again |
| No candidate boxes appear | The thresholded and cleaned mask may contain no connected foreground regions | Inspect the Excess Green image, initial segmentation and cleaned mask; try another well-lit image with visible vegetation |
| The CSV file is missing from the output folder | The improved script writes `candidate_regions.csv` only when at least one candidate region is found | Check the cleaned mask and the Command Window's reported candidate-region count |
| The annotated result is saved as `07_detection_result.png` instead of `06_detection_result.png` | The script's `exportgraphics` call failed and its fallback save operation was used | Open the fallback image and check the MATLAB Command Window for any export-related message |

**Important:** These checks are based on the current source code. They are troubleshooting guidance, not evidence that the scripts have been executed successfully in a MATLAB environment. The original `main.m` does not include the improved script's file-picker cancellation handling and may fail if the dialog is cancelled.

---

<details>
<summary><strong>Validation status, evaluation checklist, limitations and future enhancements</strong></summary>

## Validation Status

The repository includes MATLAB source code and supplementary sample-image previews. **The MATLAB scripts have not been executed or runtime-validated as part of this update**, because a MATLAB environment was not available.

The sample gallery and candidate counts are Python-generated previews, not MATLAB execution outputs or verified weed-detection results. They are provided to illustrate the image-processing concept only. No project-specific accuracy, precision, recall, F1-score or processing-time claim is made.

To validate the MATLAB implementation, run the original scripts in MATLAB with the Image Processing Toolbox and record outputs from the actual execution.

### What is needed to complete validation?

A meaningful project evaluation needs a small, documented test set with manually annotated weed/crop masks. For each image, compare the predicted segmentation mask with its reference mask and report the evaluation protocol alongside the measurements.

For binary segmentation, commonly used measures include:

- **Precision:** proportion of predicted positive pixels/regions that are truly positive.
- **Recall:** proportion of reference positive pixels/regions that are detected.
- **F1-score:** harmonic mean of precision and recall.
- **Intersection over Union (IoU):** overlap between the predicted and reference masks divided by their union.

The positive class (for example, weed pixels) must be defined consistently before calculating these metrics. If the current workflow only detects vegetation candidates, do not label those candidates as weeds in the evaluation without a reliable annotation rule.

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

</details>

## Reference

A. J. Irías Tejeda and R. Castro Castro, **“Algorithm of Weed Detection in Crops by Computational Vision,”** *2019 International Conference on Electronics, Communications and Computers (CONIELECOMP)*, 2019, pp. 124–128. [https://doi.org/10.1109/CONIELECOMP.2019.8673182](https://doi.org/10.1109/CONIELECOMP.2019.8673182).

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
