using System.Net.Http.Json;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.IO;
using Newtonsoft.Json;
using NetTopologySuite.Geometries;

var areaData = JsonConvert.DeserializeObject<Dictionary<string, dynamic>>(File.ReadAllText("areas.json"));
var questionsData = JsonConvert.DeserializeObject<Dictionary<string, dynamic>>(File.ReadAllText("questions.json"));
var indicatorsData = JsonConvert.DeserializeObject<Dictionary<string, dynamic>>(File.ReadAllText("indicators.json"));
var badsData = JsonConvert.DeserializeObject<Dictionary<string, dynamic>>(File.ReadAllText("bads.json"));

var areas = new List<Dictionary<string, object>>();

foreach (var feature in areaData["features"])
{
    string areaName = feature["properties"]["name"].ToString();
    var questions = feature["questionss"];
    var relevantIndicators = new HashSet<string>();
    Console.WriteLine($"\nProcessing {areaName}");

    foreach (var q in questions)
    {
        string qStr = q.ToString();
        if (questionsData.ContainsKey(qStr))
        {
            var indicators = questionsData[qStr]["indicators"];
            Console.WriteLine($"  questions {q} -> Adding Indicators: {string.Join(", ", indicators)}");
            foreach (var ind in indicators)
            {
                relevantIndicators.Add(ind.ToString());
            }
        }
    }

    var coordinates = feature["geometry"]["coordinates"][0];
    var polygonCoordinates = new List<Coordinate>();
    foreach (var coord in coordinates)
    {
        polygonCoordinates.Add(new Coordinate((double)coord[0], (double)coord[1]));
    }
    var polygon = new Polygon(new LinearRing(polygonCoordinates.ToArray()));

    var indicatorsDict = new Dictionary<string, Dictionary<string, object>>();
    foreach (var ind in relevantIndicators)
    {
        indicatorsDict[ind] = JsonConvert.DeserializeObject<Dictionary<string, object>>(JsonConvert.SerializeObject(indicatorsData[ind]));
    }

    areas.Add(new Dictionary<string, object>
            {
                { "name", areaName },
                { "polygon", polygon },
                { "indicators", indicatorsDict },
                { "status", new Dictionary<string, Dictionary<string, object>>() }
            });
}

foreach (var area in areas)
{
    Console.WriteLine(area["name"]);
    var counts = new Dictionary<string, int>();

    foreach (var obj in badsData["features"])
    {
        string objType = obj["properties"]["type"].ToString();
        var objPoint = new Point((double)obj["geometry"]["coordinates"][0], (double)obj["geometry"]["coordinates"][1]);

        if (((Polygon)area["polygon"]).Contains(objPoint))
        {
            if (!counts.ContainsKey(objType))
            {
                counts[objType] = 0;
            }
            counts[objType]++;
        }
    }

    var statusDict = (Dictionary<string, Dictionary<string, object>>)area["status"];
    foreach (var entry in (Dictionary<string, Dictionary<string, object>>)area["indicators"])
    {
        var indicator = entry.Value;
        int requiredCount = Convert.ToInt32(indicator["amount"]);
        string op = indicator["op"].ToString();
        string type = indicator["type"].ToString();
        int actualCount = counts.ContainsKey(type) ? counts[type] : 0;
        bool met = op switch
        {
            ">=" => actualCount >= requiredCount,
            ">" => actualCount > requiredCount,
            _ => false
        };

        statusDict[entry.Key] = new Dictionary<string, object>
                {
                    { "type", type },
                    { "required", requiredCount },
                    { "actual", actualCount },
                    { "met", met }
                };
    }
}

Console.WriteLine("\nResults:");
foreach (var area in areas)
{
    Console.WriteLine($"\nArea: {area["name"]}");
    foreach (var entry in (Dictionary<string, Dictionary<string, object>>)area["status"])
    {
        var status = entry.Value;
        Console.WriteLine($"  Indicator {entry.Key}: {status["type"]} (Required: {status["required"]}, Actual: {status["actual"]}) - {(Convert.ToBoolean(status["met"]) ? "✅ Met" : "❌ Not Met")}");
    }
    Console.WriteLine();
}
