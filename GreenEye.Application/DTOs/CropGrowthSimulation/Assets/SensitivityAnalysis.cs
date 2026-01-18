using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Text.Json.Serialization;
using System.Threading.Tasks;

namespace GreenEye.Application.DTOs.CropGrowthSimulation.Assets
{
    public class SensitivityAnalysis
    {
        [JsonPropertyName("low_irrigation")]
        public LowIrrigation LowIrrigations {  get; set; }
        [JsonPropertyName("climate_stress")]
        public ClimateStress ClimateStress { get; set; }
    }
}
