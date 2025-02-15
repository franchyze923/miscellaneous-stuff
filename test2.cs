using Newtonsoft.Json.Linq;
using ProjNet.CoordinateSystems;
using ProjNet.CoordinateSystems.Transformations;

// dotnet add package ProjNet
class Program
{
    static void Main()
    {
        string filePath = "/home/fran/dev_projects/csharp/utm_again/utm_zone_11_points.json";
        string json = File.ReadAllText(filePath);
        JObject data = JObject.Parse(json);

        var wgs84 = GeographicCoordinateSystem.WGS84;
        var coordinateTransformationFactory = new CoordinateTransformationFactory();

        foreach (var feature in data["features"])
        {
            int utmZone = (int)feature["properties"]["utm_zone"];
            var utmZoneProj = ProjectedCoordinateSystem.WGS84_UTM(utmZone, true);
            var transform = coordinateTransformationFactory.CreateFromCoordinateSystems(utmZoneProj, wgs84);

            double utmEasting = (double)feature["properties"]["utm_easting"];
            double utmNorthing = (double)feature["properties"]["utm_northing"];
            double[] utmCoordinates = [utmEasting, utmNorthing];
            double[] latLonCoordinates = transform.MathTransform.Transform(utmCoordinates);

            feature["geometry"]["coordinates"] = new JArray(latLonCoordinates[0], latLonCoordinates[1]);
        }

        // Print the updated features
        foreach (var feature in data["features"])
        {
            Console.WriteLine($"ID: {feature["properties"]["id"]}, Name: {feature["properties"]["name"]}, Coordinates: {feature["geometry"]["coordinates"]}");
        }
    }
}
