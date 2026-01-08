using GreenEye.Application.DTOs.ExternalApi;
using System.Text.Json.Serialization;

namespace GreenEye.Application.DTOs.Classification
{
    public class ClassificationResponse
    {
        [JsonPropertyName("prediction")]
        public Prediction prediction { get; set; } = new Prediction();
        [JsonPropertyName("metadata")]
        public MetaData MetaData { get; set; } = new MetaData();

        // public bool optimalExists { get; set; } = true;
        // public FeaturesDto CurrentData {  get; set; } = new FeaturesDto();
        // public OptimalRegionData optimalData { get; set; } = new OptimalRegionData();
    }
}
