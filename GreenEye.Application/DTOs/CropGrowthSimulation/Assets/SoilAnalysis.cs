using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Text.Json.Serialization;
using System.Threading.Tasks;

namespace GreenEye.Application.DTOs.CropGrowthSimulation.Assets
{
    public class SoilAnalysis
    {
        [JsonPropertyName("overall_quality")]
        public decimal OverallQuality { get; set; }
        [JsonPropertyName("texture_score")]
        public decimal TextureScore { get; set; }
        [JsonPropertyName("nutrient_score")]
        public decimal NutrientScore { get; set; }
        [JsonPropertyName("feedback")]
        public string FeedBack { get; set; }
    }
}
