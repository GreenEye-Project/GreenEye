using GreenEye.Application.IServices.Forecasting;
using GreenEye.Presentation.Response;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using System.Security.Claims;

namespace GreenEye.Presentation.Controllers.Forecasting
{
    [Route("api/[controller]")]
    [ApiController]
    public class ForecastingController : ControllerBase
    {
        private readonly IForecastingService _forecastingService;

        public ForecastingController(IForecastingService forecastingService)
        {
            _forecastingService = forecastingService;
        }

        [HttpGet("forecast")]
        public async Task<IActionResult> GetForecast([FromQuery] double latitude, [FromQuery] double longitude)
        {
            if (!ModelState.IsValid)
                return BadRequest(new GeneralResponse<object>
                {
                    IsSuccess = false,
                    Message = "Invalid request parameters"
                });

            // Validate coordinates
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

            // Get userId if user is authenticated (optional)
            var userId = User.FindFirstValue(ClaimTypes.NameIdentifier);

            var result = await _forecastingService.GetDesertificationForecastAsync(latitude, longitude, userId);

            return Ok(new GeneralResponse<object>
            {
                IsSuccess = true,
                Data = result
            });
        }

      //  [Authorize]
        [HttpGet("my-forecasts")]
        public async Task<IActionResult> GetMyForecasts()
        {
            var userId = User.FindFirstValue(ClaimTypes.NameIdentifier);

            //if (string.IsNullOrEmpty(userId))
            //    return Unauthorized(new GeneralResponse<object>
            //    {
            //        IsSuccess = false,
            //        Message = "User not authenticated"
            //    });

            var result = await _forecastingService.GetUserForecastHistoryAsync(userId);

            return Ok(new GeneralResponse<object>
            {
                IsSuccess = true,
                Data = result
            });
        }

       
    }
}
