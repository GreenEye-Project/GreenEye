using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace GreenEye.Domain.Entities.Forecasting
{
    public class DesertificationForecast
    {
        public int Id { get; set; }
        public double Latitude { get; set; }
        public double Longitude { get; set; }
        public string? LocationName { get; set; }

        // Forecast Details
        public int Year { get; set; }
        public int Month { get; set; }
        public double Ndvi { get; set; }
        public double T2mC { get; set; }
        public double Td2mC { get; set; }
        public double RhPct { get; set; }
        public double TpM { get; set; }
        public double SsrdJm2 { get; set; }
        public string? RiskLevel { get; set; }
        public double RiskConfidence { get; set; }

        // Metadata
        public DateTime CreatedAt { get; set; }
        public bool IsDeleted { get; set; } = false;
        public string? UserId { get; set; }
    }
}
