using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Text.Json.Serialization;
using System.Threading.Tasks;

namespace GreenEye.Application.DTOs.CropGrowthSimulation
{
    public class SimulationFeaturesForRequest : BaseFeatures
    {
        [JsonPropertyName("temperature")]
        public double Temperature { get; set; }
    }
}
