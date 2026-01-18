using GreenEye.Application.DTOs.ExternalData;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Text.Json.Serialization;
using System.Threading.Tasks;

namespace GreenEye.Application.DTOs.CropGrowthSimulation
{
    public class SimulationModelRequestDto
    {
        [JsonPropertyName("crop_name")]
        public string CropName { get; set; } = string.Empty;
        [JsonPropertyName("features")]
        public SimulationFeaturesForRequest Features { get; set; } = new SimulationFeaturesForRequest();
    }
}
