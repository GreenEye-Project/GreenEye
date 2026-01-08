using System.Linq.Expressions;

namespace GreenEye.Domain.IRepositories
{
    public interface IGenericRepository<T> where T : class
    {
        Task AddAsync(T entity);
        Task AddRangeAsync(IEnumerable<T> entities);

        void UpdateAsync(T entity);

        Task DeleteAsync(object id);

        Task<IEnumerable<T>> GetAllAsync();

        Task<T?> GetByIdAsync(object id);

        Task<T?> FindAsync(Expression<Func<T, bool>> predicate);

        Task<T?> FindAsync(Expression<Func<T, bool>> predicate, string[] includes);
    }
}
