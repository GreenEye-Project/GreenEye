using AutoMapper;
using GreenEye.Application.DTOs.OtpDtos;
using GreenEye.Domain.Entities;

namespace GreenEye.Application.Mapping
{
    public class MappingProfile : Profile
    {
        public MappingProfile()
        {
            CreateMap<AddOtpDto, OTP>();
        }
    }
}
