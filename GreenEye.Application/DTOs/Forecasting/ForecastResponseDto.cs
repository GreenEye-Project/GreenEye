namespace GreenEye.Application.DTOs.Forecasting
{
    // Final response to client
    public class ForecastResponseDto
    {
        public double Latitude { get; set; }
        public double Longitude { get; set; }
        public string? LocationName { get; set; }
        public List<ForecastItemDto>? Forecasts { get; set; }
        public DateTime GeneratedAt { get; set; }
    }
}
