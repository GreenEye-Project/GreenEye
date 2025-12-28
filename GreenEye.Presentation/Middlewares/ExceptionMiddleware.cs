using GreenEye.Application.Exceptions;
using GreenEye.Domain.Interfaces;
using GreenEye.Presentation.Responses;

namespace GreenEye.Presentation.Middlewares
{
    public class ExceptionMiddleware(RequestDelegate _next, IAppLogger<ExceptionMiddleware> _logger)
    {
        public async Task Invoke(HttpContext context)
        {
            try
            {
                await _next(context);
                _logger.Information("");
            }
            catch (BusinessException ex)
            {
                context.Response.StatusCode = ex.StatusCode;
                context.Response?.WriteAsJsonAsync(new
                {
                    Message = ex.Message,
                });
            }
            catch(Exception ex)
            {
                _logger.Error("Unhandled exception", ex);

                context.Response.StatusCode = StatusCodes.Status500InternalServerError;
                await context.Response.WriteAsJsonAsync( new
                {
                    Message = "Something went wrong. Please try again later."
                });
            }
        }
    }
}
