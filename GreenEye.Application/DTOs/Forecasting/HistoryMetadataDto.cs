using System.Text.Json.Serialization;

namespace GreenEye.Application.DTOs.Forecasting
{
    public class HistoryMetadataDto
    {
        [JsonPropertyName("latitude")]
        public double Latitude { get; set; }

        [JsonPropertyName("longitude")]
        public double Longitude { get; set; }

        [JsonPropertyName("location_name")]
        public string? LocationName { get; set; }
    }
}
