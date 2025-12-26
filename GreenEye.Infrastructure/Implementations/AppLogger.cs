using GreenEye.Domain.Interfaces;

namespace GreenEye.Infrastructure.Implementations
{
    public class AppLogger<T>(IAppLogger<T> _logger) : IAppLogger<T>
    {
        public void Debuge(string message) => _logger.Debuge(message);

        public void Error(string message, Exception? exception = null) => _logger.Error(message, exception);
       
        public void Information(string message) => _logger.Information(message);
       
    }
}
