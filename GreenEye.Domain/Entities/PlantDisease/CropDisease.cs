using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace GreenEye.Domain.Entities.PlantDisease
{
    public class CropDisease
    {
        public int Id { get; set; }

        public string? ImageUrl { get; set; }

        public string? DiseaseClass { get; set; } 

        public string? Cause { get; set; } 

        public string? Treatment { get; set; } 

        public double Confidence { get; set; }

        public DateTime SentAt { get; set; }

        public bool IsDeleted { get; set; } = false;

        public string? UserId { get; set; } 
    }
}
