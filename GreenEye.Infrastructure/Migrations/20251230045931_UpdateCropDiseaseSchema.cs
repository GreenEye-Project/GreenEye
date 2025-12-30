using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace GreenEye.Infrastructure.Migrations
{
    /// <inheritdoc />
    public partial class UpdateCropDiseaseSchema : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "PeakSeason",
                table: "CropDiseases");

            migrationBuilder.RenameColumn(
                name: "Remedy",
                table: "CropDiseases",
                newName: "Treatment");

            migrationBuilder.RenameColumn(
                name: "PredicatedDisease",
                table: "CropDiseases",
                newName: "DiseaseClass");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.RenameColumn(
                name: "Treatment",
                table: "CropDiseases",
                newName: "Remedy");

            migrationBuilder.RenameColumn(
                name: "DiseaseClass",
                table: "CropDiseases",
                newName: "PredicatedDisease");

            migrationBuilder.AddColumn<string>(
                name: "PeakSeason",
                table: "CropDiseases",
                type: "nvarchar(max)",
                nullable: true);
        }
    }
}
