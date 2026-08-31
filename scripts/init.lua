-- entry point for all lua code of the pack
-- more info on the lua API: https://github.com/black-sliver/PopTracker/blob/master/doc/PACKS.md#lua-interface
ENABLE_DEBUG_LOG = true
-- get current variant
local variant = Tracker.ActiveVariantUID
-- check variant info
IS_ITEMS_ONLY = variant:find("itemsonly")

print("-- Example Tracker --")
print("Loaded variant: ", variant)
if ENABLE_DEBUG_LOG then
    print("Debug logging is enabled!")
end

-- Utility Script for helper functions etc.
ScriptHost:LoadScript("scripts/utils.lua")

-- Logic
ScriptHost:LoadScript("scripts/logic/logic.lua")

-- Custom Items
ScriptHost:LoadScript("scripts/custom_items/class.lua")
ScriptHost:LoadScript("scripts/custom_items/progressiveTogglePlus.lua")
ScriptHost:LoadScript("scripts/custom_items/progressiveTogglePlusWrapper.lua")

-- Items
Tracker:AddItems("items/baseSkills.json")
Tracker:AddItems("items/extraItems.json")
Tracker:AddItems("items/goalMapstones.json")
Tracker:AddItems("items/goalTrees.json")
Tracker:AddItems("items/items.json")
Tracker:AddItems("items/localKeystones.json")
Tracker:AddItems("items/localMapstones.json")
Tracker:AddItems("items/settings.json")
Tracker:AddItems("items/teleporters.json")


-- Maps
Tracker:AddMaps("maps/maps.json")

--Locations
Tracker:AddLocations("locations/locations.json")
Tracker:AddLocations("locations/connections.json")


-- Layout
Tracker:AddLayouts("all_trees.json")
Tracker:AddLayouts("altGoals.json")
Tracker:AddLayouts("layouts/items.json")
Tracker:AddLayouts("layouts/localLogic.json")
Tracker:AddLayouts("layouts/logicOptions.json")
Tracker:AddLayouts("layouts/progressiveMapstone.json")
Tracker:AddLayouts("layouts/settings.json")

Tracker:AddLayouts("layouts/all_trees.json")
Tracker:AddLayouts("layouts/mapstoneGoal.json")
Tracker:AddLayouts("layouts/relicGoal.json")
Tracker:AddLayouts("layouts/warmtGoal.json")
Tracker:AddLayouts("layouts/allGoals.json")

ScriptHost:LoadScript("scripts/watches.lua")

updateGoalLayout()
-- AutoTracking for Poptracker
if PopVersion and PopVersion >= "0.18.0" then
    ScriptHost:LoadScript("scripts/autotracking.lua")
end
