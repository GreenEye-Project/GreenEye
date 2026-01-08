namespace GreenEye.Application.DTOs.Forecasting
{
    // User forecast history
    public class ForecastHistoryDto
    {
        public double Latitude { get; set; }
        public double Longitude { get; set; }
        public string? LocationName { get; set; }
        public DateTime LastUpdated { get; set; }
        public int TotalForecasts { get; set; }
        public string? LatestRiskLevel { get; set; }
    }
}
