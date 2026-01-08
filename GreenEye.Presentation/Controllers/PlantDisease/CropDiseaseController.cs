using GreenEye.Application.IServices.PlantDisease;
using GreenEye.Presentation.Response;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using System.Security.Claims;

namespace GreenEye.Presentation.Controllers.PlantDisease
{
    [Route("api/[controller]")]
    [ApiController]
    public class CropDiseaseController : ControllerBase
    {
        private readonly ICropDiseaseService _cropDiseaseService;

        public CropDiseaseController(ICropDiseaseService cropDiseaseService)
        {
            _cropDiseaseService = cropDiseaseService;
        }

        [HttpPost]
        public async Task<IActionResult> DetectDisease(IFormFile image)
        {
            if (!ModelState.IsValid)
                return BadRequest(new GeneralResponse<object>
                {
                    IsSuccess = false,
                    Message = "Invalid request data"
                });

            if (image == null || image.Length == 0)
                return BadRequest(new GeneralResponse<object>
                {
                    IsSuccess = false,
                    Message = "Please upload a valid image."
                });

            var userId = User.FindFirstValue(ClaimTypes.NameIdentifier);
            var result = await _cropDiseaseService.DetectDiseaseAsync(image, userId!);

            return Ok(new GeneralResponse<object>
            {
                IsSuccess = true,
                Data = result
            });
        }

        [HttpGet("history")]
        public async Task<IActionResult> GetHistory()
        {
            var userId = User.FindFirstValue(ClaimTypes.NameIdentifier);
            var result = await _cropDiseaseService.GetUserHistoryAsync(userId!);

            return Ok(new GeneralResponse<object>
            {
                IsSuccess = true,
                Data = result
            });
        }

        [HttpDelete("delete-history/{id}")]
        public async Task<IActionResult> DeleteHistory(int id)
        {
            var userId = User.FindFirstValue(ClaimTypes.NameIdentifier);
            await _cropDiseaseService.DeleteHistoryAsync(id, userId!);

            return Ok(new GeneralResponse<object>
            {
                IsSuccess = true,
                Message = "History item deleted successfully."
            });
        }

    }
}
