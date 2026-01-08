using System.Text.Json.Serialization;

namespace GreenEye.Application.DTOs.Forecasting
{
    public class ForecastingMetadataDto
    {
        [JsonPropertyName("location_name")]
        public string? LocationName { get; set; }
    }
}
