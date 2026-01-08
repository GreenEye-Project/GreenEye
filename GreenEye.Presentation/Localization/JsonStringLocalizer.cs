using Microsoft.Extensions.Caching.Distributed;
using Microsoft.Extensions.Localization;
using Newtonsoft.Json;

namespace GreenEye.Presentation.Localization
{
    public class JsonStringLocalizer(IDistributedCache _cache) : IStringLocalizer
    {
        private readonly JsonSerializer _serializer = new();

        public LocalizedString this[string name]
        {
            get
            {
                var value = GetString(name);
                // name => key, value => key النص المترجم اللي بيحمله ال  
                return new LocalizedString(name, value);
            }
        }

        public LocalizedString this[string name, params object[] arguments] 
        {
            get
            {
                var actualValue = this[name];
                return !actualValue.ResourceNotFound ? new LocalizedString(name, string.Format(actualValue.Value, arguments)) : actualValue;
            }
        }

        public IEnumerable<LocalizedString> GetAllStrings(bool includeParentCultures)
        {
            var filePath = $"Resourses/{Thread.CurrentThread.CurrentCulture.Name}.json";

            using FileStream fileStream = new FileStream(filePath, FileMode.Open, FileAccess.Read, FileShare.Read);
            using StreamReader streamReader = new StreamReader(fileStream);
            using JsonTextReader reader = new JsonTextReader(streamReader);

            while (reader.Read())
            {
                if (reader.TokenType != JsonToken.PropertyName)
                    continue;

                var key = reader.Value as string;
                reader.Read();
                var value = _serializer.Deserialize<string>(reader);

                yield return new LocalizedString(key!, value!);
            }
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
                    return _serializer.Deserialize<string>(reader)!;
                }
            }

            return string.Empty;
        }
    }
}
