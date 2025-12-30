using Microsoft.AspNetCore.Http;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace GreenEye.Application.IServices
{
    public interface IImageService
    {
        Task<string> UploadImageAsync(IFormFile image, string folderName);
        Task<bool> DeleteImageAsync(string imageUrl);

    }
}
