using AutoMapper;
using GreenEye.Application.DTOs.PlantDisease;
using GreenEye.Application.Exceptions;
using GreenEye.Application.IServices;
using GreenEye.Application.IServices.PlantDisease;
using GreenEye.Domain.Entities.PlantDisease;
using GreenEye.Domain.Interfaces.IRepositories;
using GreenEye.Domain.Interfaces.IRepositories.PlantDisease;
using Microsoft.AspNetCore.Http;

namespace GreenEye.Application.Services.PlantDisease
{
    public class CropDiseaseService : ICropDiseaseService
    {
        private readonly ICropDiseaseRepository _cropDiseaseRepository;
        private readonly IUnitOfWrok _unitOfWork;
        private readonly IImageService _imageService;
        private readonly IExternalDiseaseModelService _externalModelService;
        private readonly IMapper _mapper;

        public CropDiseaseService(
            ICropDiseaseRepository cropDiseaseRepository,
            IUnitOfWrok unitOfWork,
            IImageService imageService,
            IExternalDiseaseModelService externalModelService,
            IMapper mapper)
        {
            _cropDiseaseRepository = cropDiseaseRepository;
            _unitOfWork = unitOfWork;
            _imageService = imageService;
            _externalModelService = externalModelService;
            _mapper = mapper;
        }

        public async Task<CropDiseaseModelResponseDto> DetectDiseaseAsync(IFormFile image, string userId)
        {
            // Call External Model API
            var modelResult = await _externalModelService.PredictDiseaseAsync(image);

            // Upload Image
            var imagePath = await _imageService.UploadImageAsync(image, "crop-diseases");


            // Create Entity
            var cropDisease = new CropDisease
            {
                UserId = userId,
                ImageUrl = imagePath,
                DiseaseClass = modelResult.Class!,
                Cause = modelResult.Cause!,
                Treatment = modelResult.Treatment!,
                Confidence = modelResult.Confidence,
                SentAt = DateTime.Now,
                IsDeleted = false
            };

            // Save to Database
            await _cropDiseaseRepository.AddAsync(cropDisease);
            await _unitOfWork.CompleteAsync();

            
            // Map Entity to DTO using AutoMapper
            var response = _mapper.Map<CropDiseaseModelResponseDto>(cropDisease);

            return response;
        }

        public async Task<List<CropDiseaseHistoryDto>> GetUserHistoryAsync(string userId)
        {
            var history = await _cropDiseaseRepository.GetUserHistoryAsync(userId);
            var historyDtos = _mapper.Map<List<CropDiseaseHistoryDto>>(history);

            return historyDtos;
        }

        public async Task DeleteHistoryAsync(int historyId, string userId)
        {
            var historyItem = await _cropDiseaseRepository.GetUserHistoryItemAsync(historyId, userId);

            if (historyItem == null)
            {
                throw new BusinessException("History item not found or does not belong to you", 404);
            }

            // Soft Delete
            historyItem.IsDeleted = true;
            _cropDiseaseRepository.UpdateAsync(historyItem);
            await _unitOfWork.CompleteAsync();
        }
    }
}
