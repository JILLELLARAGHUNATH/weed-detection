<div align="center">

<img src="assets/weed-detection-banner.svg" alt="Weed Detection in Crops — MATLAB Image Processing" width="100%"/>

# 🌱 Weed Detection in Crops

### MATLAB Image Processing Prototype

<p>
  <img src="https://img.shields.io/badge/MATLAB-Image%20Processing-orange?style=for-the-badge&logo=mathworks&logoColor=white" alt="MATLAB"/>
  <img src="https://img.shields.io/badge/Computer%20Vision-Image%20Segmentation-16a34a?style=for-the-badge" alt="Computer Vision"/>
  <img src="https://img.shields.io/badge/Project-Academic-2563eb?style=for-the-badge" alt="Academic project"/>
</p>

<p>
  <a href="#overview">Overview</a> ·
  <a href="#features">Features</a> ·
  <a href="#getting-started">Getting Started</a> ·
  <a href="#processing-workflow">Workflow</a> ·
  <a href="#sample-image-previews">Sample Previews</a> ·
  <a href="#limitations">Limitations</a>
</p>

</div>

---

## Overview

Weeds compete with crops for water, nutrients, sunlight, and growing space. This repository explores a classical computer-vision workflow for highlighting **potential vegetation regions** in crop-field images using MATLAB and the Image Processing Toolbox.

The project includes the original MATLAB script, a separate improved implementation, sample input images, and documentation of an additional Python-based preview run.

> [!IMPORTANT]
> This is an image-processing prototype. Green vegetation candidates are not automatically confirmed weeds. Crop-versus-weed classification requires additional context and independent validation.

## Features

| Capability | Description |
|---|---|
| Image input | Select a field image for processing |
| Vegetation emphasis | Green-channel difference in the original approach; Excess Green (ExG) in the improved script |
| Noise reduction | Median filtering |
| Thresholding | Otsu threshold selection |
| Morphology | Opening, closing and hole filling in the improved pipeline |
| Region analysis | Connected components, region measurements and candidate bounding boxes |
| Export | Intermediate images and CSV summary from the improved MATLAB script |

## Technology

- **Language:** MATLAB
- **Required toolbox:** MATLAB Image Processing Toolbox
- **Methods:** Colour-based vegetation emphasis, filtering, threshold segmentation, mathematical morphology and connected-component analysis
- **Preview processing:** Python-generated illustrative outputs from the 11 supplied sample images

## Repository Structure

```text
weed-detection/
├── assets/
│   ├── weed-detection-banner.svg
│   ├── processing-workflow.svg
│   └── exg-processing-pipeline.svg
├── results/
│   ├── PROCESSING_NOTES.md
│   └── processing_summary.csv
├── README.md
└── weed detection in crops/
    └── Code/
        ├── main.m
        ├── main_improved.m
        └── sample images/
            └── weed1 ... weed11
```

**Preservation note:** The original `weed detection in crops/Code/main.m` is retained unchanged. The improved implementation is kept separately as `main_improved.m`.

## Getting Started

### Prerequisites

- MATLAB
- MATLAB Image Processing Toolbox
- A desktop MATLAB session for image selection and figure display

### 1. Clone the repository

```bash
git clone https://github.com/JILLELLARAGHUNATH/weed-detection.git
cd weed-detection
```

### 2. Open the code folder in MATLAB

Set the current folder to:

```text
weed detection in crops/Code/
```

### 3. Run the improved implementation

Open `main_improved.m` and select **Run**, or enter:

```matlab
run('main_improved.m')
```

Choose a JPG, JPEG, PNG or TIFF image when prompted. The improved script is designed to save intermediate processing images, an annotated candidate-region figure and a CSV summary beside the selected image.

The original `main.m` remains available for reference and has not been replaced.

## Processing Workflow

<p align="center">
  <img src="assets/exg-processing-pipeline.svg" alt="Excess Green image-processing workflow" width="100%"/>
</p>

The improved script follows these stages:

1. Read the input image and prepare its colour channels.
2. Calculate the Excess Green index: `ExG = 2G - R - B`.
3. Normalize the ExG image for thresholding.
4. Apply a median filter.
5. Select a threshold using Otsu's method.
6. Refine the binary mask using morphological operations and hole filling.
7. Identify connected components and measure candidate regions.
8. Visualize candidate regions with bounding boxes and export processing outputs.

The original research approach described in the supplied paper uses green-channel minus grayscale. The ExG formula above belongs to the separate improved script; the two formulas should not be described as identical.

## Sample Image Previews

Eleven supplied sample images were processed in a separate Python preview workflow. The preview procedure applies ExG emphasis, median filtering, per-image Otsu thresholding, morphological cleanup and connected-component candidate boxes.

- [Processing summary CSV](results/processing_summary.csv)
- [Processing methodology and provenance](results/PROCESSING_NOTES.md)

> [!NOTE]
> The Python previews are not MATLAB execution outputs and are not a verified MATLAB-equivalent run. Candidate boxes indicate vegetation regions, not confirmed weed detections. The preview thresholds are calculated independently per image and are not benchmark scores.

## Limitations

1. **Crop/weed colour similarity:** Crop leaves and weeds can have similar green values, producing false positives or missed regions.
2. **Lighting variation:** Shadows, reflections, exposure and soil conditions affect segmentation.
3. **No semantic classifier:** The current pipeline does not identify weed species or reliably distinguish every crop plant from a weed.
4. **Ground-truth evaluation is not established:** Valid performance metrics require independently annotated reference masks.
5. **MATLAB execution status:** The improved MATLAB script has been prepared, but execution and output validation in MATLAB have not been completed in this development environment.

The legacy `main.m` derives its comparison mask from the input image rather than an independent annotation. Its printed sensitivity, specificity, PPV and NPV should therefore not be presented as validated model-performance metrics. The improved script intentionally does not report these metrics.

## Future Enhancements

- [ ] Add manually annotated ground-truth masks.
- [ ] Build a repeatable train/validation/test evaluation dataset.
- [ ] Calculate precision, recall, F1-score, specificity and IoU from valid annotations.
- [ ] Improve robustness to changing light and soil backgrounds.
- [ ] Add batch processing and exportable result images.
- [ ] Compare classical image processing with deep-learning segmentation methods.
- [ ] Create a MATLAB App Designer interface.

## Contributing

1. Fork the repository.
2. Create a feature branch.
3. Make and test changes in MATLAB.
4. Open a pull request describing the change and how it was tested.

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

**Built with MATLAB · Image Processing · Computer Vision 🌱**

</div>
