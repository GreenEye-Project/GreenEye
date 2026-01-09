# 📁 Data & AI Documentation

This directory contains all data pipelines, datasets, AI models, and deployment-ready artifacts used in the project.  
It represents the complete workflow starting from data collection and preprocessing, through model training and experimentation, and finally production deployment.

---

# 📊 Data & AI Project Structure

This repository contains all data processing pipelines, machine learning models,
deployment-ready artifacts, and datasets used in the project.

---

## 📁 Project Tree

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
│   └── plant disease model.ipynb
│
├── Needed Files for Deploy/
│   ├── Crop Recommendations/
│   │   ├── crop_pipeline.pkl
│   │   └── label_encoder.pkl
│   │
│   ├── Desertification Risk Classification/
│   │   ├── feature_names.pkl
│   │   ├── label_encoder.pkl
│   │   └── xgb_desertification_pipeline.pkl
│   │
│   ├── Desertification Risk Forecasting/
│   │   ├── feature_names.pkl
│   │   ├── label_encoder.pkl
│   │   ├── xgb_desertification_pipeline.pkl
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

---

## 📁 Historical Data
Contains scripts and references responsible for **data extraction and preprocessing**.

- **main_pipeline.py**  
  Main pipeline for collecting geospatial, environmental, and soil data from external sources (e.g., APIs, GEE).

- **preprocessing_historical.py**  
  Handles data cleaning, normalization, feature engineering, and unit standardization.

- **HistoricalUnits.pdf**  
  Reference document describing scientific units and measurement standards.

This folder represents the **data acquisition layer** of the project.

---

## 📁 Models
Includes Jupyter notebooks used for **model development, experimentation, and evaluation**.

These notebooks cover:
- Desertification risk classification
- Desertification forecasting
- Crop recommendation
- Plant disease detection
- Data merging and integration workflows

Files in this folder are research-oriented; finalized models are exported for deployment.

---

## 📁 Needed Files for Deploy
Contains **production-ready artifacts** required to deploy the trained models without retraining.

### 🌾 Crop Recommendations
- `crop_pipeline.pkl` – Trained ML pipeline  
- `label_encoder.pkl` – Crop label encoder  

### 🌍 Desertification Risk Classification
- `xgb_desertification_pipeline.pkl` – XGBoost classification pipeline  
- `label_encoder.pkl` – Class labels  
- `feature_names.pkl` – Ordered feature list  

### 📈 Desertification Risk Forecasting
- Forecasting models for multiple environmental variables:
  - NDVI
  - Relative humidity
  - Solar radiation
  - Temperature
  - Dew point
  - Precipitation
- Includes feature mappings and encoders required for inference.

### 🌿 Plant Disease Detection
- `model2.keras` – Deep learning model for image-based plant disease detection.

This folder is the **only dependency required for production inference**.

---

## 📁 Used Data
Contains cleaned and processed datasets used for training and validation.

- **Crop_recommendation.csv**  
  Dataset used to train and evaluate the crop recommendation model.

- **des_df.csv**  
  Intermediate desertification dataset with a very large number of samples (>100,000), collected from a limited number of governorates.

- **historical_data_SCIENTIFIC_NPK_FINAL_UNIFIED.csv**  
  Dataset containing soil and environmental samples from more than 20 governorates, providing wide geographic coverage.

- **final_df.csv**  
  Unified dataset produced by merging `des_df.csv` with `historical_data_SCIENTIFIC_NPK_FINAL_UNIFIED.csv` to improve both sample density and geographic diversity.

- **desertification_labeled.csv**  
  Labeled version of the merged dataset, used directly for desertification classification and forecasting models.

This merging strategy reduces geographic bias and improves nationwide model generalization.

---

## 📄 _About Data & Deployment.docx
A high-level summary document describing:
- The AI models included in the project
- Each model’s purpose and data source
- Deployment availability and endpoints

---

## ✅ Notes
- Data extraction logic is isolated in `Historical Data`.
- Model training and experimentation occur in `Models`.
- Deployment relies exclusively on `Needed Files for Deploy`.
- Dataset merging ensures balanced regional representation.

📌 *This structure ensures clarity, reproducibility, and a smooth transition from research to production.*
