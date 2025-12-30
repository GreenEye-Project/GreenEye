using GreenEye.Application.Exceptions;
using GreenEye.Application.IServices;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Http;

namespace GreenEye.Infrastructure.Implementations
{
    public class ImageService : IImageService
    {
        private readonly IWebHostEnvironment _webHostEnvironment;
        private readonly string _uploadsFolder;

        public ImageService(IWebHostEnvironment webHostEnvironment)
        {
            _webHostEnvironment = webHostEnvironment;
            _uploadsFolder = Path.Combine(_webHostEnvironment.WebRootPath, "uploads");

            // Create uploads directory if not exists
            if (!Directory.Exists(_uploadsFolder))
                Directory.CreateDirectory(_uploadsFolder);
        }

        public async Task<string> UploadImageAsync(IFormFile image, string folderName)
        {
            if (image == null || image.Length == 0)
                throw new BusinessException("Please upload a valid image file", 400);

            // Validate file extension
            var allowedExtensions = new[] { ".jpg", ".jpeg", ".png", ".gif", ".bmp" };
            var extension = Path.GetExtension(image.FileName).ToLowerInvariant();

            if (!allowedExtensions.Contains(extension))
                throw new BusinessException("Invalid image format. Allowed formats: jpg, jpeg, png, gif, bmp", 400);

            // Create folder if not exists
            var folderPath = Path.Combine(_uploadsFolder, folderName);
            if (!Directory.Exists(folderPath))
                Directory.CreateDirectory(folderPath);

            // Generate unique filename
            var fileName = $"{Guid.NewGuid()}{extension}";
            var filePath = Path.Combine(folderPath, fileName);

            // Save image
            using (var stream = new FileStream(filePath, FileMode.Create))
            {
                await image.CopyToAsync(stream);
            }

            // Return relative path for database
            return $"/uploads/{folderName}/{fileName}";
        }


        public Task<bool> DeleteImageAsync(string imageUrl)
        {
            if (string.IsNullOrEmpty(imageUrl))
                return Task.FromResult(false);

            try
            {
                var filePath = Path.Combine(_webHostEnvironment.WebRootPath, imageUrl.TrimStart('/'));

                if (File.Exists(filePath))
                {
                    File.Delete(filePath);
                    return Task.FromResult(true);
                }

                return Task.FromResult(false);
            }
            catch
            {
                // Silent fail for delete operations
                return Task.FromResult(false);
            }
        }
    }
}
