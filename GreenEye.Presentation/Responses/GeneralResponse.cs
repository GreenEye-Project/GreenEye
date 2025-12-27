namespace GreenEye.Presentation.Response
{
    public class GeneralResponse<T>
    {
        public bool IsSuccess { get; set; }
        public string? Message { get; set; }
        public T? Data { get; set; }
    }

    // Non-generic version for void responses
    public class GeneralResponse
    {
        public bool IsSuccess { get; set; }
        public string? Message { get; set; }
    }
}


