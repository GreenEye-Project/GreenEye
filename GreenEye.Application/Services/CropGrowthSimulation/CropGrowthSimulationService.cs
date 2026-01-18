using AutoMapper;
using GreenEye.Application.DTOs.Classification;
using GreenEye.Application.DTOs.CropGrowthSimulation;
using GreenEye.Application.Exceptions;
using GreenEye.Application.IServices;
using GreenEye.Application.IServices.Classification;
using Microsoft.Extensions.Configuration;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Http.Json;
using System.Text;
using System.Text.Json;
using System.Threading.Tasks;

namespace GreenEye.Application.Services.CropGrowthSimulation
{
    public class CropGrowthSimulationService : ICropGrowthSimulationService
    {

        private readonly IExternalApiService _externalApiService;
        private readonly HttpClient _httpClient;
        private readonly IConfiguration _configuration;
        private readonly IMapper _mapper;

        public CropGrowthSimulationService(
            IExternalApiService externalApiService,
            HttpClient httpClient,
            IConfiguration configuration,
            IMapper mapper)
        {
            _externalApiService = externalApiService;
            _httpClient = httpClient;
            _configuration = configuration;
            _mapper = mapper;
        }

        public async Task<SimulationModelResponseDto?> GetSimulationAsync(double longitude, double latitude, string cropName)
        {
            var externalData =  await _externalApiService.GetExternalData(longitude, latitude); // returns EternalApiResponseDto

            if (externalData == null)
                throw new BusinessException("Failed to load location data!");

            if(!string.IsNullOrEmpty(cropName))
                cropName = char.ToUpper(cropName[0]) + cropName.Substring(1).ToLower();


            var features = _mapper.Map<SimulationFeaturesForRequest>(externalData.Features);

            var requestData = new SimulationModelRequestDto
            {
                CropName = cropName,
                Features = features,
            };


            var simulationModelResponse = await _httpClient.PostAsJsonAsync(_configuration["ExternalApis:SimulationModelApi"], requestData);

            if (!simulationModelResponse.IsSuccessStatusCode)
                throw new BusinessException("Failed to simulate!");

            var content = await simulationModelResponse.Content.ReadAsStringAsync();

            var result = JsonSerializer.Deserialize<SimulationModelResponseDto>(content);
            return result;

        }
    }
}
