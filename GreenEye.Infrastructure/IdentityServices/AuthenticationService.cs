using GreenEye.Infrastructure.IdentityModel;
using Microsoft.AspNetCore.Identity;

namespace GreenEye.Infrastructure.IdentityServices
{
    public class AuthenticationService(UserManager<ApplicationUser> _userManager)
    {
        public async Task RegisterAsync()
        {

        }
    }
}
