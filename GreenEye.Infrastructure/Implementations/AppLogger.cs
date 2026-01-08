using GreenEye.Domain.Interfaces;
using Serilog;

namespace GreenEye.Infrastructure.Implementations
{
    public class AppLogger<T> : IAppLogger<T>
    {
        private readonly ILogger _logger;

        public AppLogger()
        {
            // Log => serilog الخاص بال static entry point 
            // ForContext<T>() => ( class هيبقا معروف جاي من اي Log ال ) Type T بال Log بيربط ال 
            _logger = Log.ForContext<T>();
        }

        public void Debug(string message) => _logger.Debug(message);

        public void Error(string message, Exception? exception = null) => _logger.Error(message, exception);

        public void Information(string message) => _logger.Information(message);

    }
   
}
