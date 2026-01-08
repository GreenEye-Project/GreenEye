using GreenEye.Domain.Interfaces.IRepositories.Generics;
using GreenEye.Infrastructure.Data;
using Microsoft.EntityFrameworkCore;
using System.Linq.Expressions;

namespace GreenEye.Infrastructure.Implementations.Repositories.Generics
{
    public class GenericRepository<T> : IGenericRepository<T> where T : class
    {
        //private readonly AppDbContext _context;
        private readonly DbSet<T> _dbSet;

        public GenericRepository(AppDbContext context)
        {
            //_context = context;
            _dbSet = context.Set<T>();
        }
        public async Task AddAsync(T entity) => await _dbSet.AddAsync(entity);

        public async Task AddRangeAsync(IEnumerable<T> entities) => await _dbSet.AddRangeAsync(entities);

        public async Task DeleteByIdAsync(object id)
        {
            var result = await _dbSet.FindAsync(id);
            if (result is not null)
                _dbSet.Remove(result);
        }

        public async Task DeleteAsync(Expression<Func<T, bool>> predicate)
        {
            var result = await FindAsync(predicate);
            if (result is not null)
                _dbSet.Remove(result);
        }

        public async Task<T?> FindAsync(Expression<Func<T, bool>> predicate) => await _dbSet.FirstOrDefaultAsync(predicate);

        public async Task<T?> FindAsync(Expression<Func<T, bool>> predicate, string[] includes)
        {
            IQueryable<T> query = _dbSet.Where(predicate);
            if(includes is not null)
            {
                foreach (var include in includes)
                    query.Include(include);
            }
            return await query.FirstOrDefaultAsync();
        }

        public async Task<IEnumerable<T>> GetAllAsync() => await _dbSet.AsNoTracking().ToListAsync();
        
        public async Task<T?> GetByIdAsync(object id) => await _dbSet.FindAsync(id);

        public void UpdateAsync(T entity) => _dbSet.Update(entity);
        
    }
}
