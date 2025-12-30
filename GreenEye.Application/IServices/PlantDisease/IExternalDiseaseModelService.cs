using GreenEye.Application.Responses.PlantDisease;
using Microsoft.AspNetCore.Http;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace GreenEye.Application.IServices.PlantDisease
{
    public interface IExternalDiseaseModelService
    {
        Task<ExternalDiseaseModelResponse> PredictDiseaseAsync(IFormFile image);

    }
}
