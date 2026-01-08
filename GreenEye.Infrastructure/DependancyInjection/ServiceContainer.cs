using GreenEye.Application.IServices;
using GreenEye.Application.IServices.Authentication;
using GreenEye.Application.IServices.PlantDisease;
using GreenEye.Application.Mapping;
using GreenEye.Application.Services;
using GreenEye.Application.Services.Authentication;
using GreenEye.Application.Services.PlantDisease;
using GreenEye.Domain.Interfaces;
using GreenEye.Domain.Interfaces.IRepositories;
using GreenEye.Domain.Interfaces.IRepositories.PlantDisease;
using GreenEye.Infrastructure.Data;
using GreenEye.Infrastructure.Entities.IdentityModel;
using GreenEye.Infrastructure.IdentityServices;
using GreenEye.Infrastructure.Implementations;
using GreenEye.Infrastructure.Repositories;
using GreenEye.Infrastructure.Repositories.PlantDisease;
using GreenEye.Infrastructure.Validation;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.IdentityModel.Tokens;
using Serilog;
using System.Text;

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

            services.AddIdentity<ApplicationUser, IdentityRole>(x => x.User.AllowedUserNameCharacters = null!)
                .AddUserValidator<UserValidation>()
                .AddEntityFrameworkStores<AppDbContext>()
                .AddDefaultTokenProviders();

            services.AddScoped(typeof(IAppLogger<>), typeof(AppLogger<>));

            services.AddScoped<IUnitOfWrok, UnitOfWork>();

            services.AddScoped<ICropDiseaseRepository, CropDiseaseRepository>();

            services.AddScoped<IImageService, ImageService>();
            services.AddScoped<IEmailService, EmailService>();
            services.AddScoped<ICropDiseaseService, CropDiseaseService>();
            services.AddScoped<IAuthenticationService, AuthenticationService>();
            services.AddScoped<IOtpService, OtpService>();
            services.AddHttpClient<IExternalDiseaseModelService, ExternalDiseaseModelService>();

            services.AddAutoMapper(cfg =>
            {
                cfg.AddProfile<MappingProfile>();
            });

            services.AddAuthentication(options =>
            {
                options.DefaultAuthenticateScheme = JwtBearerDefaults.AuthenticationScheme;
                options.DefaultChallengeScheme = JwtBearerDefaults.AuthenticationScheme;
                options.DefaultScheme = JwtBearerDefaults.AuthenticationScheme;
            }).AddJwtBearer(options =>
            {
                options.SaveToken = true;
                options.TokenValidationParameters = new TokenValidationParameters()
                {
                    ValidateAudience = true,
                    ValidateIssuer = true,
                    ValidateLifetime = true,
                    RequireExpirationTime = true,
                    ValidateIssuerSigningKey = true,
                    ValidAudience = configuration["JWTAuth:Audience"],
                    // Token دا اللي هيتفك بيه ال 
                    ValidIssuer = configuration["JWTAuth:Issuer"],
                    IssuerSigningKey = new SymmetricSecurityKey(
                        Encoding.UTF8.GetBytes(configuration["JWTAuth:Key"]!)),
                    ClockSkew = TimeSpan.FromMinutes(1)
                };
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

            app.UseAuthentication();

            return app;
        }
    }
}
