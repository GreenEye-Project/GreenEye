using GreenEye.Application.IServices.CropRecommendation;
using GreenEye.Presentation.Response;
using Microsoft.AspNetCore.Mvc;
using System.Security.Claims;

namespace GreenEye.Presentation.Controllers.CropRecommendation
{
    [Route("api/[controller]")]
    [ApiController]
    public class CropRecommendationController : ControllerBase
    {
        private readonly ICropRecommendationService _cropRecommendationService;

        public CropRecommendationController(ICropRecommendationService cropRecommendationService)
        {
            _cropRecommendationService = cropRecommendationService;
        }

        [HttpGet("recommend")]
        public async Task<IActionResult> GetRecommendation([FromQuery] double latitude, [FromQuery] double longitude)
        {
            if (!ModelState.IsValid)
                return BadRequest(new GeneralResponse<object>
                {
                    IsSuccess = false,
                    Message = "Invalid request parameters"
                });

            if (latitude < -90 || latitude > 90)
                return BadRequest(new GeneralResponse<object>
                {
                    IsSuccess = false,
                    Message = "Latitude must be between -90 and 90"
                });

            if (longitude < -180 || longitude > 180)
                return BadRequest(new GeneralResponse<object>
                {
                    IsSuccess = false,
                    Message = "Longitude must be between -180 and 180"
                });

            var userId = User.FindFirstValue(ClaimTypes.NameIdentifier);

            
            //if (string.IsNullOrEmpty(userId))
            //{
            //     return Unauthorized(new GeneralResponse<object>
            //     {
            //         IsSuccess = false,
            //         Message = "User is not authenticated."
            //     });
            //}

            var result = await _cropRecommendationService.GetRecommendationAsync(latitude, longitude, userId);

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
            //if (string.IsNullOrEmpty(userId))
            //{
            //     return Unauthorized(new GeneralResponse<object>
            //     {
            //         IsSuccess = false,
            //         Message = "User is not authenticated."
            //     });
            //}

            var result = await _cropRecommendationService.GetUserHistoryAsync(userId);

            return Ok(new GeneralResponse<object>
            {
                IsSuccess = true,
                Data = result
            });
        }
    }
}
