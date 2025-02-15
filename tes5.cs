using Newtonsoft.Json.Linq;
using DotSpatial.Projections;

class Program
{
    static void Main()
    {
        string filePath = "/home/fran/dev_projects/csharp/utm_again/utm_zone_11_points.json";
        string jsonContent = File.ReadAllText(filePath);
        JObject geoJson = JObject.Parse(jsonContent);

        foreach (var feature in geoJson["features"])
        {
            int epsgCode = (int)feature["properties"]["epsg_code"];
            double easting = (double)feature["properties"]["utm_easting"];
            double northing = (double)feature["properties"]["utm_northing"];

            double[] latLon = ConvertUtmToLatLon(easting, northing, epsgCode);
            Console.WriteLine($"ID: {feature["properties"]["id"]}, Name: {feature["properties"]["name"]}, Latitude: {latLon[1]}, Longitude: {latLon[0]}");
        }
    }

    static double[] ConvertUtmToLatLon(double easting, double northing, int epsgCode)
    {
        // Determine the UTM zone from the EPSG code
        int zone = epsgCode % 100;
        bool isNorthernHemisphere = epsgCode < 32700;

        // Determine the correct UTM projection string
        string hemisphereFlag = isNorthernHemisphere ? "+no_defs" : "+south +no_defs";

        // Construct the UTM projection using the correct zone and hemisphere
        ProjectionInfo utmProjection = ProjectionInfo.FromProj4String(
            $"+proj=utm +zone={zone} +datum=WGS84 +units=m {hemisphereFlag}"
        );

        ProjectionInfo wgs84 = KnownCoordinateSystems.Geographic.World.WGS1984;
        double[] coordinates = { easting, northing };

        Reproject.ReprojectPoints(coordinates, null, utmProjection, wgs84, 0, 1);
        return coordinates; // { Longitude, Latitude }
    }
}
