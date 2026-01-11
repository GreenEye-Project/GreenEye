using System.Text.Json.Serialization;
namespace GreenEye.Application.DTOs.ExternalData
{
    public class FeaturesDto
    {
        [JsonPropertyName("year")]
        public int? year { get; set; } = 0;

        [JsonPropertyName("month")]
        public int? month { get; set; } = 0;

        [JsonPropertyName("sand")]
        public double? sand { get; set; } = 0;

        [JsonPropertyName("silt")]
        public double? silt { get; set; } = 0;

        [JsonPropertyName("clay")]
        public double? clay { get; set; } = 0;

        [JsonPropertyName("soc")]
        public double? soc { get; set; } = 0;

        [JsonPropertyName("ph")]
        public double? ph { get; set; } = 0;

        [JsonPropertyName("bdod")]
        public double? bdod { get; set; } = 0;

        [JsonPropertyName("cec")]
        public double? cec { get; set; } = 0;

        [JsonPropertyName("ndvi")]
        public double? ndvi { get; set; } = 0;

        [JsonPropertyName("t2m_c")]
        public double? t2m_c { get; set; } = 0;

        [JsonPropertyName("td2m_c")]
        public double? td2m_c { get; set; } = 0;

        [JsonPropertyName("rh_pct")]
        public double? rh_pct { get; set; } = 0;

        [JsonPropertyName("tp_m")]
        public double? tp_m { get; set; } = 0;

        [JsonPropertyName("ssrd_jm2")]
        public double? ssrd_jm2 { get; set; } = 0;

        [JsonPropertyName("lc_type1")]
        public double? lc_type1 { get; set; } = 0;

        [JsonPropertyName("nitrogen")]
        public double? nitrogen { get; set; } = 0;

        [JsonPropertyName("phosphorus")]
        public double? phosphorus { get; set; } = 0;

        [JsonPropertyName("potassium")]
        public double? potassium { get; set; } = 0;

        [JsonPropertyName("latitude")]
        public double latitude { get; set; } = 0;

        [JsonPropertyName("longitude")]
        public double longitude { get; set; } = 0;
    }
}
