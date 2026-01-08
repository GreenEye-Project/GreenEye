using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace GreenEye.Infrastructure.Migrations
{
    /// <inheritdoc />
    public partial class ChangeSsrdJm2ToDouble : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AlterColumn<double>(
                name: "SsrdJm2",
                table: "DesertificationForecasts",
                type: "float",
                nullable: false,
                oldClrType: typeof(long),
                oldType: "bigint");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AlterColumn<long>(
                name: "SsrdJm2",
                table: "DesertificationForecasts",
                type: "bigint",
                nullable: false,
                oldClrType: typeof(double),
                oldType: "float");
        }
    }
}
