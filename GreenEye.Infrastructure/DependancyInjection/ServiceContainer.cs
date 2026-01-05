using GreenEye.Domain.Interfaces;
using GreenEye.Domain.IRepositories;
using GreenEye.Infrastructure.Data;
using GreenEye.Infrastructure.IdentityModel;
using GreenEye.Infrastructure.Implementations;
using GreenEye.Infrastructure.Repositories;
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

            services.AddScoped<IUnitOfWrok, UnitOfWork>();

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
