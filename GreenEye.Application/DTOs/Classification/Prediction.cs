using System.Text.Json.Serialization;

namespace GreenEye.Application.DTOs.Classification
{
    public class Prediction
    {
        [JsonPropertyName("desertification_level")]
        public string desertification_level { get; set; } = string.Empty;
        [JsonPropertyName("confidence")]
        public double confidence { get; set; }
    }
}
