using GreenEye.Domain.Entities;
using GreenEye.Domain.Interfaces.IRepositories;
using GreenEye.Infrastructure.Data;
using Microsoft.EntityFrameworkCore.Storage;

namespace GreenEye.Infrastructure.Repositories
{
    public class UnitOfWork(AppDbContext _context) : IUnitOfWrok
    {
        private IGenericRepository<OTP>? OtpRepository;
        private IGenericRepository<TempUser>? TempUserRepo;

        private IDbContextTransaction? _transaction;

        public IGenericRepository<OTP> Otps => OtpRepository ?? new GenericRepository<OTP>(_context);
        public IGenericRepository<TempUser> TempUsers => TempUserRepo ?? new GenericRepository<TempUser>(_context);

        public async Task BeginTransactionAsync()
        {
            if (_transaction == null)
                _transaction = await _context.Database.BeginTransactionAsync();
        }

        public async Task CommitAsync()
        {
            await _context.SaveChangesAsync();

            if (_transaction != null)
            {
                await _transaction.CommitAsync();
                await _transaction.DisposeAsync();
                _transaction = null;
            }
        }

        public async Task RollbackAsync()
        {
            if (_transaction != null)
            {
                await _transaction.RollbackAsync();
                await _transaction.DisposeAsync();
                _transaction = null;
            }
        }

        public async Task CompleteAsync() => await _context.SaveChangesAsync();
        
        public void Dispose()
        {
            _context.Dispose();
            _transaction?.Dispose();
        }
       
    }
}
