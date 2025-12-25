using GreenEye.Infrastructure.DependancyInjection;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.

builder.Services.AddControllers().ConfigureApiBehaviorOptions(x => x.SuppressModelStateInvalidFilter = true);

builder.Services.AddSwaggerGen();

builder.Services.AddInfrastructureService(builder.Configuration);

var app = builder.Build();

app.UseSwagger();
app.UseSwaggerUI();

app.UseHttpsRedirection();

app.UseAuthorization();

app.MapControllers();

app.Run();
