using GreenEye.Application.DTOs.Classification;
using GreenEye.Application.IServices.Classification;
using GreenEye.Presentation.Response;
using Microsoft.AspNetCore.Mvc;

namespace GreenEye.Presentation.Controllers.Classification
{
    [Route("api/[controller]")]
    [ApiController]
    public class ClassificationController : ControllerBase
    {
        private readonly IClassificationService _classificationService;

        public ClassificationController(IClassificationService classificationService)
        {
            _classificationService = classificationService;
        }

        [HttpGet]
        public async Task<IActionResult> GetClassification(double longitude, double latitude)
        {
                var classification = await _classificationService.GetClassificationAsync(longitude, latitude);

            return Ok(new GeneralResponse<ClassificationResponse>
            {
                IsSuccess = true,
                Data = classification
            });
            
            
        }
    }
}
