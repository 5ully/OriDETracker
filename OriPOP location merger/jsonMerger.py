import json
from RulesData import check_rules, connection_rules  # Import access rules and connection rules
from mapdata import check_locations  # Import location rules

# Helper function to parse map location into the desired format
def parse_map_location(map_entry):
    location_info = map_entry[0].split(", ")
    return {
        "map": location_info[0],
        "x": int(location_info[1]),
        "y": int(location_info[2])
    }

# Helper function to format access rules with tags (difficulty levels)
def format_access_rules(rules):
    access_rules = []
    for difficulty, conditions in rules.items():
        for condition in conditions:
            formatted_condition = ", ".join(
                f"{item[0]}:{item[1]}" if isinstance(item, tuple) else item
                for item in condition
            )
            access_rules.append(f"{formatted_condition}, {difficulty.capitalize()}")
    return access_rules

# Function to create structured JSON for connection rules with access rules in @parent/child format
def create_connection_data(connection_data):
    result = []
    for area, connections in connection_data.items():
        # Initialize the area as a connection item
        area_dict = {
            "name": f"{area}Connection",
            "access_rules": [] if area in ["TeleporterNetwork", "SunkenGladesRunaway"] else [f"@{area}Connection/{conn}Connection" for conn in connections.keys()],
            "children": []
        }
        
        for connection, rules in connections.items():
            # Create each connection with its respective access rules
            connection_dict = {
                "name": f"{connection}Connection",
                "access_rules": format_access_rules(rules)
            }
            area_dict["children"].append(connection_dict)

        if area_dict["children"]:
            result.append(area_dict)
    
    return result

# Function to convert main location and map data into the JSON structure
def transform_to_json(connection_data, location_data):
    result = []

    for area, connections in connection_data.items():
        area_dict = {
            "name": area,
            "access_rules": [f"@{area}"+"Connection"],
            "children": []
        }

        for connection, rules in connections.items():
            connection_dict = {
                "name": connection,
                "sections": [{"name": ""}],
                "access_rules": format_access_rules(rules),
                "map_locations": []
            }

            if area in location_data and connection in location_data[area]:
                for map_entry in location_data[area][connection].get("map", []):
                    connection_dict["map_locations"].append(parse_map_location(map_entry))

            if connection_dict["access_rules"] or connection_dict["map_locations"]:
                area_dict["children"].append(connection_dict)

        if area_dict["children"]:
            result.append(area_dict)
    
    # Wrapping the structure under "Nibel"
    nibel_structure = [{
        "name": "Nibel",
        "children": result
    }]

    return nibel_structure

# Transform the main data by merging access rules and map data
main_data = transform_to_json(check_rules, check_locations)

# Add the structured connection data based on connection_rules with access rules for connections
connection_data = create_connection_data(connection_rules)

# Combine main data and connection data under a single top-level array
final_output = main_data + connection_data

# Output the result as a JSON file
with open('locations.json', 'w') as json_file:
    json.dump(final_output, json_file, indent=4)

print("Transformation complete! Output saved to locations.json")
