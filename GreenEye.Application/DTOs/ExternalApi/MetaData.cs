using System.Text.Json.Serialization;

namespace GreenEye.Application.DTOs.ExternalApi
{
    public class MetaData
    {
        [JsonPropertyName("location_name")]
        public string? LocationName { get; set; } = string.Empty;
    }
}
