using GreenEye.Domain.Entities;

namespace GreenEye.Domain.IRepositories
{
    public interface IUnitOfWrok : IDisposable
    {
        IGenericRepository<OTP> Otps {get;}

        Task CompleteAsync();
    }
}
