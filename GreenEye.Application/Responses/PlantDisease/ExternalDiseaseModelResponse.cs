using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Text.Json.Serialization;
using System.Threading.Tasks;

namespace GreenEye.Application.Responses.PlantDisease
{
    public class ExternalDiseaseModelResponse
    {
        [JsonPropertyName("class")]
        public string? Class { get; set; } 

        [JsonPropertyName("confidence")]
        public double Confidence { get; set; }

        [JsonPropertyName("cause")]
        public string? Cause { get; set; } 

        [JsonPropertyName("treatment")]
        public string? Treatment { get; set; } 
    }
}
