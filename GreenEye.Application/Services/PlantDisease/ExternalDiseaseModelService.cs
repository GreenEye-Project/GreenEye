using GreenEye.Application.Exceptions;
using GreenEye.Application.IServices.PlantDisease;
using GreenEye.Application.Responses.PlantDisease;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Configuration;
using System.Text.Json;

namespace GreenEye.Application.Services.PlantDisease
{
    public class ExternalDiseaseModelService : IExternalDiseaseModelService
    {
        private readonly HttpClient _httpClient;
        private readonly IConfiguration _config;

        public ExternalDiseaseModelService(HttpClient httpClient, IConfiguration config)
        {
            _httpClient = httpClient;
            _config = config;
        }

        public async Task<ExternalDiseaseModelResponse> PredictDiseaseAsync(IFormFile image)
        {
            // Convert image to bytes
            using var memoryStream = new MemoryStream();
            await image.CopyToAsync(memoryStream);
            memoryStream.Position = 0;

            // Prepare multipart form data
            using var form = new MultipartFormDataContent();
            form.Add(new ByteArrayContent(memoryStream.ToArray()), "file", image.FileName);

            // Call external API
            var apiUrl = _config["ExternalApis:CropDiseaseModelApi"];
            var response = await _httpClient.PostAsync(apiUrl, form);

            if (!response.IsSuccessStatusCode)
            {
                // throw new HttpRequestException($"External API failed with status code: {response.StatusCode}");
                throw new BusinessException("Unable to detect disease. Please try again later", 503);
            }

            // Deserialize response
            var content = await response.Content.ReadAsStringAsync();
            var result = JsonSerializer.Deserialize<ExternalDiseaseModelResponse>(content);

            // return result ?? throw new InvalidOperationException("Failed to deserialize model response");
            if (result == null)
            {
                throw new BusinessException("Failed to process disease detection results", 500);
            }

            return result;
        }
    }
}
