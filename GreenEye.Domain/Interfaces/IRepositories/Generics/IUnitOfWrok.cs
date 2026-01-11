using GreenEye.Domain.Entities;

namespace GreenEye.Domain.Interfaces.IRepositories.Generics
{
    public interface IUnitOfWrok : IDisposable
    {
        IGenericRepository<OTP> Otps {get;}
        IGenericRepository<TempUser> TempUsers {get;}

        Task BeginTransactionAsync();
        Task CommitAsync();
        Task RollbackAsync();

        Task CompleteAsync();
    }
}
