using GreenEye.Application.DTOs.Classification;
using GreenEye.Application.DTOs.ExternalApi;
using GreenEye.Application.Exceptions;
using GreenEye.Application.IServices.Classification;
using Microsoft.Extensions.Configuration;
using System.Net.Http.Json;
using System.Text.Json;

namespace GreenEye.Application.Services.Classification
{
    public class ClassificationService : IClassificationService
    {

        private readonly IExternalApiService _externalApiService;
        private readonly HttpClient _httpClient;
        private readonly IConfiguration _configuration;

        public ClassificationService(
            IExternalApiService externalApiService,
            HttpClient httpClient,
            IConfiguration configuration)
        {
            _externalApiService = externalApiService;
            _httpClient = httpClient;
            _configuration = configuration;
        }

        public async Task<ClassificationResponse?> GetClassificationAsync(double longitude, double latitude)
        {
            var externalData = await _externalApiService.GetExternalData(longitude, latitude);

            if (externalData == null)
                throw new BusinessException("Failed to load location data!");

            var classificationModelResponse = await _httpClient.PostAsJsonAsync(_configuration["ExternalApis:ClassificationModelApi"], externalData.Features.FillNulls());

            if (!classificationModelResponse.IsSuccessStatusCode) 
                throw new BusinessException("Failed to predict!");

            var content = await classificationModelResponse.Content.ReadAsStringAsync();
            var result = new ClassificationResponse();

            result = JsonSerializer.Deserialize<ClassificationResponse>(content);
            result!.MetaData = externalData.Metadata;
            #region cureentAndOptimalData
            //needs to be compared 
            //result.CurrentData = externalData.Features;

            // to set the optimal data for region

            //bool exist = result.optimalExists;
            //setOptimalData(ref exist, result.optimalData, longitude, latitude);
            //result.optimalExists = exist;
            #endregion

            return result;
        }

        //private void setOptimalData(ref bool optimalFound, OptimalRegionData obj, double longitude, double latitude)
        //{
        //    if ((latitude > 30 && latitude <= 31.6) && (longitude >= 30.5 && longitude <= 32.5))
        //    {
        //        obj.SocMin = 15;
        //        obj.SocMax = 25;
                
        //        obj.SandMin = 5;
        //        obj.SandMax = 20;
                
        //        obj.SiltMin = 25;
        //        obj.SiltMax = 40;
                
        //        obj.ClayMin = 40;
        //        obj.ClayMax = 60;
                
        //        obj.PhMin = 7.5f;
        //        obj.PhMax = 8.5f;
                
        //        obj.CecMin = 25;
        //        obj.CecMax = 45;
                
        //        obj.BdodMin = 1.2f;
        //        obj.BdodMax = 1.5f;
                
        //        obj.NitrogenMin = .12f;
        //        obj.NitrogenMax = .25f;
                
        //        obj.PhosphorusMin = 10;
        //        obj.PhosphorusMax = 25;
                
        //        obj.PotassiumMin = 200;
        //        obj.PotassiumMax = 500;
                
        //        obj.NdviMin = .3f;
        //        obj.NdviMax = 1.5f;
        //    }
        //    else if((latitude >= 24 && latitude <= 30) && (longitude >= 30 && longitude <= 32))
        //    {
        //        obj.SocMin = 10;
        //        obj.SocMax = 20;

        //        obj.SandMin = 15;
        //        obj.SandMax = 30;

        //        obj.SiltMin = 30;
        //        obj.SiltMax = 45;

        //        obj.ClayMin = 30;
        //        obj.ClayMax = 45;

        //        obj.PhMin = 7.3f;
        //        obj.PhMax = 8.2f;

        //        obj.CecMin = 18;
        //        obj.CecMax = 35;

        //        obj.BdodMin = 1.3f;
        //        obj.BdodMax = 1.6f;

        //        obj.NitrogenMin = 0.08f;
        //        obj.NitrogenMax = 0.18f;

        //        obj.PhosphorusMin = 8;
        //        obj.PhosphorusMax = 20;

        //        obj.PotassiumMin = 150;
        //        obj.PotassiumMax = 300;

        //        obj.NdviMin = 0.2f;
        //        obj.NdviMax = 0.6f;
        //    }
        //    else if ((latitude >= 22 && latitude <= 30) && (longitude >= 25 && longitude < 30))
        //    {
        //        obj.SocMin = 1;
        //        obj.SocMax = 5;

        //        obj.SandMin = 70;
        //        obj.SandMax = 90;

        //        obj.SiltMin = 5;
        //        obj.SiltMax = 15;

        //        obj.ClayMin = 1;
        //        obj.ClayMax = 10;

        //        obj.PhMin = 7.8f;
        //        obj.PhMax = 9.0f;

        //        obj.CecMin = 3;
        //        obj.CecMax = 10;

        //        obj.BdodMin = 1.5f;
        //        obj.BdodMax = 1.8f;

        //        obj.NitrogenMin = 0.01f;
        //        obj.NitrogenMax = 0.05f;

        //        obj.PhosphorusMin = 2;
        //        obj.PhosphorusMax = 8;

        //        obj.PotassiumMin = 50;
        //        obj.PotassiumMax = 150;

        //        obj.NdviMin = 0.0f;
        //        obj.NdviMax = 0.2f;
        //    }
        //    else if((latitude >= 27.5 && latitude <= 31) && (longitude >= 32.0 && longitude <= 35.0))
        //    {
        //        obj.SocMin = 2;
        //        obj.SocMax = 7;

        //        obj.SandMin = 60;
        //        obj.SandMax = 80;

        //        obj.SiltMin = 10;
        //        obj.SiltMax = 25;

        //        obj.ClayMin = 5;
        //        obj.ClayMax = 15;

        //        obj.PhMin = 7.5f;
        //        obj.PhMax = 8.8f;

        //        obj.CecMin = 4;
        //        obj.CecMax = 12;

        //        obj.BdodMin = 1.4f;
        //        obj.BdodMax = 1.7f;

        //        obj.NitrogenMin = 0.02f;
        //        obj.NitrogenMax = 0.06f;

        //        obj.PhosphorusMin = 3;
        //        obj.PhosphorusMax = 10;

        //        obj.PotassiumMin = 60;
        //        obj.PotassiumMax = 180;

        //        obj.NdviMin = 0.05f;
        //        obj.NdviMax = 0.3f;
        //    }
        //    else if((latitude > 31 && latitude <= 31.6) && (longitude >= 25 && longitude <= 33))
        //    {
        //        obj.SocMin = 5;
        //        obj.SocMax = 12;

        //        obj.SandMin = 40;
        //        obj.SandMax = 70;

        //        obj.SiltMin = 20;
        //        obj.SiltMax = 35;

        //        obj.ClayMin = 10;
        //        obj.ClayMax = 25;

        //        obj.PhMin = 7.8f;
        //        obj.PhMax = 8.5f;

        //        obj.CecMin = 10;
        //        obj.CecMax = 25;

        //        obj.BdodMin = 1.2f;
        //        obj.BdodMax = 1.5f;

        //        obj.NitrogenMin = 0.04f;
        //        obj.NitrogenMax = 0.10f;

        //        obj.PhosphorusMin = 5;
        //        obj.PhosphorusMax = 15;

        //        obj.PotassiumMin = 120;
        //        obj.PotassiumMax = 250;

        //        obj.NdviMin = 0.1f;
        //        obj.NdviMax = 0.4f;
        //    }
        //    else
        //    {
        //        optimalFound = false;
        //    }
            
        //}
    }
}
