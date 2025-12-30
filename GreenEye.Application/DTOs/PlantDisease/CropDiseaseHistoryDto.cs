using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Text.Json.Serialization;
using System.Threading.Tasks;

namespace GreenEye.Application.DTOs.PlantDisease
{
    public class CropDiseaseHistoryDto
    {
        [JsonPropertyName("Id")]
        public int Id { get; set; }

        [JsonPropertyName("Image Url")]
        public string? ImageUrl { get; set; }

        [JsonPropertyName("Disease Class")]
        public string? DiseaseClass { get; set; }

        [JsonPropertyName("Cause")]
        public string? Cause { get; set; }

        [JsonPropertyName("Treatment")]
        public string? Treatment { get; set; }

        [JsonPropertyName("Confidence")]
        public double Confidence { get; set; }

        [JsonPropertyName("Sent At")]
        public DateTime SentAt { get; set; }
    }
}
