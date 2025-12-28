using GreenEye.Infrastructure.DependancyInjection;
using GreenEye.Presentation.Middlewares;
using Serilog;

var builder = WebApplication.CreateBuilder(args);

// Serilog configuration in appsetting.json
builder.Host.UseSerilog((context, services, loggerConfig) =>
{
    loggerConfig
        .ReadFrom.Configuration(context.Configuration)
        .ReadFrom.Services(services)
        .Enrich.FromLogContext();
});

builder.Services.AddControllers().ConfigureApiBehaviorOptions(x => x.SuppressModelStateInvalidFilter = true);

builder.Services.AddSwaggerGen();

builder.Services.AddInfrastructureService(builder.Configuration);

var app = builder.Build();

Log.Information("App Start");

app.UseSwagger();
app.UseSwaggerUI();

app.UseHttpsRedirection();

app.UseInfrastructure();

app.UseMiddleware<ExceptionMiddleware>();

app.UseAuthorization();

app.MapControllers();

app.Run();
