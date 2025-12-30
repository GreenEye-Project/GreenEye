using GreenEye.Domain.Entities.PlantDisease;
using GreenEye.Infrastructure.IdentityModel;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
namespace GreenEye.Infrastructure.Entities.PlantDisease
{
    public class CropDiseaseEntity : CropDisease
    {
        // Navigation Property 
        public ApplicationUser? User { get; set; }
    }
}
