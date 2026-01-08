using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace GreenEye.Infrastructure.Migrations
{
    /// <inheritdoc />
    public partial class AddDesertificationForecast : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "DesertificationForecasts",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Latitude = table.Column<double>(type: "float", nullable: false),
                    Longitude = table.Column<double>(type: "float", nullable: false),
                    LocationName = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    Year = table.Column<int>(type: "int", nullable: false),
                    Month = table.Column<int>(type: "int", nullable: false),
                    Ndvi = table.Column<double>(type: "float", nullable: false),
                    T2mC = table.Column<double>(type: "float", nullable: false),
                    Td2mC = table.Column<double>(type: "float", nullable: false),
                    RhPct = table.Column<double>(type: "float", nullable: false),
                    TpM = table.Column<double>(type: "float", nullable: false),
                    SsrdJm2 = table.Column<long>(type: "bigint", nullable: false),
                    RiskLevel = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    RiskConfidence = table.Column<double>(type: "float", nullable: false),
                    CreatedAt = table.Column<DateTime>(type: "datetime2", nullable: false),
                    IsDeleted = table.Column<bool>(type: "bit", nullable: false),
                    UserId = table.Column<string>(type: "nvarchar(max)", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_DesertificationForecasts", x => x.Id);
                });
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "DesertificationForecasts");
        }
    }
}
