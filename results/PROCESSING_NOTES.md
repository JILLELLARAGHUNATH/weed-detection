# Processing Preview Notes

This folder documents the Python-generated image-processing previews for the 11 sample images supplied with this project.

## Processing stages

1. Read each RGB input image.
2. Calculate the Excess Green index: `ExG = 2G - R - B`.
3. Normalize ExG per image for visualization and thresholding.
4. Apply a 3 × 3 median filter.
5. Calculate an Otsu threshold independently for each image.
6. Apply morphological opening and closing.
7. Identify connected vegetation-candidate regions and draw bounding boxes.

## Provenance and limitations

- These previews were generated with Python from the supplied images. They are not MATLAB execution outputs.
- The Python workflow is an illustrative implementation of the documented processing approach, not a verified MATLAB-equivalent run.
- Green vegetation may include crop plants as well as weeds. Bounding boxes indicate candidate vegetation regions only.
- Candidate counts and thresholds are image-processing outputs, not weed counts or model-performance measurements.
- No accuracy, precision, recall, F1-score, specificity, or IoU claims are made.
- Thresholds are calculated independently for each image; comparisons between images should be interpreted cautiously.

The preview gallery and CSV summary provide a compact view of the generated candidate overlays, image dimensions, thresholds, and candidate-region counts.
