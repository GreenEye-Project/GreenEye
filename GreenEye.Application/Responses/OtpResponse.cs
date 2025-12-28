namespace GreenEye.Application.Responses
{
    public class OtpResponse
    {
        public bool Sent { get; set; }
        public DateTime ExpireAt { get; set; }
    }
}
