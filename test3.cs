using Newtonsoft.Json.Linq;
using DotSpatial.Projections;


// dotnet add package DotSpatial.Projections
class Program
{
    static void Main()
    {
        string filePath = "/home/fran/dev_projects/csharp/utm_again/utm_zone_11_points.json";

        string jsonContent = File.ReadAllText(filePath);
        JObject geoJson = JObject.Parse(jsonContent);

        foreach (var feature in geoJson["features"])
        {
            int zone = (int)feature["properties"]["utm_zone"];
            double easting = (double)feature["properties"]["utm_easting"];
            double northing = (double)feature["properties"]["utm_northing"];

            double[] latLon = ConvertUtmToLatLon(easting, northing, zone);
            Console.WriteLine($"Latitude: {latLon[1]}, Longitude: {latLon[0]}");
        }
    }

    static double[] ConvertUtmToLatLon(double easting, double northing, int zone)
    {
        // Determine if the zone is in the Northern Hemisphere
        bool isNorthernHemisphere;
        if (zone <= 60)
        {
            isNorthernHemisphere = true;  // Zones 1-60 are in the Northern Hemisphere
        }
        else
        {
            isNorthernHemisphere = false; // Zones 61+ represent the Southern Hemisphere
        }

        // Determine the correct UTM projection string
        string hemisphereFlag;
        if (isNorthernHemisphere)
        {
            hemisphereFlag = "+no_defs";  // Northern Hemisphere (no extra flag needed)
        }
        else
        {
            hemisphereFlag = "+south +no_defs";  // Southern Hemisphere requires "+south"
        }

        // Construct the UTM projection using the correct zone and hemisphere
        ProjectionInfo utmProjection = ProjectionInfo.FromProj4String(
            $"+proj=utm +zone={zone % 60} +datum=WGS84 +units=m {hemisphereFlag}"
        );

        ProjectionInfo wgs84 = KnownCoordinateSystems.Geographic.World.WGS1984;
        double[] coordinates = { easting, northing };

        Reproject.ReprojectPoints(coordinates, null, utmProjection, wgs84, 0, 1);
        return coordinates; // { Longitude, Latitude }
    }
}
