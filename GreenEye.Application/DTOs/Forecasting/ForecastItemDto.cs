using System.Text.Json.Serialization;

namespace GreenEye.Application.DTOs.Forecasting
{
    public class ForecastItemDto
    {
        [JsonPropertyName("year")]
        public int Year { get; set; }

        [JsonPropertyName("month")]
        public int Month { get; set; }

        [JsonPropertyName("ndvi")]
        public double Ndvi { get; set; }

        [JsonPropertyName("t2m_c")]
        public double T2mC { get; set; }

        [JsonPropertyName("td2m_c")]
        public double Td2mC { get; set; }

        [JsonPropertyName("rh_pct")]
        public double RhPct { get; set; }

        [JsonPropertyName("tp_m")]
        public double TpM { get; set; }

        [JsonPropertyName("ssrd_jm2")]
        public double SsrdJm2 { get; set; }

        [JsonPropertyName("risk_level")]
        public string? RiskLevel { get; set; }

        [JsonPropertyName("risk_confidence")]
        public double RiskConfidence { get; set; }
    }
}
