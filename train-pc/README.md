# train-pc — датасеты для обучения

**Перед push с Mac:** нужно ~6 GB свободного места (git копирует картинки в `.git/objects`).

```bash
cd "/Users/mihailsklarenko/FSM_PANEL v.3.0.1/train-pc"
chmod +x push_to_github.sh
./push_to_github.sh
```

Два папки для Train PC (`R.I.P.-Panel`):

```
vendor/csgobot/yolov8/datasets/product_v1_bootstrap   (5473 images)
vendor/csgobot/yolov8/datasets/sources/hard_negatives   (1670 images)
```

## Клонировать на Train PC

```bat
cd /d C:\Users\FermK\Downloads
git clone https://github.com/Mikhail-Sklyarenko/train-pc.git train-pc-datasets
```

Скопировать содержимое в существующую панель:

```bat
xcopy /E /I /Y train-pc-datasets\vendor\csgobot\yolov8\datasets\product_v1_bootstrap R.I.P.-Panel\vendor\csgobot\yolov8\datasets\product_v1_bootstrap
xcopy /E /I /Y train-pc-datasets\vendor\csgobot\yolov8\datasets\sources\hard_negatives R.I.P.-Panel\vendor\csgobot\yolov8\datasets\sources\hard_negatives
```

Или клонировать прямо как `R.I.P.-Panel` если панель ещё не установлена.

## После копирования

```bat
BuildProductWithHardNegatives.bat
TrainProductModel.bat --data vendor\csgobot\yolov8\datasets\product_data_hn.yaml --name product_golden_v1
```

Убедиться что `sources\our_cs2\train\images` пустой.
