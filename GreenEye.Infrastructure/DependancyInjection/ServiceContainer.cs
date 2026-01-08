using GreenEye.Application.IServices;
using GreenEye.Application.IServices.CropRecommendation;
using GreenEye.Application.IServices.Forecasting;
using GreenEye.Application.IServices.PlantDisease;
using GreenEye.Application.Mapping;
using GreenEye.Application.Services.CropRecommendation;
using GreenEye.Application.Services.Forecasting;
using GreenEye.Application.Services.PlantDisease;
using GreenEye.Domain.Interfaces;
using GreenEye.Domain.IRepositories;
using GreenEye.Domain.IRepositories.CropRecommendation;
using GreenEye.Domain.IRepositories.Forecasting;
using GreenEye.Domain.IRepositories.PlantDisease;
using GreenEye.Infrastructure.Data;
using GreenEye.Infrastructure.IdentityModel;
using GreenEye.Infrastructure.Implementations;
using GreenEye.Infrastructure.Repositories;
using GreenEye.Infrastructure.Repositories.CropRecommendation;
using GreenEye.Infrastructure.Repositories.Forecasting;
using GreenEye.Infrastructure.Repositories.Forecasting;
using GreenEye.Infrastructure.Repositories.PlantDisease;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Serilog;

namespace GreenEye.Infrastructure.DependancyInjection
{
    public static class ServiceContainer
    {
        // static => ClassName.MethodName(not craete object of class)
        public static IServiceCollection AddInfrastructureService(this IServiceCollection services, IConfiguration configuration)
        {

            services.AddDbContext<AppDbContext>(options =>
            {
                options.UseSqlServer(
                    configuration.GetConnectionString("DefaultConnection"), 
                    sqloptions =>
                    {
                        // Known migrations in ServiceContainer class
                        sqloptions.MigrationsAssembly(typeof(ServiceContainer).Assembly);
                        // when failure occurred these method reconnect with database again
                        sqloptions.EnableRetryOnFailure();
                    }
                    );
            });

            services.AddIdentity<ApplicationUser, IdentityRole>()
                .AddEntityFrameworkStores<AppDbContext>()
                .AddDefaultTokenProviders();

            services.AddScoped(typeof(IAppLogger<>), typeof(AppLogger<>));

            // Unit of Work
            services.AddScoped<IUnitOfWrok, UnitOfWork>();

            // Repositories
            services.AddScoped<ICropDiseaseRepository, CropDiseaseRepository>();
            services.AddScoped<ICropDiseaseRepository, CropDiseaseRepository>();
            services.AddScoped<IDesertificationForecastRepository, DesertificationForecastRepository>();
            services.AddScoped<ICropRecommendationRepository, CropRecommendationRepository>();

            // Infrastructure Services
            services.AddScoped<IImageService, ImageService>();
            services.AddHttpClient<IExternalDiseaseModelService, ExternalDiseaseModelService>();
            services.AddHttpClient<IHistoryDataService, HistoryDataService>();
            services.AddHttpClient<IExternalDiseaseModelService, ExternalDiseaseModelService>();
            services.AddHttpClient<IHistoryDataService, HistoryDataService>();
            services.AddHttpClient<IForecastingModelService, ForecastingModelService>();
            services.AddHttpClient<IFeatureExtractionService, FeatureExtractionService>();
            services.AddHttpClient<ICropRecommendationModelService, CropRecommendationModelService>();

            // Application Services
            services.AddScoped<ICropDiseaseService, CropDiseaseService>();
            services.AddScoped<ICropDiseaseService, CropDiseaseService>();
            services.AddScoped<IForecastingService, ForecastingService>();
            services.AddScoped<ICropRecommendationService, CropRecommendationService>();


            services.AddAutoMapper(cfg =>
            {
                cfg.AddProfile<MappingProfile>();
            });

            return services;
        }
        
        // When you need add middleware in this layer
        public static IApplicationBuilder UseInfrastructure(this IApplicationBuilder app)
        {
            // Serilog ui
            app.UseSerilogRequestLogging(options =>
            {
                options.MessageTemplate =
                    "HTTP {RequestMethod} {RequestPath} responded {StatusCode} in {Elapsed:0.0000} ms";
            });


            return app;
        }
    }
}
