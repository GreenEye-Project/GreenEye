using System.Linq.Expressions;

namespace GreenEye.Domain.Interfaces.IRepositories.Generics
{
    public interface IGenericRepository<T> where T : class
    {
        Task AddAsync(T entity);
        Task AddRangeAsync(IEnumerable<T> entities);

        void UpdateAsync(T entity);

        Task DeleteByIdAsync(object id);

        Task DeleteAsync(Expression<Func<T, bool>> predicate);

        Task<IEnumerable<T>> GetAllAsync();

        Task<T?> GetByIdAsync(object id);

        Task<T?> FindAsync(Expression<Func<T, bool>> predicate);

        Task<T?> FindAsync(Expression<Func<T, bool>> predicate, string[] includes);
    }
}
