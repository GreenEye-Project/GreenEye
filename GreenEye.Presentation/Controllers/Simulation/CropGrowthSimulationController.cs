using GreenEye.Application.DTOs.CropGrowthSimulation;
using GreenEye.Application.IServices;
using GreenEye.Presentation.Response;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace GreenEye.Presentation.Controllers.Simulation
{
    [Route("api/[controller]")]
    [ApiController]
    public class CropGrowthSimulationController : ControllerBase
    {
        private readonly ICropGrowthSimulationService _simulationService;

        public CropGrowthSimulationController(ICropGrowthSimulationService cropGrowthSimulationService)
        {
            _simulationService = cropGrowthSimulationService;
        }
        [HttpGet("simulate")]
        public async Task<ActionResult> simulate(double longitude, double latitude, string cropName)
        {
            var simulation = await _simulationService.GetSimulationAsync(longitude, latitude, cropName);

            return Ok(new GeneralResponse<SimulationModelResponseDto>
            {
                IsSuccess = true,
                Data = simulation
            });
        }
    }
}
