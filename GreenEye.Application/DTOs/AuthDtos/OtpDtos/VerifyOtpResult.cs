namespace GreenEye.Application.DTOs.AuthDtos.OtpDtos
{
    public class VerifyOtpResult<T>
    {
        public string? Message { get; set; }
        public T? Data { get; set; }
    }
}
