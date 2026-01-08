using GreenEye.Application.DTOs.ExternalData;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Text.Json.Serialization;

namespace GreenEye.Application.DTOs.ExternalApi
{
    public class ExternalApiReponse
    {
        [JsonPropertyName("success")]
        public bool Success { get; set; }
        [JsonPropertyName("features")]
        public FeaturesDto Features { get; set; } = new FeaturesDto();
        [JsonPropertyName("metadata")]
        public MetaData Metadata { get; set; } = default!;
    }
}
