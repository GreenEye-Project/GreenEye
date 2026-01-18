using GreenEye.Application.DTOs.Classification;
using GreenEye.Application.DTOs.CropGrowthSimulation;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace GreenEye.Application.IServices
{
    public interface ICropGrowthSimulationService
    {
        Task<SimulationModelResponseDto?> GetSimulationAsync(double longitude, double latitude, string cropName);
    }
}
