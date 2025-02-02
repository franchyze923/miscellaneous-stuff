import json
from shapely.geometry import Point, Polygon


with open("areas.json") as f:
    area_data = json.load(f)

with open("questions.json") as f:
    questions_data = json.load(f)

with open("indicators.json") as f:
    indicators_data = json.load(f)

with open("bads.json") as f:
    bads_data = json.load(f)

# Step 1: Build a structure for each area with its relevant indicators
areas = []
for area in area_data["features"]:
    area_name = area["properties"]["name"]
    questions = area["questions"]
    
    # Get relevant indicators from questions
    relevant_indicators = set()
    print(f"\nProcessing {area_name}")


    # Iterate over questions
    for q in questions:
        q_str = str(q) 
        if q_str in questions_data:
            indicators = questions_data[q_str].get("indicators", [])  # Ensure 'indicators' exists
            print(f"  q {q} -> Adding Indicators: {indicators}")
            relevant_indicators.update(indicators)            
    
    # Store in structured format
    areas.append({
        "name": area["properties"]["name"],
        "polygon": Polygon(area["geometry"]["coordinates"][0]),  # Convert to Shapely polygon
        "indicators": {str(ind): indicators_data[str(ind)] for ind in relevant_indicators}
    })

# Step 2: Process objects and count occurrences within each area
for area in areas:
    print(area["name"])
    counts = {}  # Track object counts by type
    for obj in bads_data["features"]:
        obj_type = obj["properties"]["type"]
        obj_point = Point(obj["geometry"]["coordinates"])

        # Check if object is inside the area
        if obj_point.within(area["polygon"]):
            counts[obj_type] = counts.get(obj_type, 0) + 1

    # Step 3: Check indicator conditions
    area["status"] = {}  # Store status of each indicator
    for ind_id, indicator in area["indicators"].items():
        required_count = indicator["amount"]
        actual_count = counts.get(indicator["type"], 0)
        
        # Check condition
        if indicator["op"] == ">=":
            met = actual_count >= required_count
        elif indicator["op"] == ">":
            met = actual_count > required_count
        else:
            met = False  # Unsupported operation
        
        area["status"][ind_id] = {
            "type": indicator["type"],
            "required": required_count,
            "actual": actual_count,
            "met": met
        }

# Step 4: Print or export results

print("\nResults:")
for area in areas:
    print(f"\narea: {area['name']}")
    for ind_id, status in area["status"].items():
        print(f"  Indicator {ind_id}: {status['type']} (Required: {status['required']}, Actual: {status['actual']}) - {' ✅ Met' if status['met'] else '❌ Not Met'}")
    print()