namespace GreenEye.Domain.Interfaces
{
    public interface IAppLogger<T>
    {
        void Information(string message);

        void Debug(string message);

        void Error(string message, Exception? exception = null);

    }
}
