using GreenEye.Domain.IRepositories;
using GreenEye.Infrastructure.Data;

namespace GreenEye.Infrastructure.Repositories
{
    public class UnitOfWork(AppDbContext _context) : IUnitOfWrok
    {
        public async Task CompleteAsync() => await _context.SaveChangesAsync();
        
        public void Dispose() => _context.Dispose();
       
    }
}
