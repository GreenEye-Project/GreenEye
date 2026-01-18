using GreenEye.Application.DTOs.CropGrowthSimulation.Assets;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Text.Json.Serialization;
using System.Threading.Tasks;

namespace GreenEye.Application.DTOs.CropGrowthSimulation
{
    public class SimulationModelResponseDto
    {
        [JsonPropertyName("crop")]
        public string CropName { get; set; } = string.Empty;
        [JsonPropertyName("timestamp")]
        public DateTimeOffset TimeStamp { get; set; }
        [JsonPropertyName("yield_prediction")]
        public decimal YieldPrediction { get; set; }
        [JsonPropertyName("soil_analysis")]
        public SoilAnalysis SoilAnalysis { get; set; }
        [JsonPropertyName("soil_properties")]
        public SoilProperties SoilProperties { get; set; }
        [JsonPropertyName("sensitivity_analysis")]
        public SensitivityAnalysis SensitivityAnalysis { get; set; }
        [JsonPropertyName("daily_data")]
        public List<DailyDataDto> DailyDataDto { get; set; }

    }
}
