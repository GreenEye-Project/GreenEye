using AutoMapper;
using GreenEye.Application.DTOs.AuthDtos.OtpDtos;
using GreenEye.Application.DTOs.PlantDisease;
using GreenEye.Domain.Entities;
using GreenEye.Domain.Entities.PlantDisease;

namespace GreenEye.Application.Mapping
{
    public class MappingProfile : Profile
    {
        public MappingProfile()
        {
            CreateMap<AddOtpDto, OTP>();
            CreateMap<CropDisease, CropDiseaseHistoryDto>();
            CreateMap<CropDisease, CropDiseaseModelResponseDto>();

        }
    }
}
