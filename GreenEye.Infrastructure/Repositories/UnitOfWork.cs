using GreenEye.Domain.Entities;
using GreenEye.Domain.IRepositories;
using GreenEye.Infrastructure.Data;

namespace GreenEye.Infrastructure.Repositories
{
    public class UnitOfWork(AppDbContext _context) : IUnitOfWrok
    {
        private IGenericRepository<OTP>? OtpRepository;

        public IGenericRepository<OTP> Otps => OtpRepository ?? new GenericRepository<OTP>(_context);

        public async Task CompleteAsync() => await _context.SaveChangesAsync();
        
        public void Dispose() => _context.Dispose();
       
    }
}
