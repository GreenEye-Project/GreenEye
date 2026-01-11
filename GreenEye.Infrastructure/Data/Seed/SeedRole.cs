using GreenEye.Domain.Enums;
using Microsoft.AspNetCore.Identity;

namespace GreenEye.Infrastructure.Data.Seed
{
    public static class SeedRole
    {
        public async static Task SeedRoleAsync(RoleManager<IdentityRole> roleManager) 
        {
            var roles = Enum.GetNames(typeof(Roles));

            foreach(var role in roles)
            {
                if (!await roleManager.RoleExistsAsync(role))
                {
                    await roleManager.CreateAsync(new IdentityRole(role));
                }
            }
            
        }
    }
}
