using System.Text.Json.Serialization;

namespace GreenEye.Application.DTOs.PlantDisease
{
    public class CropDiseaseModelResponseDto
    {
        [JsonPropertyName("Disease Class")]
        public string? DiseaseClass { get; set; }

        [JsonPropertyName("Cause")]
        public string? Cause { get; set; }

        [JsonPropertyName("Treatment")]
        public string? Treatment { get; set; }

        [JsonPropertyName("Confidence")]
        public double Confidence { get; set; }
    }
}
