using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Text.Json.Serialization;
using System.Threading.Tasks;

namespace GreenEye.Application.DTOs.CropGrowthSimulation.Assets
{
    public class SoilProperties
    {
        [JsonPropertyName("field_capacity")]
        public decimal FieldCapacity { get; set; }
        [JsonPropertyName("wilting_point")]
        public decimal WiltingPoint { get; set; }
        [JsonPropertyName("saturation")]
        public decimal Saturation { get; set; }
    }
}
