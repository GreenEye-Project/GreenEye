using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Text.Json.Serialization;
using System.Threading.Tasks;

namespace GreenEye.Application.DTOs.CropGrowthSimulation
{
    public class BaseFeatures
    {
        [JsonPropertyName("sand")]
        public double? sand { get; set; }
        [JsonPropertyName("clay")]
        public double? clay { get; set; }

        [JsonPropertyName("soc")]
        public double? soc { get; set; }
        [JsonPropertyName("bdod")]
        public double? bdod { get; set; }

        [JsonPropertyName("nitrogen")]
        public double? nitrogen { get; set; }
    }
}
