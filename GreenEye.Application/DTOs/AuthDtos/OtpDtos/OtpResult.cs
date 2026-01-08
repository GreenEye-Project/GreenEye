namespace GreenEye.Application.DTOs.AuthDtos.OtpDtos
{
    public class OtpResult
    {
        public bool Sent { get; set; }
        public DateTime ExpireAt { get; set; }
    }
}
