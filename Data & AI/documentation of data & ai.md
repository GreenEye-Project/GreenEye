# 📁 Data & AI Project Documentation

This repository contains all **data pipelines, datasets, AI models, and deployment-ready artifacts**.  
It represents the full workflow from **data collection → preprocessing → model training → deployment**.

---

## 📌 Table of Contents

- [Project Overview](#project-overview)
- [Project Tree](#project-tree)
- [Historical Data](#historical-data)
- [Models](#models)
- [Needed Files for Deployment](#needed-files-for-deployment)
  - [Crop Recommendations](#crop-recommendations)
  - [Desertification Risk Classification](#desertification-risk-classification)
  - [Desertification Risk Forecasting](#desertification-risk-forecasting)
  - [Plant Disease Detection](#plant-disease-detection)
- [Used Data](#used-data)
- [Models & Deployment Overview](#models--deployment-overview)
  - [Desertification Classification & Forecasting](#desertification-classification--forecasting)
  - [Crop Recommendation](#crop-recommendation)
  - [Plant Disease Detection](#plant-disease-detection-1)
- [Notes](#notes)

---

## Project Overview

| Folder | Description |
|--------|-------------|
| `Historical Data/` | Scripts and references for **data extraction and preprocessing** |
| `Models/` | Jupyter notebooks for **model development, experimentation, and evaluation** |
| `Needed Files for Deploy/` | **Production-ready artifacts** for deployment without retraining |
| `Used Data/` | Cleaned and merged datasets for **training and validation** |
| `_About Data & Deployment.docx` | Documentation of data sources and deployment procedures |

---

## Project Tree

```text
Data & AI/
│
├── Historical Data/
│   ├── main_pipeline.py
│   ├── preprocessing_historical.py
│   └── HistoricalUnits.pdf
│
├── Models/
│   ├── Desertification_Forecasting.ipynb
│   ├── Forecasting_all.ipynb
│   ├── classificationUNCCD_all.ipynb
│   ├── classification_models_all.ipynb
│   ├── crop_rec.ipynb
│   ├── datamerge.ipynb
│   └── plant_disease_model.ipynb
│
├── Needed Files for Deploy/
│   ├── Crop Recommendations/
│   │   ├── crop_pipeline.pkl
│   │   └── label_encoder.pkl
│   │
│   ├── Desertification Risk Classification/
│   │   ├── xgb_desertification_pipeline.pkl
│   │   ├── label_encoder.pkl
│   │   └── feature_names.pkl
│   │
│   ├── Desertification Risk Forecasting/
│   │   ├── xgb_desertification_pipeline.pkl
│   │   ├── label_encoder.pkl
│   │   ├── feature_names.pkl
│   │   ├── xgb_forecast_ndvi.pkl
│   │   ├── xgb_forecast_rh_pct.pkl
│   │   ├── xgb_forecast_ssrd_jm2.pkl
│   │   ├── xgb_forecast_t2m_c.pkl
│   │   ├── xgb_forecast_td2m_c.pkl
│   │   └── xgb_forecast_tp_m.pkl
│   │
│   └── Plant Disease Detection/
│       └── model2.keras
│
├── Used Data/
│   ├── Crop_recommendation.csv
│   ├── des_df.csv
│   ├── historical_data_SCIENTIFIC_NPK_FINAL_UNIFIED.csv
│   ├── final_df.csv
│   └── desertification_labeled.csv
│
└── _About Data & Deployment.docx
```
---

## 📁 Historical Data

**Data acquisition layer:** collects and preprocesses raw data.

| File | Description |
|------|------------|
| `main_pipeline.py` | Collects geospatial, environmental, and soil data from APIs & GEE |
| `preprocessing_historical.py` | Cleans, normalizes, and performs feature engineering |
| `HistoricalUnits.pdf` | Reference for scientific units and measurement standards |

---

## 📁 Models

**Research & experimentation layer:**

- Desertification risk classification  
- Desertification forecasting  
- Crop recommendation  
- Plant disease detection  
- Data merging & integration workflows  

> Finalized models are exported to `Needed Files for Deploy` for production use.

---

## 📁 Needed Files for Deployment

**Production-ready artifacts required to run inference without retraining.**

### 🌾 Crop Recommendations

| File | Description |
|------|------------|
| `crop_pipeline.pkl` | Trained ML pipeline |
| `label_encoder.pkl` | Crop label encoder |

### 🌍 Desertification Risk Classification

| File | Description |
|------|------------|
| `xgb_desertification_pipeline.pkl` | XGBoost classification pipeline |
| `label_encoder.pkl` | Class labels |
| `feature_names.pkl` | Ordered feature list |

### 📈 Desertification Risk Forecasting

| File | Description |
|------|------------|
| Forecasting models for NDVI, RH, SSRD, T2M, TD2M, TP | Feature mappings + trained XGBoost pipelines |

### 🌿 Plant Disease Detection

| File | Description |
|------|------------|
| `model2.keras` | Deep learning model for image-based plant disease detection |

> **Note:** This is the **only folder required for production inference**.

---

## 📁 Used Data

| Dataset | Description | Source |
|---------|------------|--------|
| `Crop_recommendation.csv` | Used to train crop recommendation model | Kaggle |
| `des_df.csv` | Intermediate desertification dataset (>100,000 samples) | Local collection |
| `historical_data_SCIENTIFIC_NPK_FINAL_UNIFIED.csv` | Soil & environmental samples (>20 governorates) | Local collection |
| `final_df.csv` | Merged dataset of `des_df.csv` + `historical_data_SCIENTIFIC_NPK_FINAL_UNIFIED.csv` | Local |
| `desertification_labeled.csv` | Labeled dataset for classification & forecasting | Local |

> Merging reduces geographic bias and improves nationwide model generalization.

---

## Models & Deployment Overview

### Desertification Classification & Forecasting

- **Tasks:** Risk classification & multi-variable forecasting  
- **Data Sources:** Google Earth Engine (GEE), SoilGrids  
- **Deployments:**  
  - 🔗 [Classification API](https://mariamyasser-desertification-level-api.hf.space/)  
  - 🔗 [Forecasting API](https://mariamyasser-desertification-forecasting-api.hf.space/)

### Crop Recommendation

- **Dataset:** 🔗 [Kaggle Crop Recommendation Dataset](https://www.kaggle.com/datasets/atharvaingle/crop-recommendation-dataset/data)  
- **Deployment:** 🔗 [API](https://mariamyasser-crop-recommendation-api.hf.space/)

### Plant Disease Detection

- **Dataset:** 🔗 [Kaggle Plant Disease Classification – Merged Dataset](https://www.kaggle.com/datasets/alinedobrovsky/plant-disease-classification-merged-dataset/data)  
- **Deployment:** 🔗 [API](https://mariamyasser-plant-disease-api2.hf.space/)

---

## ✅ Notes

- `Historical Data` → Data extraction  
- `Models` → Training & experimentation  
- `Needed Files for Deploy` → Production inference  
- Dataset merging → Balanced regional representation  

> 📌 This structure ensures **clarity, reproducibility, and smooth transition from research to production**.
