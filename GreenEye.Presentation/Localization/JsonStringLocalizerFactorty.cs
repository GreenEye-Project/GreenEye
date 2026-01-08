using Microsoft.Extensions.Caching.Distributed;
using Microsoft.Extensions.Localization;

namespace GreenEye.Presentation.Localization
{
    public class JsonStringLocalizerFactorty(IDistributedCache _cache) : IStringLocalizerFactory
    {
        public IStringLocalizer Create(Type resourceSource)
        {
            return new JsonStringLocalizer(_cache);
        }

        public IStringLocalizer Create(string baseName, string location)
        {
            return new JsonStringLocalizer(_cache);
        }
    }
}
