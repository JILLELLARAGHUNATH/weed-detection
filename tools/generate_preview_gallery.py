#!/usr/bin/env python3
"""Generate reproducible vegetation-candidate previews from repository samples.

These are Python previews of a classical ExG pipeline, not MATLAB outputs or
validated crop-versus-weed classifications.
"""
from pathlib import Path
import csv
import cv2
import numpy as np

ROOT = Path(__file__).resolve().parents[1]
SAMPLE_DIR = ROOT / "weed detection in crops" / "Code" / "sample images"
RESULTS = ROOT / "results"
PREVIEWS = RESULTS / "preview_images"
RESULTS.mkdir(exist_ok=True)
PREVIEWS.mkdir(exist_ok=True)

extensions = {".jpg", ".jpeg", ".png", ".tif", ".tiff", ".bmp"}
images = sorted(p for p in SAMPLE_DIR.iterdir() if p.is_file() and p.suffix.lower() in extensions)
if not images:
    raise SystemExit(f"No supported sample images found in {SAMPLE_DIR}")

rows = []
cards = []
for index, path in enumerate(images, start=1):
    bgr = cv2.imread(str(path), cv2.IMREAD_COLOR)
    if bgr is None:
        print(f"Skipping unreadable image: {path.name}")
        continue

    image = cv2.cvtColor(bgr, cv2.COLOR_BGR2RGB)
    rgb = image.astype(np.float32)
    r, g, b = cv2.split(rgb)
    exg = 2.0 * g - r - b
    exg_norm = cv2.normalize(exg, None, 0, 255, cv2.NORM_MINMAX).astype(np.uint8)
    filtered = cv2.medianBlur(exg_norm, 3)
    threshold, mask = cv2.threshold(filtered, 0, 255, cv2.THRESH_BINARY + cv2.THRESH_OTSU)

    kernel = cv2.getStructuringElement(cv2.MORPH_ELLIPSE, (3, 3))
    cleaned = cv2.morphologyEx(mask, cv2.MORPH_OPEN, kernel)
    cleaned = cv2.morphologyEx(cleaned, cv2.MORPH_CLOSE, kernel)
    min_area = max(12, int(image.shape[0] * image.shape[1] * 0.00015))
    count, labels, stats, centroids = cv2.connectedComponentsWithStats(cleaned, connectivity=8)

    annotated = image.copy()
    candidate_count = 0
    for label in range(1, count):
        x, y, w, h, area = stats[label]
        if area < min_area:
            continue
        candidate_count += 1
        cv2.rectangle(annotated, (x, y), (x + w, y + h), (255, 70, 55), 2)

    preview_path = PREVIEWS / f"{path.stem}_candidates.jpg"
    cv2.imwrite(str(preview_path), cv2.cvtColor(annotated, cv2.COLOR_RGB2BGR), [cv2.IMWRITE_JPEG_QUALITY, 88])

    rows.append({
        "image": path.name,
        "width": int(image.shape[1]),
        "height": int(image.shape[0]),
        "otsu_threshold_0_255": round(float(threshold), 2),
        "candidate_regions_after_area_filter": candidate_count,
        "minimum_component_area_pixels": min_area,
        "preview": f"preview_images/{preview_path.name}",
    })

    # Consistent thumbnail cards: original beside candidate overlay.
    def fit(img, target_w=440, target_h=230):
        h, w = img.shape[:2]
        scale = min(target_w / w, target_h / h)
        nw, nh = max(1, int(w * scale)), max(1, int(h * scale))
        resized = cv2.resize(img, (nw, nh), interpolation=cv2.INTER_AREA)
        canvas = np.full((target_h, target_w, 3), 248, dtype=np.uint8)
        y0, x0 = (target_h - nh) // 2, (target_w - nw) // 2
        canvas[y0:y0+nh, x0:x0+nw] = resized
        return canvas

    left, right = fit(image), fit(annotated)
    card = np.full((300, 920, 3), 255, dtype=np.uint8)
    card[48:278, 10:450] = left
    card[48:278, 470:910] = right
    cv2.putText(card, f"{index:02d}. {path.name} | Original", (12, 30),
                cv2.FONT_HERSHEY_SIMPLEX, 0.62, (35, 65, 48), 2, cv2.LINE_AA)
    cv2.putText(card, f"Vegetation candidates: {candidate_count}", (472, 30),
                cv2.FONT_HERSHEY_SIMPLEX, 0.62, (35, 65, 48), 2, cv2.LINE_AA)
    cards.append(card)

if not rows:
    raise SystemExit("No sample images could be processed.")

gallery = np.full((len(cards) * 300, 920, 3), 242, dtype=np.uint8)
for i, card in enumerate(cards):
    gallery[i*300:(i+1)*300, :] = card
cv2.imwrite(str(RESULTS / "gallery.jpg"), cv2.cvtColor(gallery, cv2.COLOR_RGB2BGR),
            [cv2.IMWRITE_JPEG_QUALITY, 82, cv2.IMWRITE_JPEG_OPTIMIZE, 1])

with (RESULTS / "processing_summary.csv").open("w", newline="", encoding="utf-8") as handle:
    writer = csv.DictWriter(handle, fieldnames=list(rows[0].keys()))
    writer.writeheader()
    writer.writerows(rows)

print(f"Processed {len(rows)} images. Gallery and CSV written to {RESULTS}.")
