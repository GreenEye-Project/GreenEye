using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Text.Json.Serialization;
using System.Threading.Tasks;

namespace GreenEye.Application.DTOs.Forecasting
{
    // Response from History API (API 1)
    public class HistoryDataResponse
    {
        [JsonPropertyName("success")]
        public bool Success { get; set; }

        [JsonPropertyName("total_samples")]
        public int TotalSamples { get; set; }

        [JsonPropertyName("location_name")]
        public string? LocationName { get; set; }

        [JsonPropertyName("features")]
        public List<HistoryFeatureDto>? Features { get; set; }

        [JsonPropertyName("metadata")]
        public HistoryMetadataDto? Metadata { get; set; }
    }
}
