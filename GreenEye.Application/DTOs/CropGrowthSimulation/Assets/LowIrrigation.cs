using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Text.Json.Serialization;
using System.Threading.Tasks;

namespace GreenEye.Application.DTOs.CropGrowthSimulation.Assets
{
    public class LowIrrigation
    {
        [JsonPropertyName("yield")]
        public decimal Yield {  get; set; }
        [JsonPropertyName("change_pct")]
        public decimal ChangePCT {  get; set; }

    }
}
