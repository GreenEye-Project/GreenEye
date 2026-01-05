using Microsoft.Extensions.Caching.Distributed;
using Microsoft.Extensions.Localization;
using Newtonsoft.Json;
using System.Runtime.Serialization;

namespace GreenEye.Presentation.Localization
{
    public class JsonStringLocalizer(IDistributedCache _cache) : IStringLocalizer
    {
        private readonly JsonSerializer _serilizer = new();

        public LocalizedString this[string name] => throw new NotImplementedException();

        public LocalizedString this[string name, params object[] arguments] => throw new NotImplementedException();

        public IEnumerable<LocalizedString> GetAllStrings(bool includeParentCultures)
        {
            throw new NotImplementedException();
        }

        private string GetString(string key)
        {
            var fileName = $"Resourses/{Thread.CurrentThread.CurrentCulture.Name}.json";
            var fullPath = Path.GetFullPath(fileName);


            if (File.Exists(fullPath))
            {
                var cacheKey = $"locale_{Thread.CurrentThread.CurrentCulture.Name}_key";
                var cacheValue = _cache.GetString(cacheKey);

                if (!string.IsNullOrEmpty(cacheValue))
                    return cacheValue;

                var result = GetFromJson(key, fullPath);
                if (!string.IsNullOrEmpty(result))
                    _cache.SetString(cacheKey, result);

                return result;
            }
            return string.Empty;
        }

        private string GetFromJson(string propertyName, string filePath)
        {
            if (string.IsNullOrEmpty(propertyName) || string.IsNullOrEmpty(filePath))
                return string.Empty;

            using FileStream fileStream = new FileStream(filePath, FileMode.Open, FileAccess.Read, FileShare.Read);
            using StreamReader streamReader = new StreamReader(fileStream);
            using JsonTextReader reader = new JsonTextReader(streamReader);

            while (reader.Read())
            {
                if(reader.TokenType == JsonToken.PropertyName && reader.Value as string == propertyName)
                {
                    reader.Read();
                    return _serilizer.Deserialize<string>(reader)!;
                }
            }

            return string.Empty;
        }
    }
}
