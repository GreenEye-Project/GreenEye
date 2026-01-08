using System.ComponentModel.DataAnnotations;

namespace GreenEye.Domain.Entities.CropRecommendation
{
    public class CropRecommendationResult
    {
        public int Id { get; set; }
        public string? UserId { get; set; }
        public double Latitude { get; set; }
        public double Longitude { get; set; }
        public string? LocationName { get; set; }
        public List<string> RecommendedCrops { get; set; } = new List<string>();
        public DateTime CreatedAt { get; set; }
        public bool IsDeleted { get; set; }
    }
}
