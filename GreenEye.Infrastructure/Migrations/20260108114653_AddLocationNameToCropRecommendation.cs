using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace GreenEye.Infrastructure.Migrations
{
    /// <inheritdoc />
    public partial class AddLocationNameToCropRecommendation : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<string>(
                name: "LocationName",
                table: "CropRecommendationResults",
                type: "nvarchar(max)",
                nullable: true);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "LocationName",
                table: "CropRecommendationResults");
        }
    }
}
