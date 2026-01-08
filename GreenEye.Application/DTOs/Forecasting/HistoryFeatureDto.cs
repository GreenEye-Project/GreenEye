using System.Text.Json.Serialization;

namespace GreenEye.Application.DTOs.Forecasting
{
    public class HistoryFeatureDto
    {
        [JsonPropertyName("year")]
        public int Year { get; set; }

        [JsonPropertyName("month")]
        public int Month { get; set; }

        [JsonPropertyName("location_name")]
        public string? LocationName { get; set; }

        [JsonPropertyName("sand")]
        public double Sand { get; set; }

        [JsonPropertyName("silt")]
        public double Silt { get; set; }

        [JsonPropertyName("clay")]
        public double Clay { get; set; }

        [JsonPropertyName("soc")]
        public double Soc { get; set; }

        [JsonPropertyName("ph")]
        public double Ph { get; set; }

        [JsonPropertyName("cec")]
        public double Cec { get; set; }

        [JsonPropertyName("bdod")]
        public double Bdod { get; set; }

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

        [JsonPropertyName("lc_type1")]
        public int LcType1 { get; set; }

        [JsonPropertyName("nitrogen")]
        public double Nitrogen { get; set; }

        [JsonPropertyName("phosphorus")]
        public double Phosphorus { get; set; }

        [JsonPropertyName("potassium")]
        public double Potassium { get; set; }

        [JsonPropertyName("latitude")]
        public double Latitude { get; set; }

        [JsonPropertyName("longitude")]
        public double Longitude { get; set; }
    }
}
