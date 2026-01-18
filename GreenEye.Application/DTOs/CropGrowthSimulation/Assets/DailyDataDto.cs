using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Text.Json.Serialization;
using System.Threading.Tasks;

namespace GreenEye.Application.DTOs.CropGrowthSimulation.Assets
{
    public class DailyDataDto
    {
        [JsonPropertyName("day")]
        public int Day { get; set; }

        [JsonPropertyName("soil_moisture_percent")]
        public double SoilMoisturePercent { get; set; }

        [JsonPropertyName("needs_water")]
        public bool NeedsWater { get; set; }

        [JsonPropertyName("growth_percentage")]
        public double GrowthPercentage { get; set; }

        [JsonPropertyName("biomass_ton_ha")]
        public double BiomassTonHa { get; set; }

        [JsonPropertyName("lai")]
        public double Lai { get; set; }

        [JsonPropertyName("temp_c")]
        public double TempC { get; set; }

        [JsonPropertyName("rain_mm")]
        public double RainMm { get; set; }

        [JsonPropertyName("irrigation_mm")]
        public double IrrigationMm { get; set; }

        [JsonPropertyName("stage_label")]
        public string StageLabel { get; set; }

        [JsonPropertyName("description")]
        public string Description { get; set; }
    }
}
