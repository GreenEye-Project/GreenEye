using GreenEye.Application.Exceptions;
using GreenEye.Domain.Interfaces;
using GreenEye.Presentation.Response;

namespace GreenEye.Presentation.Middlewares
{
    public class ExceptionMiddleware(RequestDelegate _next)
    {
        public async Task Invoke(HttpContext context, IAppLogger<ExceptionMiddleware> _logger)
        {
            try
            {
                await _next(context);
            }
            catch (BusinessException ex)
            {
                context.Response.StatusCode = ex.StatusCode;
                await context.Response.WriteAsJsonAsync(new GeneralResponse<string>
                {
                    IsSuccess = false,
                    Message = ex.Message,
                });
            }
            catch (Exception ex)
            {
                _logger.Error($"Unhandled exception: {ex.Message} \n{ex.StackTrace}", ex);

                context.Response.StatusCode = StatusCodes.Status500InternalServerError;
                await context.Response.WriteAsJsonAsync(new GeneralResponse<string>
                {
                    IsSuccess = false,
                    Message = "Something went wrong. Please try again later."
                });
            }
        }
    }
}
