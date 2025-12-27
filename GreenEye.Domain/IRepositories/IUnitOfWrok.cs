namespace GreenEye.Domain.IRepositories
{
    public interface IUnitOfWrok : IDisposable
    {
        Task CompleteAsync();
    }
}
