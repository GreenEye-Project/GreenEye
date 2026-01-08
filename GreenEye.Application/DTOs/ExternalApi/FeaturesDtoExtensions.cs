using GreenEye.Application.DTOs.ExternalData;

namespace GreenEye.Application.DTOs.ExternalApi
{
    public static class FeaturesDtoExtensions
    {
        public static FeaturesDto FillNulls(this FeaturesDto dto, double defaultValue = 0) {
            if (dto == null) return null;


            dto.year ??= (int)defaultValue;
            dto.month ??= (int)defaultValue;
            dto.sand ??= defaultValue;
            dto.silt ??= defaultValue;
            dto.clay ??= defaultValue;
            dto.soc ??= defaultValue;
            dto.ph ??= defaultValue;
            dto.bdod ??= defaultValue;
            dto.cec ??= defaultValue;
            dto.ndvi ??= defaultValue;
            dto.t2m_c ??= defaultValue;
            dto.td2m_c ??= defaultValue;
            dto.rh_pct ??= defaultValue;
            dto.tp_m ??= defaultValue;
            dto.ssrd_jm2 ??= defaultValue;
            dto.lc_type1 ??= defaultValue;
            dto.nitrogen ??= defaultValue;
            dto.phosphorus ??= defaultValue;
            dto.potassium ??= defaultValue;
            return dto;
            
        }
    }
}
