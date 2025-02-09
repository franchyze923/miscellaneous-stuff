using System;
using NetTopologySuite.CoordinateSystems;
using NetTopologySuite.CoordinateSystems.Transformations;

class Program
{
    static void Main()
    {
        // Create the coordinate system factory
        CoordinateSystemFactory csFactory = new CoordinateSystemFactory();

        // Define UTM Zone 11N (EPSG:32611)
        var utm32611 = csFactory.CreateFromWkt(@"PROJCS[""WGS 84 / UTM zone 11N"",
            GEOGCS[""WGS 84"", DATUM[""WGS_1984"", SPHEROID[""WGS 84"",6378137,298.257223563]],
            PRIMEM[""Greenwich"",0], UNIT[""degree"",0.0174532925199433]],
            PROJECTION[""Transverse_Mercator""], PARAMETER[""latitude_of_origin"",0],
            PARAMETER[""central_meridian"",-117], PARAMETER[""scale_factor"",0.9996],
            PARAMETER[""false_easting"",500000], PARAMETER[""false_northing"",0],
            UNIT[""metre"",1]]");

        // Define WGS84 (EPSG:4326)
        var wgs84 = csFactory.CreateGeographicCoordinateSystem("WGS 84");

        // Create transformation factory
        CoordinateTransformationFactory transformFactory = new CoordinateTransformationFactory();
        var transform = transformFactory.CreateFromCoordinateSystems(utm32611, wgs84);

        // Example UTM point (Easting, Northing)
        double[] utmPoint = { 500000, 3762155 }; // X, Y in UTM Zone 11N

        // Transform to WGS84
        double[] wgsPoint = transform.MathTransform.Transform(utmPoint);

        Console.WriteLine($"Converted Coordinates: Longitude = {wgsPoint[0]}, Latitude = {wgsPoint[1]}");
    }
}