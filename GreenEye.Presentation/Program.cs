using GreenEye.Infrastructure.Data.Seed;
using GreenEye.Infrastructure.DependancyInjection;
using GreenEye.Presentation.Localization;
using GreenEye.Presentation.Middlewares;
using GreenEye.Presentation.Response;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Localization;
using Serilog;
using System.Globalization;
using System.Text.Json.Serialization;

var builder = WebApplication.CreateBuilder(args);

// Serilog configuration in appsetting.json
builder.Host.UseSerilog((context, services, loggerConfig) =>
{
    loggerConfig
        .ReadFrom.Configuration(context.Configuration)
        .ReadFrom.Services(services)
        .Enrich.FromLogContext();
});

#region Localization configuration
builder.Services.AddLocalization();

builder.Services.AddSingleton<IStringLocalizerFactory, JsonStringLocalizerFactorty>();

// تتغير بردك علي حسب اللغه بتاع البرنامج data annotation علشان ال 
builder.Services.AddMvc()
    .AddDataAnnotationsLocalization(options =>
    {
        // factory => create instant of  JsonStringLocalizer, type => language!!?
        options.DataAnnotationLocalizerProvider = (type, factory) => factory.Create(typeof(JsonStringLocalizerFactorty));
    });

builder.Services.Configure<RequestLocalizationOptions>(options =>
{
    var supportedCultures = new[]
    {
        new CultureInfo("en-US"),
        new CultureInfo("ar-EG")
    };

    options.DefaultRequestCulture = new Microsoft.AspNetCore.Localization.RequestCulture(culture: supportedCultures[0]);

    options.SupportedCultures = supportedCultures;
});
#endregion

builder.Services.AddControllers().ConfigureApiBehaviorOptions(x => x.SuppressModelStateInvalidFilter = true)
    // Convert enum number to string
    .AddJsonOptions(options =>
    {
        options.JsonSerializerOptions.Converters
            .Add(new JsonStringEnumConverter());
    });

// Static arch for auto model state
builder.Services.Configure<ApiBehaviorOptions>(options =>
{
    options.InvalidModelStateResponseFactory = context =>
    {
        var errors = context.ModelState
            .Where(x => x.Value!.Errors.Count > 0)
            .ToDictionary(
                x => x.Key,
                x => x.Value!.Errors.Select(e => e.ErrorMessage)
            );

        return new BadRequestObjectResult(
            new GeneralResponse<object>
            {
                IsSuccess = false,
                Message = "Validation error",
                Data = errors
            }
        );
    };
});

builder.Services.AddMemoryCache();

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

// Add Roles
await SeedRolesOnStartup(app);

Log.Information("App Start");

app.UseSwagger();
app.UseSwaggerUI();

app.UseHttpsRedirection();

app.UseInfrastructure();

app.UseCors("AllowAll");

app.UseMiddleware<ExceptionMiddleware>();

#region Localization Middleware
var supportedCultures = new[] { "en-US", "ar-EG" };
var localizationOptions = new RequestLocalizationOptions()
    .SetDefaultCulture(supportedCultures[0])
    .AddSupportedCultures(supportedCultures);

app.UseRequestLocalization(localizationOptions);
#endregion

app.UseAuthentication();
app.UseAuthorization();

app.MapControllers();

app.Run();

static async Task SeedRolesOnStartup(WebApplication app)
{
    using var scope = app.Services.CreateScope();
    var roleManager = scope.ServiceProvider
        .GetRequiredService<RoleManager<IdentityRole>>();

    await SeedRole.SeedRoleAsync(roleManager);
}