using System.Text.Json.Serialization;

namespace GreenEye.Application.DTOs.Forecasting
{
    public class ForecastingInputItem
    {
        [JsonPropertyName("metadata")]
        public ForecastingMetadataDto? Metadata { get; set; }

        [JsonPropertyName("features")]
        public ForecastingFeaturesDto? Features { get; set; }
    }
}
