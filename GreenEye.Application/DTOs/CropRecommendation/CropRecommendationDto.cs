namespace GreenEye.Application.DTOs.CropRecommendation
{
    using System.Text.Json.Serialization;

    public class CropRecommendationRequestDto
    {
        [JsonPropertyName("latitude")]
        public double Latitude { get; set; }

        [JsonPropertyName("longitude")]
        public double Longitude { get; set; }
    }

    public class CropRecommendationResponseDto
    {
        [JsonPropertyName("recommended_crops")]
        public List<string> RecommendedCrops { get; set; } = new List<string>();

        [JsonPropertyName("generated_at")]
        public DateTime GeneratedAt { get; set; }
    }

    // DTO for storing the recommendation result in the database/history
    public class CropRecommendationHistoryDto
    {
        public int Id { get; set; }

        [JsonPropertyName("latitude")]
        public double Latitude { get; set; }

        [JsonPropertyName("longitude")]
        public double Longitude { get; set; }

        [JsonPropertyName("location_name")]
        public string LocationName { get; set; }

        [JsonPropertyName("recommended_crops")]
        public List<string> RecommendedCrops { get; set; }

        [JsonPropertyName("created_at")]
        public DateTime CreatedAt { get; set; }
    }
}
