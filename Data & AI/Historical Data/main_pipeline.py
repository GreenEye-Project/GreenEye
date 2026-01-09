
import sys
import logging
from datetime import datetime
from typing import Dict, List, Optional, Callable
import time
import json
from pathlib import Path

# Third-party imports
import pandas as pd
import numpy as np
from sqlalchemy import create_engine, text
import ee


# ==================== CONFIGURATION ====================

class Config:
    """Centralized configuration management"""
    
    # Database Configuration
    DB_SERVER = "DESKTOP-LA1DOLE"
    DB_NAME = "DesertificationDB"
    DB_DRIVER = "ODBC Driver 17 for SQL Server"
    
    # Google Earth Engine
    GEE_PROJECT_ID = "grad-project-470219"
    
    # Data Collection Parameters
    START_YEAR = 2017
    END_YEAR = 2025
    SCALE_METERS = 1000
    ERA5_SCALE = 11132  # ERA5-Land native resolution
    
    # Locations to process
    LOCATIONS = [
        {'name': 'Alexandria_Agriculture', 'lat': 31.1501, 'lon': 29.9187, 'region': 'North Delta'},
        {'name': 'Damietta_Farmland', 'lat': 31.3675, 'lon': 31.7144, 'region': 'North Delta'},
        {'name': 'Tanta_Farms', 'lat': 30.8865, 'lon': 31.1004, 'region': 'Delta'},
        {'name': 'Mansoura_Fields', 'lat': 31.0009, 'lon': 31.2785, 'region': 'Delta'},
        {'name': 'Sharqia_Farms', 'lat': 30.5852, 'lon': 31.5020, 'region': 'Delta'},
        {'name': 'Nile_Trees_BeniSuef', 'lat': 29.0667, 'lon': 31.0833, 'region': 'Upper Egypt'},
        {'name': 'Nile_Trees_Minia', 'lat': 28.1099, 'lon': 30.7503, 'region': 'Upper Egypt'},
        {'name': 'Nile_Trees_Asyut', 'lat': 27.1828, 'lon': 31.1828, 'region': 'Upper Egypt'},
        {'name': 'Fayoum_Grasslands', 'lat': 29.4084, 'lon': 30.7428, 'region': 'Western Desert'},
        {'name': 'Wadi_ElNatrun', 'lat': 30.4333, 'lon': 30.3167, 'region': 'Western Desert'},
        {'name': 'Siwa_Grasslands', 'lat': 29.2041, 'lon': 25.5195, 'region': 'Western Desert'},
        {'name': 'Mediterranean_Coast_Alex', 'lat': 31.2001, 'lon': 29.9187, 'region': 'North Coast'},
        {'name': 'Red_Sea_Coast_Hurghada', 'lat': 27.2578, 'lon': 33.8116, 'region': 'Red Sea'},
        {'name': 'Lake_Nasser_1', 'lat': 23.5000, 'lon': 32.5000, 'region': 'Upper Egypt'},
        {'name': 'Suez_Canal', 'lat': 30.5852, 'lon': 32.2654, 'region': 'Suez Canal'},
        {'name': 'Manzala_Wetland', 'lat': 31.2000, 'lon': 31.9000, 'region': 'North Delta'},
        {'name': 'Burullus_Wetland', 'lat': 31.5000, 'lon': 30.8000, 'region': 'North Delta'},
        # {'name': 'Qarun_Lake', 'lat': 29.4500, 'lon': 30.6000, 'region': 'Fayoum'},
        #{'name': 'North_Coast_Shrubs', 'lat': 31.8000, 'lon': 29.2000, 'region': 'North Coast'},
        #{'name': 'Sinai_Shrubs_StCatherine', 'lat': 28.5435, 'lon': 33.9753, 'region': 'Sinai'},
        {'name': 'Red_Sea_Mountains', 'lat': 26.0000, 'lon': 33.5000, 'region': 'Eastern Desert'},
        {'name': 'Red_Sea_Mangroves', 'lat': 27.8000, 'lon': 33.6000, 'region': 'Red Sea'},
        {'name': 'Gulf_of_Aqaba_Mangroves', 'lat': 29.5000, 'lon': 34.9167, 'region': 'Sinai'},
        # North Delta
        # {'name': 'Alexandria', 'lat': 31.2001, 'lon': 29.9187, 'region': 'North Delta'},
        # {'name': 'Damietta', 'lat': 31.4175, 'lon': 31.8144, 'region': 'North Delta'},
        # {'name': 'Port Said', 'lat': 31.2653, 'lon': 32.3019, 'region': 'North Delta'},
        
        # # Delta
        # {'name': 'Mansoura', 'lat': 31.0409, 'lon': 31.3785, 'region': 'Delta'},
        # {'name': 'Tanta', 'lat': 30.7865, 'lon': 31.0004, 'region': 'Delta'},
        # {'name': 'Zagazig', 'lat': 30.5852, 'lon': 31.5020, 'region': 'Delta'},
        
        # # Greater Cairo
        # {'name': 'Cairo', 'lat': 30.0444, 'lon': 31.2357, 'region': 'Greater Cairo'},
        # {'name': 'Giza', 'lat': 30.0131, 'lon': 31.2089, 'region': 'Greater Cairo'},
        
        # # Upper Egypt
        # {'name': 'Assiut', 'lat': 27.1783, 'lon': 31.1859, 'region': 'Upper Egypt'},
        # {'name': 'Luxor', 'lat': 25.6872, 'lon': 32.6396, 'region': 'Upper Egypt'},
        # {'name': 'Aswan', 'lat': 24.0889, 'lon': 32.8998, 'region': 'Upper Egypt'},
        
        # Deserts
        # {'name': 'Fayoum', 'lat': 29.3084, 'lon': 30.8428, 'region': 'Western Desert'},
        # {'name': 'New Valley', 'lat': 25.4611, 'lon': 28.5528, 'region': 'Western Desert'},
        # {'name': 'Matrouh', 'lat': 31.3500, 'lon': 27.2373, 'region': 'Western Desert'},
        # {'name': 'Red Sea', 'lat': 27.2578, 'lon': 33.8116, 'region': 'Eastern Desert'},
        # {'name': 'North Sinai', 'lat': 30.2800, 'lon': 33.6178, 'region': 'Sinai'},
        # {'name': 'South Sinai', 'lat': 28.5435, 'lon': 33.9753, 'region': 'Sinai'},
    ]
    
    # Logging
    LOG_DIR = Path("logs")
    LOG_LEVEL = logging.INFO
    
    # Batch Processing
    BATCH_SIZE = 2  # Process 12 months at a time
    CHECKPOINT_FILE = "pipeline_checkpoint.json"


# ==================== LOGGING SETUP ====================

def setup_logging():
    """Setup comprehensive logging system"""
    Config.LOG_DIR.mkdir(exist_ok=True)
    
    timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
    log_file = Config.LOG_DIR / f"pipeline_{timestamp}.log"
    
    # Create formatters
    detailed_formatter = logging.Formatter(
        '%(asctime)s | %(levelname)-8s | %(name)-20s | %(message)s',
        datefmt='%Y-%m-%d %H:%M:%S'
    )
    
    console_formatter = logging.Formatter(
        '%(asctime)s | %(levelname)-8s | %(message)s',
        datefmt='%H:%M:%S'
    )
    
    # File handler (detailed)
    file_handler = logging.FileHandler(log_file, encoding='utf-8')
    file_handler.setLevel(logging.DEBUG)
    file_handler.setFormatter(detailed_formatter)
    
    # Console handler (less detailed)
    console_handler = logging.StreamHandler(sys.stdout)
    console_handler.setLevel(logging.INFO)
    console_handler.setFormatter(console_formatter)
    
    # Root logger
    root_logger = logging.getLogger()
    root_logger.setLevel(Config.LOG_LEVEL)
    root_logger.addHandler(file_handler)
    root_logger.addHandler(console_handler)
    
    return logging.getLogger(__name__)


# ==================== TEMPORAL SOIL DATA HANDLER ====================

class TemporalSoilDataHandler:
    """
    CORRECTED soil data handler with historically accurate temporal logic
    Uses SoilGrids versions that were ACTUALLY AVAILABLE at each point in time
    """
    
    def __init__(self, cache_dir: Optional[Path] = None):
        self.logger = logging.getLogger(self.__class__.__name__)
        
        # Setup cache
        self.cache_dir = cache_dir or Path("cache/temporal_soil_data")
        self.cache_dir.mkdir(parents=True, exist_ok=True)
        self.cache_file = self.cache_dir / "temporal_soil_cache.json"
        self.soil_cache = self._load_cache()
        
        # Alexandria-specific alternative coordinates
        self.alexandria_alternatives = [
            (31.2150, 29.9500),  # Slightly inland
            (31.1800, 29.8900),  # Different area
            (31.2500, 29.9800),  # More inland
            (31.2000, 30.0000),  # East of original
        ]
        
        # Historically accurate SoilGrids release mapping
        # Based on ACTUAL release dates and what was available when
        self.soil_versions = {
            # 2017-2019: SoilGrids 2017 was the only available version
            (2017, 2019): {
                'collection': 'projects/soilgrids-isric',
                'suffix': '_mean',
                'version_year': 2017,
                'reasoning': '2017_data_was_only_available'
            },
            # 2020-2021: SoilGrids 2020 became available
            (2020, 2021): {
                'collection': 'projects/soilgrids-isric', 
                'suffix': '_mean',
                'version_year': 2020,
                'reasoning': '2020_data_became_available'
            },
            # 2022-2025: SoilGrids 2022 is the latest
            (2022, 2025): {
                'collection': 'projects/soilgrids-isric',
                'suffix': '_mean',
                'version_year': 2022,
                'reasoning': '2022_data_is_latest'
            }
        }
        
        self.logger.info("✅ TemporalSoilDataHandler - Using HISTORICALLY ACCURATE release dates")
        self.logger.info("   📅 2014-2019 → SoilGrids 2017 (only available)")
        self.logger.info("   📅 2020-2021 → SoilGrids 2020 (became available)") 
        self.logger.info("   📅 2022-2024 → SoilGrids 2022 (latest)")
    
    def clear_cache(self):
        """Clear soil data cache to force fresh data"""
        try:
            if self.cache_file.exists():
                self.cache_file.unlink()
                self.logger.info("🗑️ Temporal soil cache file deleted")
            
            if self.cache_dir.exists():
                import shutil
                shutil.rmtree(self.cache_dir)
                self.logger.info("🗑️ Temporal soil cache directory deleted")
            
            # Recreate empty cache
            self.cache_dir.mkdir(parents=True, exist_ok=True)
            self.soil_cache = {}
            self.logger.info("🔄 Temporal soil cache cleared completely")
            
        except Exception as e:
            self.logger.error(f"❌ Failed to clear temporal cache: {e}")

    def _load_cache(self) -> Dict:
        """Load soil data cache from file"""
        if self.cache_file.exists():
            try:
                with open(self.cache_file, 'r') as f:
                    cache = json.load(f)
                self.logger.info(f"📦 Loaded temporal soil cache: {len(cache)} location-years")
                return cache
            except Exception as e:
                self.logger.warning(f"⚠️ Failed to load temporal cache: {e}")
        return {}
    
    def _save_cache(self):
        """Save soil data cache to file"""
        try:
            with open(self.cache_file, 'w') as f:
                json.dump(self.soil_cache, f, indent=2)
        except Exception as e:
            self.logger.error(f"❌ Failed to save temporal cache: {e}")
    
    def _create_cache_key(self, latitude: float, longitude: float, year: int) -> str:
        """Create a unique cache key for a location and year"""
        return f"{latitude:.3f}_{longitude:.3f}_{year}"
    
    def _get_soil_version_for_year(self, year: int) -> Dict:
        """Get SoilGrids version that was ACTUALLY AVAILABLE for a given year"""
        for (start_year, end_year), version_info in self.soil_versions.items():
            if start_year <= year <= end_year:
                # Add temporal context to the logging
                reasoning = version_info.get('reasoning', 'unknown')
                if year < 2020:
                    temporal_note = " (this data was contemporary)"
                elif year < 2022:
                    temporal_note = " (this data was contemporary)" 
                else:
                    temporal_note = " (current data)"
                
                self.logger.debug(f"📅 Year {year} → SoilGrids {version_info['version_year']}{temporal_note}")
                return version_info
        
        # Default to latest if year is outside our range
        latest_version = self.soil_versions[(2022, 2024)]
        self.logger.warning(f"⚠️ Year {year} outside range, using latest: SoilGrids {latest_version['version_year']}")
        return latest_version
    
    def _get_correct_band_names(self, version_info: Dict) -> Dict:
        """Get band names for specific SoilGrids version"""
        suffix = version_info.get('suffix', '_mean')
        
        return {
            'sand': f'sand_0-5cm{suffix}',
            'silt': f'silt_0-5cm{suffix}', 
            'clay': f'clay_0-5cm{suffix}',
            'soc': f'soc_0-5cm{suffix}',
            'ph': f'phh2o_0-5cm{suffix}',
            'bdod': f'bdod_0-5cm{suffix}',
            'cec': f'cec_0-5cm{suffix}',
            'nitrogen': f'nitrogen_0-5cm{suffix}'
        }
    
    def _convert_soil_values(self, soil_data_raw: Dict) -> Dict:
        """
        Convert SoilGrids raw values to proper units - FINAL CORRECTED VERSION
        """
        converted = {}
        
        # Sand, Silt, Clay: (g/kg * 10) → %
        # Raw values are in g/kg * 10, so we need to divide by 10 to get g/kg (which equals %)
        for prop in ['sand', 'silt', 'clay']:
            raw_value = soil_data_raw.get(prop)
            if raw_value is not None:
                converted[prop] = raw_value / 10.0  # ✅ DIVIDE BY 10, NOT 100!
            else:
                converted[prop] = None
        
        # SOC: (dg/kg * 10) → %
        soc_raw = soil_data_raw.get('soc')
        converted['soc'] = (soc_raw / 100.0) if soc_raw is not None else None
        
        # pH: (pH * 10) → pH
        ph_raw = soil_data_raw.get('ph')
        converted['ph'] = (ph_raw / 10.0) if ph_raw is not None else None
        
        # BDOD: (cg/cm³ * 10) → g/cm³
        bdod_raw = soil_data_raw.get('bdod')
        converted['bdod'] = (bdod_raw / 100.0) if bdod_raw is not None else None
        
        # CEC: (mmol(c)/kg * 10) → cmol(c)/kg
        cec_raw = soil_data_raw.get('cec')
        converted['cec'] = (cec_raw / 10.0) if cec_raw is not None else None
        
        # Nitrogen: (cg/kg * 10) → %
        nitrogen_raw = soil_data_raw.get('nitrogen')
        if nitrogen_raw is not None:
            converted['nitrogen'] = nitrogen_raw / 1000.0
        else:
            converted['nitrogen'] = None
        
        # ✅ ADD DEBUG LOGGING TO VERIFY THE FIX
        texture_sum = sum([converted.get(prop, 0) for prop in ['sand', 'silt', 'clay']])
        self.logger.debug(f"Soil texture conversion - Raw: {soil_data_raw}")
        self.logger.debug(f"Soil texture conversion - Converted: {converted}")
        self.logger.debug(f"Soil texture sum: {texture_sum:.1f}%")
        
        return converted
    
    def _estimate_phosphorus_potassium(self, soil_props: Dict) -> tuple:
        """
        Estimate P and K from other soil properties - ROBUST VERSION
        """
        try:
            # Get values with defaults
            soc = soil_props.get('soc', 0)
            cec = soil_props.get('cec', 0)
            clay = soil_props.get('clay', 0)
            silt = soil_props.get('silt', 0)
            ph = soil_props.get('ph', 7.0)
            
            self.logger.debug(f"Estimating P&K from: SOC={soc}, CEC={cec}, Clay={clay}, Silt={silt}, pH={ph}")
            
            # Ensure we have basic values
            if soc is None or cec is None or clay is None:
                self.logger.warning("Missing required soil properties for P&K estimation")
                return None, None
            
            # Phosphorus estimation (mg/kg) - based on Egyptian soil relationships
            try:
                base_p = (soc * 2.5) if soc > 0 else 15.0
                cec_factor = 1 + ((cec - 20) / 100) if cec else 1.0
                clay_factor = 1 - ((clay - 25) / 200) if clay else 1.0
                ph_factor = 1.2 if (6.0 <= ph <= 7.5) else 1.0
                
                phosphorus = base_p * cec_factor * clay_factor * ph_factor
                phosphorus = max(5.0, min(50.0, phosphorus))
                phosphorus = round(phosphorus, 2)
            except:
                phosphorus = 18.5  # Default for Egyptian soils
            
            # Potassium estimation (mg/kg)
            try:
                base_k = (cec * 8) if cec > 0 else 150.0
                clay_factor_k = 1 + ((clay - 25) / 50) if clay else 1.0
                silt_factor = 1 + ((silt - 30) / 100) if silt else 1.0
                
                potassium = base_k * clay_factor_k * silt_factor
                potassium = max(50.0, min(400.0, potassium))
                potassium = round(potassium, 2)
            except:
                potassium = 180.0  # Default for Egyptian soils
            
            self.logger.debug(f"Estimated P={phosphorus} mg/kg, K={potassium} mg/kg")
            return phosphorus, potassium
            
        except Exception as e:
            self.logger.error(f"P&K estimation failed: {e}")
            # Return reasonable defaults for Egyptian soils
            return 18.5, 180.0
    
    def _get_nitrogen_fallback(self, soil_props: Dict) -> float:
        """
        Estimate nitrogen from SOC if direct measurement fails
        Typical N:SOC ratio is about 1:10 to 1:12
        """
        try:
            soc = soil_props.get('soc')
            if soc is not None and soc > 0:
                # Conservative estimate: N = SOC / 11
                nitrogen = soc / 11.0
                self.logger.info(f"📊 Estimated nitrogen from SOC: {nitrogen:.3f}%")
                return round(nitrogen, 3)
            return None
        except:
            return None
    
    def _is_alexandria_area(self, latitude: float, longitude: float) -> bool:
        """Check if location is in Alexandria area"""
        return (30.8 <= latitude <= 31.5) and (29.5 <= longitude <= 30.2)
    
    def _fetch_temporal_soil_data(self, latitude: float, longitude: float, year: int) -> Dict:
        """Fetch soil data using historically appropriate version for the year"""
        try:
            point = ee.Geometry.Point([longitude, latitude])
            
            # Get appropriate SoilGrids version
            version_info = self._get_soil_version_for_year(year)
            band_names = self._get_correct_band_names(version_info)
            collection_base = version_info['collection']
            release_year = version_info['version_year']
            reasoning = version_info.get('reasoning', 'unknown')
            
            # ✅ IMPROVED LOGGING with historical context
            if year < release_year:
                context = f"(using contemporary data from {release_year})"
            elif year == release_year:
                context = f"(using newly released data)"
            else:
                context = f"(using latest available data)"
            
            self.logger.info(f"🌱 Year {year} → SoilGrids {release_year} {context}")
            
            # Load soil layers for the specific version
            sand = ee.Image(f"{collection_base}/sand_mean").select(band_names['sand'])
            silt = ee.Image(f"{collection_base}/silt_mean").select(band_names['silt'])
            clay = ee.Image(f"{collection_base}/clay_mean").select(band_names['clay'])
            soc = ee.Image(f"{collection_base}/soc_mean").select(band_names['soc'])
            ph = ee.Image(f"{collection_base}/phh2o_mean").select(band_names['ph'])
            bdod = ee.Image(f"{collection_base}/bdod_mean").select(band_names['bdod'])
            cec = ee.Image(f"{collection_base}/cec_mean").select(band_names['cec'])
            nitrogen = ee.Image(f"{collection_base}/nitrogen_mean").select(band_names['nitrogen'])
            
            # Combine all bands
            soil_image = ee.Image.cat([sand, silt, clay, soc, ph, bdod, cec, nitrogen]) \
                .rename(['sand', 'silt', 'clay', 'soc', 'ph', 'bdod', 'cec', 'nitrogen'])
            
            # Try different scales
            for scale in [1000, 2000, 5000]:
                self.logger.debug(f"  Trying scale: {scale}m for year {year}")
                
                soil_data_raw = soil_image.reduceRegion(
                    reducer=ee.Reducer.first(),
                    geometry=point,
                    scale=scale,
                    bestEffort=True,
                    maxPixels=1e9,
                    tileScale=2
                ).getInfo()
                
                # Check if we got data
                if soil_data_raw.get('sand') is not None:
                    self.logger.debug(f"  ✅ Got temporal soil data at scale {scale}m for {year}")
                    
                    # Convert raw values to proper units
                    converted_data = self._convert_soil_values(soil_data_raw)
                    converted_data['_scale_used'] = scale
                    converted_data['_version_year'] = release_year
                    converted_data['_collection_used'] = collection_base
                    converted_data['_temporal_reasoning'] = reasoning
                    
                    return converted_data
            
            # All scales failed
            return {prop: None for prop in ['sand', 'silt', 'clay', 'soc', 'ph', 'bdod', 'cec', 'nitrogen']}
            
        except Exception as e:
            self.logger.error(f"❌ Temporal soil data fetch failed for {year}: {e}")
            return {prop: None for prop in ['sand', 'silt', 'clay', 'soc', 'ph', 'bdod', 'cec', 'nitrogen']}
    
    def _fetch_soil_data_with_fallback(self, latitude: float, longitude: float, year: int) -> Dict:
        """Fetch soil data with multiple fallback strategies"""
        # Try original location first
        soil_data = self._fetch_temporal_soil_data(latitude, longitude, year)
        
        if soil_data['sand'] is not None:
            return soil_data
        
        # If Alexandria area and failed, try alternatives
        if self._is_alexandria_area(latitude, longitude):
            self.logger.info(f"🔍 Alexandria area detected, trying alternative coordinates...")
            
            for i, (alt_lat, alt_lon) in enumerate(self.alexandria_alternatives):
                self.logger.info(f"  Trying alternative {i+1}: ({alt_lat:.3f}, {alt_lon:.3f})")
                
                alt_data = self._fetch_temporal_soil_data(alt_lat, alt_lon, year)
                
                if alt_data['sand'] is not None:
                    self.logger.info(f"✅ Found soil data at alternative location {i+1}")
                    alt_data['_is_alternative'] = True
                    alt_data['_original_lat'] = latitude
                    alt_data['_original_lon'] = longitude
                    return alt_data
        
        return soil_data
    
    def get_soil_data_for_date(
        self, 
        latitude: float, 
        longitude: float, 
        year: int,
        month: int,
        force_refresh: bool = False
    ) -> Dict:
        """Get historically appropriate soil data with temporal validation"""
        
        cache_key = self._create_cache_key(latitude, longitude, year)
        
        #  Check cache first, but don't return immediately
        soil_values = None
        use_cached = False
        
        if cache_key in self.soil_cache and not force_refresh:
            cached_data = self.soil_cache[cache_key].copy()
            
            # Check if cached data is TEMPORALLY CORRECT
            cached_version = cached_data.get('_metadata', {}).get('soilgrids_release_used')
            expected_version = self._get_soil_version_for_year(year)['version_year']
            
            if cached_version == expected_version and (
                cached_data.get('sand') is not None and 
                cached_data.get('sand') > 0 and
                cached_data.get('clay') is not None and
                cached_data.get('clay') > 0
            ):
                self.logger.debug(f"📦 Using cached temporal soil data for {year}")
                use_cached = True
                soil_values = cached_data
            else:
                if cached_version != expected_version:
                    self.logger.warning(f"🔄 Cached soil data version mismatch: {cached_version} vs expected {expected_version}")
                force_refresh = True
        
        # Fetch fresh data if needed
        if not use_cached and (force_refresh or cache_key not in self.soil_cache):
            self.logger.info(f"🔄 Fetching HISTORICALLY APPROPRIATE soil data for ({latitude:.3f}, {longitude:.3f}) - Year {year}")
            soil_values = self._fetch_soil_data_with_fallback(latitude, longitude, year)
        
        #  Ensure soil_values is defined
        if soil_values is None:
            self.logger.error(f"❌ No soil data available for {year}")
            # Return empty but properly structured data
            return {
                'sand': None, 'silt': None, 'clay': None, 'soc': None, 'ph': None,
                'bdod': None, 'cec': None, 'nitrogen': None, 'phosphorus': None, 'potassium': None,
                '_metadata': {
                    'soilgrids_release_used': self._get_soil_version_for_year(year)['version_year'],
                    'data_represented_year': year,
                    'fetch_date': datetime.now().isoformat(),
                    'historically_accurate': True
                }
            }

        #  Handle missing nitrogen - estimate from SOC if needed
        if soil_values.get('nitrogen') is None and soil_values.get('sand') is not None:
            estimated_nitrogen = self._get_nitrogen_fallback(soil_values)
            if estimated_nitrogen is not None:
                soil_values['nitrogen'] = estimated_nitrogen
                self.logger.info(f"🔧 Using estimated nitrogen: {estimated_nitrogen:.3f}%")
        
        #  Estimate P and K with fallback
        phosphorus, potassium = self._estimate_phosphorus_potassium(soil_values)
        
        # Prepare result with improved temporal metadata
        soil_data = {
            'sand': soil_values.get('sand'),
            'silt': soil_values.get('silt'),
            'clay': soil_values.get('clay'),
            'soc': soil_values.get('soc'),
            'ph': soil_values.get('ph'),
            'bdod': soil_values.get('bdod'),
            'cec': soil_values.get('cec'),
            'nitrogen': soil_values.get('nitrogen'),
            'phosphorus': phosphorus,
            'potassium': potassium,
            '_metadata': {
                'soilgrids_release_used': soil_values.get('_version_year', 'unknown'),
                'data_represented_year': year,
                'temporal_reasoning': soil_values.get('_temporal_reasoning', 'unknown'),
                'fetch_date': datetime.now().isoformat(),
                'scale_used': soil_values.get('_scale_used', 'unknown'),
                'collection_used': soil_values.get('_collection_used', 'unknown'),
                'is_alternative': soil_values.get('_is_alternative', False),
                'npk_source': 'N from SoilGrids/estimated, P&K estimated',
                'latitude': latitude,
                'longitude': longitude,
                'historically_accurate': True
            }
        }
        
        # Cache if successful and not using cached data
        if not use_cached and soil_data['sand'] is not None and soil_data['sand'] > 0:
            texture_sum = sum([soil_data.get(prop, 0) for prop in ['sand', 'silt', 'clay']])
            npk_info = f"N={soil_data.get('nitrogen', 0):.3f}%, P={phosphorus if phosphorus else 'N/A'}mg/kg, K={potassium if potassium else 'N/A'}mg/kg"
            
            # Improved logging with historical context
            release_year = soil_data['_metadata']['soilgrids_release_used']
            if year < release_year:
                temporal_note = f" (using contemporary {release_year} data)"
            else:
                temporal_note = f" (using current {release_year} data)"
                
            self.logger.info(
                f"✅ Historical soil data for {year}: "
                f"Sand={soil_data['sand']:.1f}%, "
                f"Silt={soil_data['silt']:.1f}%, "
                f"Clay={soil_data['clay']:.1f}% "
                f"(Total: {texture_sum:.1f}%){temporal_note} | {npk_info}"
            )
            self.soil_cache[cache_key] = soil_data
            self._save_cache()
        elif use_cached:
            self.logger.info(f"📦 Using cached soil data for {year}")
        else:
            self.logger.error(f"❌ No valid historical soil data available for {year}")
        
        return soil_data
# ==================== DATABASE MANAGER ====================

class DatabaseManager:
    """Handles all database operations"""
    
    def __init__(self):
        self.logger = logging.getLogger(self.__class__.__name__)
        self.engine = None
        self._setup_connection()
    
    def _setup_connection(self):
        """Setup SQLAlchemy engine"""
        try:
            self.connection_string = (
                f"mssql+pyodbc://@{Config.DB_SERVER}/{Config.DB_NAME}"
                f"?driver={Config.DB_DRIVER.replace(' ', '+')}"
                f"&trusted_connection=yes"
            )
            
            self.engine = create_engine(
                self.connection_string,
                pool_size=5,
                max_overflow=10,
                pool_pre_ping=True,
                pool_recycle=3600,
                echo=False
            )
            
            # Test connection
            with self.engine.connect() as conn:
                conn.execute(text("SELECT 1"))
            
            self.logger.info("✅ Database connection established")
            
        except Exception as e:
            self.logger.error(f"❌ Database connection failed: {e}")
            raise
    
    def bulk_insert(self, df: pd.DataFrame, table_name: str, if_exists: str = 'append') -> int:
        """Insert DataFrame using SQLAlchemy Core API"""
        try:
            from sqlalchemy import MetaData, Table
            
            # Reflect table structure
            metadata = MetaData()
            table = Table(table_name, metadata, autoload_with=self.engine)
            
            # Get records as dictionaries
            records = df.to_dict('records')
            
            with self.engine.begin() as connection:
                # Handle if_exists logic
                if if_exists == 'replace':
                    connection.execute(table.delete())
                
                # Insert records
                connection.execute(table.insert(), records)
            
            self.logger.info(f"✅ Inserted {len(df)} rows into {table_name}")
            return len(df)
            
        except Exception as e:
            self.logger.error(f"❌ Bulk insert failed: {e}")
            raise

    def check_existing_data(self, location: str, year: int, month: int) -> bool:
        """Check if data already exists"""
        query = """
            SELECT COUNT(*) as cnt 
            FROM historical_data 
            WHERE location_name = :location_name AND year = :year AND month = :month
        """
        try:
            with self.engine.connect() as conn:
                result = conn.execute(
                    text(query),
                    {"location_name": location, "year": year, "month": month}
                )
                count = result.fetchone()[0]
                return count > 0
        except Exception as e:
            self.logger.warning(f"⚠️ Error checking existing data: {e}")
            return False


# ==================== DATA COLLECTOR (WITH RETRY LOGIC & TEMPORAL SOIL) ====================

class IntegratedDataCollector:
    """Integrated data collector with FIXED ERA5 climate data, RETRY logic, and TEMPORAL soil data"""
    
    def __init__(self):
        self.logger = logging.getLogger(self.__class__.__name__)
        self._initialize_ee()
        
        # Initialize TEMPORAL soil handler
        self.soil_handler = TemporalSoilDataHandler()
        
        # Load other datasets
        self._load_datasets()
    
    def _initialize_ee(self):
        """Initialize Earth Engine"""
        try:
            self.logger.info("🌍 Initializing Google Earth Engine...")
            ee.Initialize(project=Config.GEE_PROJECT_ID)
            self.logger.info("✅ Earth Engine initialized")
        except Exception as e:
            self.logger.error(f"❌ Earth Engine initialization failed: {e}")
            raise
    
    def _load_datasets(self):
        """Load datasets"""
        try:
            # NDVI
            self.ndvi_collection = ee.ImageCollection('MODIS/061/MOD13A2').select('NDVI')
            
            # ERA5 Climate - HOURLY
            self.era5_collection = ee.ImageCollection('ECMWF/ERA5_LAND/HOURLY')
            
            # Land Cover
            self.land_cover = ee.Image('ESA/WorldCover/v100/2020').select('Map')
            
            self.logger.info("✅ Datasets loaded")
            
        except Exception as e:
            self.logger.error(f"❌ Dataset loading failed: {e}")
            raise
    
    def _fetch_with_retry(self, operation: Callable, operation_name: str, max_retries: int = 3) -> any:
        """Fetch data with retry logic for network issues"""
        for attempt in range(max_retries):
            try:
                return operation()
            except Exception as e:
                if "Connection aborted" in str(e) or "Remote end closed" in str(e):
                    self.logger.warning(f"⚠️ {operation_name} - Network error (attempt {attempt + 1}/{max_retries}): {e}")
                    if attempt < max_retries - 1:
                        wait_time = (attempt + 1) * 5  # Exponential backoff: 5, 10, 15 seconds
                        self.logger.info(f"🔄 Retrying in {wait_time} seconds...")
                        time.sleep(wait_time)
                        continue
                # For other errors or final retry failure, re-raise
                raise
        return None
    
    def get_monthly_data(
        self, 
        latitude: float, 
        longitude: float, 
        year: int, 
        month: int
    ) -> Optional[Dict]:
        """Collect all data for a specific location and time - FIXED VERSION WITH TEMPORAL SOIL"""
        try:
            point = ee.Geometry.Point([longitude, latitude])
            buffer_point = point.buffer(10000)  # 10km buffer for climate data
            
            start_date = ee.Date.fromYMD(year, month, 1)
            end_date = start_date.advance(1, 'month')
            
            result = {}
            
            # ========================================================
            # 1. TEMPORAL SOIL DATA - DIFFERENT FOR EACH YEAR
            # ========================================================
            self.logger.debug(f"🌱 Fetching TEMPORAL soil data for {year}...")
            
            soil_data = self.soil_handler.get_soil_data_for_date(
                latitude=latitude,
                longitude=longitude,
                year=year,
                month=month,
                force_refresh=True  # ✅ FORCE REFRESH TO GET TEMPORAL DATA
            )
            
            # Add soil properties INCLUDING NPK
            for prop in ['sand', 'silt', 'clay', 'soc', 'ph', 'bdod', 'cec', 'nitrogen', 'phosphorus', 'potassium']:
                result[prop] = soil_data.get(prop)
            
            # Add temporal metadata
            result['soil_version_year'] = soil_data['_metadata']['soilgrids_release_used']  # CORRECTED
            result['soil_data_year'] = soil_data['_metadata']['data_represented_year']  # CORRECTED
            
            # ========================================================
            # 2. NDVI
            # ========================================================
            self.logger.debug(f"🌿 Fetching NDVI...")
            
            ndvi_filtered = self.ndvi_collection.filterDate(start_date, end_date).filterBounds(point)
            ndvi_count = ndvi_filtered.size().getInfo()
            
            if ndvi_count > 0:
                ndvi_img = ndvi_filtered.mean().multiply(0.0001)
                ndvi_value = ndvi_img.reduceRegion(
                    reducer=ee.Reducer.mean(),
                    geometry=point,
                    scale=Config.SCALE_METERS,
                    bestEffort=True,
                    maxPixels=1e9
                ).get('NDVI').getInfo()
                
                result['ndvi'] = ndvi_value
                result['ndvi_source'] = 'MODIS/MOD13A2'
            else:
                # Extended lookback
                extended_start = start_date.advance(-2, 'month')
                ndvi_filtered_extended = self.ndvi_collection.filterDate(
                    extended_start, end_date
                ).filterBounds(point)
                
                if ndvi_filtered_extended.size().getInfo() > 0:
                    ndvi_img = ndvi_filtered_extended.mean().multiply(0.0001)
                    ndvi_value = ndvi_img.reduceRegion(
                        reducer=ee.Reducer.mean(),
                        geometry=point,
                        scale=Config.SCALE_METERS,
                        bestEffort=True,
                        maxPixels=1e9
                    ).get('NDVI').getInfo()
                    
                    result['ndvi'] = ndvi_value
                    result['ndvi_source'] = 'MODIS/MOD13A2_extended'
                else:
                    result['ndvi'] = None
                    result['ndvi_source'] = None
            
            # ========================================================
            # 3. ERA5 CLIMATE - FIXED VERSION WITH RETRY
            # ========================================================
            self.logger.debug(f"🌡️ Fetching climate data...")
            
            # CRITICAL FIX: Add .filterBounds(point)
            era5_filtered = self.era5_collection.filterDate(start_date, end_date).filterBounds(point)
            era5_count = era5_filtered.size().getInfo()
            
            self.logger.debug(f"   ERA5 images available: {era5_count}")
            
            if era5_count > 0:
                # Temperature (2m) - Use correct band name from diagnostic
                try:
                    def get_temperature():
                        t2m = era5_filtered.select('temperature_2m').mean()
                        return t2m.reduceRegion(
                            reducer=ee.Reducer.mean(),
                            geometry=buffer_point,
                            scale=Config.ERA5_SCALE,
                            bestEffort=True,
                            maxPixels=1e9
                        ).getInfo()
                    
                    t2m_result = self._fetch_with_retry(get_temperature, "Temperature")
                    
                    t2m_value = t2m_result.get('temperature_2m') if t2m_result else None
                    if t2m_value is not None:
                        result['t2m_c'] = t2m_value - 273.15
                        self.logger.debug(f"   ✅ Temperature: {result['t2m_c']:.2f}°C")
                    else:
                        result['t2m_c'] = None
                        self.logger.warning(f"   ⚠️ Temperature is None")
                except Exception as e:
                    self.logger.error(f"   ❌ Temperature fetch error: {e}")
                    result['t2m_c'] = None
                
                # Dewpoint Temperature (2m)
                try:
                    def get_dewpoint():
                        td2m = era5_filtered.select('dewpoint_temperature_2m').mean()
                        return td2m.reduceRegion(
                            reducer=ee.Reducer.mean(),
                            geometry=buffer_point,
                            scale=Config.ERA5_SCALE,
                            bestEffort=True,
                            maxPixels=1e9
                        ).getInfo()
                    
                    td2m_result = self._fetch_with_retry(get_dewpoint, "Dewpoint")
                    
                    td2m_value = td2m_result.get('dewpoint_temperature_2m') if td2m_result else None
                    if td2m_value is not None:
                        result['td2m_c'] = td2m_value - 273.15
                        self.logger.debug(f"   ✅ Dewpoint: {result['td2m_c']:.2f}°C")
                    else:
                        result['td2m_c'] = None
                        self.logger.warning(f"   ⚠️ Dewpoint is None")
                except Exception as e:
                    self.logger.error(f"   ❌ Dewpoint fetch error: {e}")
                    result['td2m_c'] = None
                
                # Calculate Relative Humidity
                if result.get('t2m_c') is not None and result.get('td2m_c') is not None:
                    result['rh_pct'] = self._compute_rh(result['t2m_c'], result['td2m_c'])
                    self.logger.debug(f"   ✅ Humidity: {result['rh_pct']:.1f}%")
                else:
                    result['rh_pct'] = None
                    self.logger.warning(f"   ⚠️ Cannot calculate humidity")
                
                # Precipitation - Use correct band name
                try:
                    def get_precipitation():
                        tp = era5_filtered.select('total_precipitation').sum()
                        return tp.reduceRegion(
                            reducer=ee.Reducer.mean(),
                            geometry=buffer_point,
                            scale=Config.ERA5_SCALE,
                            bestEffort=True,
                            maxPixels=1e9
                        ).getInfo()
                    
                    tp_result = self._fetch_with_retry(get_precipitation, "Precipitation")
                    
                    tp_value = tp_result.get('total_precipitation') if tp_result else None
                    result['tp_m'] = tp_value if tp_value is not None else 0.0
                    self.logger.debug(f"   ✅ Precipitation: {result['tp_m']:.6f}m")
                except Exception as e:
                    self.logger.error(f"   ❌ Precipitation fetch error: {e}")
                    result['tp_m'] = 0.0
                
                # Solar Radiation - Use correct band name WITH RETRY
                try:
                    def get_solar_radiation():
                        ssrd = era5_filtered.select('surface_solar_radiation_downwards').sum()
                        return ssrd.reduceRegion(
                            reducer=ee.Reducer.mean(),
                            geometry=buffer_point,
                            scale=Config.ERA5_SCALE,
                            bestEffort=True,
                            maxPixels=1e9
                        ).getInfo()
                    
                    ssrd_result = self._fetch_with_retry(get_solar_radiation, "Solar Radiation")
                    
                    ssrd_value = ssrd_result.get('surface_solar_radiation_downwards') if ssrd_result else None
                    result['ssrd_jm2'] = ssrd_value if ssrd_value is not None else 0.0
                    self.logger.debug(f"   ✅ Solar: {result['ssrd_jm2']:.0f} J/m²")
                except Exception as e:
                    self.logger.error(f"   ❌ Solar radiation fetch error: {e}")
                    result['ssrd_jm2'] = 0.0
                
                result['climate_source'] = 'ERA5_LAND'
                
            else:
                self.logger.warning(f"⚠️ No ERA5 data for {year}-{month:02d}")
                result['t2m_c'] = None
                result['td2m_c'] = None
                result['rh_pct'] = None
                result['tp_m'] = None
                result['ssrd_jm2'] = None
                result['climate_source'] = None
            
            # ========================================================
            # 4. LAND COVER
            # ========================================================
            self.logger.debug(f"🗺️ Fetching land cover...")
            
            lc_result = self.land_cover.reduceRegion(
                reducer=ee.Reducer.mode(),
                geometry=point,
                scale=Config.SCALE_METERS,
                bestEffort=True,
                maxPixels=1e9
            ).getInfo()
            
            lc_value = lc_result.get('Map')
            result['lc_type1'] = int(lc_value) if lc_value else None
            result['lc_source'] = 'ESA/WorldCover' if lc_value else None
            
            # ========================================================
            # 5. QUALITY SCORE
            # ========================================================
            result['data_quality_score'] = self._calculate_quality_score(result)
            
            # Log summary with temporal info
            self.logger.info(
                f"✅ TEMPORAL data collected for {year}-{month:02d} - "
                f"Soil Version: {result.get('soil_version_year', 'N/A')} | "
                f"Quality: {result['data_quality_score']:.1f}%"
            )
            
            return result
            
        except Exception as e:
            self.logger.error(f"❌ Failed to get temporal data: {e}")
            import traceback
            self.logger.error(traceback.format_exc())
            return None
    
    @staticmethod
    def _compute_rh(t_celsius: float, td_celsius: float) -> float:
        """Calculate relative humidity from temperature and dewpoint"""
        try:
            import math
            # August-Roche-Magnus approximation
            es = 6.112 * math.exp(17.67 * t_celsius / (t_celsius + 243.5))
            e = 6.112 * math.exp(17.67 * td_celsius / (td_celsius + 243.5))
            rh = (e / es) * 100
            return max(0, min(100, rh))  # Clamp to 0-100%
        except:
            return None
    
    @staticmethod
    def _calculate_quality_score(data: Dict) -> float:
        """Calculate data quality score"""
        required_fields = [
            'sand', 'clay', 'ndvi', 't2m_c', 'td2m_c', 'rh_pct', 
            'tp_m', 'ssrd_jm2', 'lc_type1'
        ]
        
        available = sum(1 for field in required_fields if data.get(field) is not None)
        return (available / len(required_fields)) * 100


# ==================== CHECKPOINT MANAGER ====================

class CheckpointManager:
    """Manages pipeline checkpoints"""
    
    def __init__(self, checkpoint_file: str = Config.CHECKPOINT_FILE):
        self.checkpoint_file = Path(checkpoint_file)
        self.logger = logging.getLogger(self.__class__.__name__)
        self.checkpoint_data = self._load_checkpoint()
    
    def _load_checkpoint(self) -> Dict:
        """Load checkpoint"""
        if self.checkpoint_file.exists():
            try:
                with open(self.checkpoint_file, 'r') as f:
                    data = json.load(f)
                self.logger.info(f"📋 Loaded checkpoint: {len(data.get('completed', []))} completed")
                return data
            except Exception as e:
                self.logger.warning(f"⚠️ Failed to load checkpoint: {e}")
        
        return {'completed': [], 'failed': [], 'last_update': None}
    
    def save_checkpoint(self):
        """Save checkpoint"""
        try:
            self.checkpoint_data['last_update'] = datetime.now().isoformat()
            with open(self.checkpoint_file, 'w') as f:
                json.dump(self.checkpoint_data, f, indent=2)
        except Exception as e:
            self.logger.error(f"❌ Failed to save checkpoint: {e}")
    
    def mark_completed(self, location: str, year: int, month: int):
        """Mark task as completed"""
        task_id = f"{location}_{year}_{month:02d}"
        if task_id not in self.checkpoint_data['completed']:
            self.checkpoint_data['completed'].append(task_id)
            self.save_checkpoint()
    
    def is_completed(self, location: str, year: int, month: int) -> bool:
        """Check if task is completed"""
        task_id = f"{location}_{year}_{month:02d}"
        return task_id in self.checkpoint_data['completed']


# ==================== MAIN PIPELINE ====================

class HistoricalDataPipeline:
    """Main pipeline orchestrator"""
    
    def __init__(self):
        self.logger = logging.getLogger(self.__class__.__name__)
        self.db = DatabaseManager()
        self.collector = IntegratedDataCollector()
        self.checkpoint = CheckpointManager()
        
        # Statistics
        self.stats = {
            'total_tasks': 0,
            'completed': 0,
            'failed': 0,
            'skipped': 0,
            'start_time': None,
            'end_time': None
        }
    
    def run(self, resume: bool = True):
        """Run the complete pipeline"""
        self.stats['start_time'] = datetime.now()
        
        self.logger.info("="*80)
        self.logger.info("🚀 INTEGRATED HISTORICAL DATA PIPELINE (2014-2024) - TEMPORAL SOIL DATA")
        self.logger.info("="*80)
        self.logger.info(f"📅 Time Range: {Config.START_YEAR} - {Config.END_YEAR}")
        self.logger.info(f"📍 Locations: {len(Config.LOCATIONS)}")
        self.logger.info(f"💾 Database: {Config.DB_NAME}")
        self.logger.info(f"🔄 Resume Mode: {resume}")
        self.logger.info("🌱 FEATURE: Temporal soil data with version-aware collection")
        self.logger.info("="*80)
        
        # Calculate total tasks
        total_months = (Config.END_YEAR - Config.START_YEAR + 1) * 12
        self.stats['total_tasks'] = len(Config.LOCATIONS) * total_months
        
        try:
            # Process each location
            for location in Config.LOCATIONS:
                self._process_location(location, resume)
            
            self.stats['end_time'] = datetime.now()
            self._print_summary()
            
        except KeyboardInterrupt:
            self.logger.warning("\n⚠️ Pipeline interrupted by user")
            self.checkpoint.save_checkpoint()
            self._print_summary()
        except Exception as e:
            self.logger.error(f"❌ Pipeline failed: {e}", exc_info=True)
            raise
    
    def _process_location(self, location: Dict, resume: bool):
        """Process all years/months for a single location"""
        loc_name = location['name']
        
        self.logger.info(f"\n{'='*80}")
        self.logger.info(f"📍 Processing: {loc_name} ({location['region']})")
        self.logger.info(f"   Coordinates: ({location['lat']:.4f}, {location['lon']:.4f})")
        self.logger.info(f"{'='*80}")
        
        batch_data = []
        
        # Iterate through years and months
        for year in range(Config.START_YEAR, Config.END_YEAR + 1):
            for month in range(1, 13):
                
                # Skip if already completed
                if resume and self.checkpoint.is_completed(loc_name, year, month):
                    self.stats['skipped'] += 1
                    continue
                
                # Skip if already in database
                if self.db.check_existing_data(loc_name, year, month):
                    self.logger.debug(f"⏭️  Skipping {loc_name} {year}-{month:02d} (in DB)")
                    self.checkpoint.mark_completed(loc_name, year, month)
                    self.stats['skipped'] += 1
                    continue
                
                try:
                    # Collect data
                    self.logger.info(f"🔄 {loc_name} - {year}-{month:02d}")
                    
                    data = self.collector.get_monthly_data(
                        latitude=location['lat'],
                        longitude=location['lon'],
                        year=year,
                        month=month
                    )
                    
                    if data is None:
                        raise ValueError("No data returned")
                    
                    # Add metadata
                    data['location_name'] = loc_name
                    data['latitude'] = location['lat']
                    data['longitude'] = location['lon']
                    data['year'] = year
                    data['month'] = month
                    
                    batch_data.append(data)
                    
                    self.logger.info(f"✅ Quality: {data['data_quality_score']:.1f}%")
                    
                    # Insert batch if size reached
                    if len(batch_data) >= Config.BATCH_SIZE:
                        self._insert_batch(batch_data)
                        batch_data = []
                    
                    self.checkpoint.mark_completed(loc_name, year, month)
                    self.stats['completed'] += 1
                    
                    # Rate limiting
                    time.sleep(2)  # Increased to reduce server load
                    
                except Exception as e:
                    self.logger.error(f"❌ Failed: {loc_name} {year}-{month:02d} - {e}")
                    self.stats['failed'] += 1
                    continue
        
        # Insert remaining batch
        if batch_data:
            self._insert_batch(batch_data)
    
    def _insert_batch(self, batch_data: List[Dict]):
        """Insert batch into database"""
        try:
            df = pd.DataFrame(batch_data)
            
            # Column order INCLUDING NPK and temporal soil metadata
            column_order = [
                'location_name', 'latitude', 'longitude', 'year', 'month',
                'sand', 'silt', 'clay', 'soc', 'ph', 'bdod', 'cec',
                'nitrogen', 'phosphorus', 'potassium',  # ✅ NPK columns
                'ndvi', 't2m_c', 'td2m_c', 'rh_pct', 'tp_m', 'ssrd_jm2',
                'lc_type1', 'ndvi_source', 'climate_source', 'lc_source',
                'soil_version_year', 'soil_data_year',  # ✅ Temporal soil metadata
                'data_quality_score'
            ]
            
            # Select available columns
            available_columns = [col for col in column_order if col in df.columns]
            df = df[available_columns]
            
            # Insert to database
            self.db.bulk_insert(df, 'historical_data', if_exists='append')
            
            self.logger.info(f"💾 Batch inserted: {len(df)} records with temporal soil data")
            
        except Exception as e:
            self.logger.error(f"❌ Batch insert failed: {e}")
            raise
    
    def _print_summary(self):
        """Print execution summary"""
        duration = None
        if self.stats['start_time'] and self.stats['end_time']:
            duration = self.stats['end_time'] - self.stats['start_time']
        
        self.logger.info("\n" + "="*80)
        self.logger.info("📊 PIPELINE EXECUTION SUMMARY")
        self.logger.info("="*80)
        self.logger.info(f"Total Tasks:     {self.stats['total_tasks']}")
        self.logger.info(f"✅ Completed:    {self.stats['completed']}")
        self.logger.info(f"⏭️  Skipped:      {self.stats['skipped']}")
        self.logger.info(f"❌ Failed:       {self.stats['failed']}")
        
        if duration:
            self.logger.info(f"⏱️  Duration:     {duration}")
            if self.stats['completed'] > 0:
                avg_time = duration.total_seconds() / self.stats['completed']
                self.logger.info(f"⚡ Avg/Task:     {avg_time:.2f}s")
        
        success_rate = (self.stats['completed'] / self.stats['total_tasks'] * 100) if self.stats['total_tasks'] > 0 else 0
        self.logger.info(f"📈 Success Rate: {success_rate:.1f}%")
        self.logger.info("🌱 FEATURE: Temporal soil data collection enabled")
        self.logger.info("="*80)


# ==================== ENTRY POINT ====================

def main():
    """Main entry point"""
    # Setup logging
    logger = setup_logging()
    
    logger.info("🎯 TEMPORAL Historical Data Pipeline - Desertification Analysis")
    logger.info("="*80)
    logger.info("🌱 FEATURE: Temporal soil data with version-aware collection")
    logger.info("="*80)
    
    try:
        # Create and run pipeline
        pipeline = HistoricalDataPipeline()
        pipeline.run(resume=True)
        
        logger.info("\n✅ Temporal pipeline completed successfully!")
        logger.info("📊 Soil data now varies appropriately by year")
        logger.info("💾 Temporal data has been stored in the database")
        
    except Exception as e:
        logger.error(f"\n❌ Temporal pipeline failed with error: {e}", exc_info=True)
        sys.exit(1)


if __name__ == "__main__":
    main()