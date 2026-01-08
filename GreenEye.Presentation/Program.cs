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

builder.Services.AddCors(options =>
{
    options.AddPolicy("AllowAll", policy =>
    {
        policy.AllowAnyOrigin() // هنسيبها لجميع الدومينات لحد ما نخلص وبعدين  نضيف دومين الفلاتر بس
              .AllowAnyMethod()
              .AllowAnyHeader();
    });
});

var app = builder.Build();

Log.Information("App Start");

app.UseSwagger();
app.UseSwaggerUI();

app.UseHttpsRedirection();

app.UseInfrastructure();

app.UseCors("AllowAll");

app.UseMiddleware<ExceptionMiddleware>();

app.UseAuthorization();

app.MapControllers();

app.Run();
