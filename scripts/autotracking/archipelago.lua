-- this is an example/ default implementation for AP autotracking
-- it will use the mappings defined in item_mapping.lua and location_mapping.lua to track items and locations via thier ids
-- it will also load the AP slot data in the global SLOT_DATA, keep track of the current index of on_item messages in CUR_INDEX
-- addition it will keep track of what items are local items and which one are remote using the globals LOCAL_ITEMS and GLOBAL_ITEMS
-- this is useful since remote items will not reset but local items might
ScriptHost:LoadScript("scripts/autotracking/item_mapping.lua")
ScriptHost:LoadScript("scripts/autotracking/location_mapping.lua")

CUR_INDEX = -1
SLOT_DATA = nil
LOCAL_ITEMS = {}
GLOBAL_ITEMS = {}

function  locationMapstone(location)
    print("looking")
    x = location[1]
    y = location[2]
    
    if x < 425 and x > 415 and y > -285 and y < -275 then
        Tracker:FindObjectForCode("BlackrootMap").Active = false
    end
end

function retrieved(key, value)
    -- print("got " .. key .. " = " .. (dump_table(value)))
    return value
end

function setReply(key, value, old)
    print("got  " .. key .. " = " .. (dump_table(value)) .. " (was " .. tostring(old) .. ")")
  end

function onClear(slot_data)
    if AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
        print(string.format("called onClear, slot_data:\n%s", dump_table(slot_data)))
    end
    SLOT_DATA = slot_data
    CUR_INDEX = -1
    -- reset locations
    for _, v in pairs(LOCATION_MAPPING) do
        if v[1] then
            if AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
                print(string.format("onClear: clearing location %s", v[1]))
            end
            local obj = Tracker:FindObjectForCode(v[1])
            if obj then
                if v[1]:sub(1, 1) == "@" then
                    obj.AvailableChestCount = obj.ChestCount
                else
                    obj.Active = false
                end
            elseif AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
                print(string.format("onClear: could not find object for code %s", v[1]))
            end
        end
    end
    -- reset items
    for _, v in pairs(ITEM_MAPPING) do
        if v[1] and v[2] then
            if AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
                print(string.format("onClear: clearing item %s of type %s", v[1], v[2]))
            end
            local obj = Tracker:FindObjectForCode(v[1])
            if obj then
                if v[2] == "toggle" then
                    obj.Active = false
                elseif v[2] == "progressive" then
                    obj.CurrentStage = 0
                    obj.Active = false
                elseif v[2] == "consumable" then
                    obj.AcquiredCount = 0
                elseif AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
                    print(string.format("onClear: unknown item type %s for code %s", v[2], v[1]))
                end
            if SLOT_DATA['goal'] == 0 then -- Reset Trees
                Tracker:FindObjectForCode("wall_jump_tree").Active = false
                Tracker:FindObjectForCode("charge_flame_tree").Active = false
                Tracker:FindObjectForCode("double_jump_tree").Active = false
                Tracker:FindObjectForCode("bash_tree").Active = false
                Tracker:FindObjectForCode("stomp_tree").Active = false
                Tracker:FindObjectForCode("climb_tree").Active = false
                Tracker:FindObjectForCode("charge_jump_tree").Active = false
                Tracker:FindObjectForCode("grenade_tree").Active = false
                Tracker:FindObjectForCode("dash_tree").Active = false
                Tracker:FindObjectForCode("feather_tree").Active = false
                Tracker:FindObjectForCode("TreesTotal").AcquiredCount = 0
            end
            if SLOT_DATA['goal'] == 1 then -- Reset Mapstones
                Tracker:FindObjectForCode("GladesMap").Active = false
                Tracker:FindObjectForCode("GroveMap").Active = false
                Tracker:FindObjectForCode("GrottoMap").Active = false
                Tracker:FindObjectForCode("ValleyMap").Active = false
                Tracker:FindObjectForCode("ForlornMap").Active = false
                Tracker:FindObjectForCode("SorrowMap").Active = false
                Tracker:FindObjectForCode("HoruMap").Active = false
                Tracker:FindObjectForCode("BlackrootMap").Active = false
                Tracker:FindObjectForCode("SwampMap").Active = false
                Tracker:FindObjectForCode("MapstonesTotal").AcquiredCount = 0
            end
            if SLOT_DATA['goal'] == 2 then -- Reset Sunstone Shards
                Tracker:FindObjectForCode("SunStoneShard").AcquiredCount = 0
            end
            if SLOT_DATA['goal'] == 3 then -- Reset Relics
                Tracker:FindObjectForCode("Relic").AcquiredCount = 0
            end
            if SLOT_DATA['goal'] == 4 then -- Reset Open Escape
                Tracker:FindObjectForCode("openEscape").Active = false
            end

            elseif AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
                print(string.format("onClear: could not find object for code %s", v[1]))
            end
        
        end
        SLOT_DATA = slot_data
        CUR_INDEX = -1

        updateGoalLayout()
    end
    LOCAL_ITEMS = {}
    GLOBAL_ITEMS = {}
    -- manually run snes interface functions after onClear in case we are already ingame
    if PopVersion < "0.20.1" or AutoTracker:GetConnectionState("SNES") == 3 then
        -- add snes interface functions here
    end
    if SLOT_DATA['logic_difficulty'] then
        -- Set Difficulty Mode
        Tracker:FindObjectForCode("Difficulty").AcquiredCount = tonumber(SLOT_DATA["logic_difficulty"])
    end
    if SLOT_DATA['goal'] then
        -- Set goal Mode
        Tracker:FindObjectForCode("GOAL").AcquiredCount = tonumber(SLOT_DATA["goal"])
    end

    -- Set Logic Options that is not skill or ability point dependant
    if SLOT_DATA['enable_lure'] == 1 then
        Tracker:FindObjectForCode('lure_logic').Active = true
    end
    -- Set Closed Dungeons

    -- Set Max count of goal item for Relic/Warmth Fragments

    if SLOT_DATA['goal'] == 2 then
        Tracker:FindObjectForCode('WarmthFragment').MaxCount = SLOT_DATA['warmth_fragments_required']
    end
    if SLOT_DATA['goal'] == 3 then
        Tracker:FindObjectForCode('Relic').MaxCount = SLOT_DATA['relic_count']
    end

    -- Set Open Exit
    if SLOT_DATA['goal'] == 4 then
        Tracker:FindObjectForCode('openEscape').Active = true
    end

    -- Set mapstone logic to progressive
    if SLOT_DATA['mapstone_logic'] == 2 then
        Tracker:FindObjectForCode("progressiveMapstone").Active = true
    end

    Archipelago:SetNotify({"Slot:" .. Archipelago.PlayerNumber .. ":Position"})
    Archipelago:Get({"Slot:" .. Archipelago.PlayerNumber .. ":Position"})

end


-- called when an item gets collected
function onItem(index, item_id, item_name, player_number)
    if AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
        print(string.format("called onItem: %s, %s, %s, %s, %s", index, item_id, item_name, player_number, CUR_INDEX))
    end
    if not AUTOTRACKER_ENABLE_ITEM_TRACKING then
        return
    end
    if index <= CUR_INDEX then
        return
    end
    local is_local = player_number == Archipelago.PlayerNumber
    CUR_INDEX = index;
    local v = ITEM_MAPPING[item_id]
    if not v then
        if AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
            print(string.format("onItem: could not find item mapping for id %s", item_id))
        end
        return
    end
    if AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
        print(string.format("onItem: code: %s, type %s", v[1], v[2]))
    end
    if not v[1] then
        return
    end
    local obj = Tracker:FindObjectForCode(v[1])
    if obj then
        if v[2] == "toggle" then
            obj.Active = true
        elseif v[2] == "progressive" then
            if obj.Active then
                obj.CurrentStage = obj.CurrentStage + 1
            else
                obj.Active = true
            end
        elseif v[2] == "consumable" then
            obj.AcquiredCount = obj.AcquiredCount + obj.Increment
        elseif AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
            print(string.format("onItem: unknown item type %s for code %s", v[2], v[1]))
        end
    elseif AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
        print(string.format("onItem: could not find object for code %s", v[1]))
    end
    
    -- Special Logic options
    -- Charge Flame Burn
    if item_name == 'ChargeFlame' or item_name == 'AbilityCell' then
        if SLOT_DATA['enable_charge_flame_burn'] == 1 then
            if Tracker:FindObjectForCode('charge_flame').Active == true and Tracker:FindObjectForCode('abilityCell').AcquiredCount >= 3 then
                Tracker:FindObjectForCode('cFlameBurn_logic').Active = true
            end
        end
    end
    -- Double Bash
    if item_name == 'Bash' then
        if SLOT_DATA['enable_double_bash'] == 1 then
            Tracker:FindObjectForCode('dBash_logic').Active = true
        end
    end
    -- Grenade Jump
    if item_name == 'Climb' or item_name == 'ChargeJump' or item_name == 'Grenade' then
        if SLOT_DATA['enable_grenade_jump'] == 1 then
            if Tracker:FindObjectForCode('climb').Active == true and Tracker:FindObjectForCode('charge_jump').Active == true and Tracker:FindObjectForCode('grenade').Active == true then
                Tracker:FindObjectForCode('gJump_logic').Active = true
            end
        end
    end
    -- Charge Dash
    if item_name == 'Dash' or item_name == 'AbilityCell' then
        if SLOT_DATA['enable_charge_dash'] == 1 then
            if Tracker:FindObjectForCode('dash').Active == true and Tracker:FindObjectForCode('abilityCell').AcquiredCount >= 6 then
                Tracker:FindObjectForCode('cDash_logic').Active = true
            end
        end
    end
    -- Air Dash
    if item_name == 'Dash' or item_name == 'AbilityCell' then
        if SLOT_DATA['enable_air_dash'] == 1 then
            if Tracker:FindObjectForCode('dash').Active == true and Tracker:FindObjectForCode('abilityCell').AcquiredCount >= 3 then
                Tracker:FindObjectForCode('airDash_logic').Active = true
            end
        end
    end
    -- Triple Jump
    if item_name == 'DoubleJump' or item_name == 'AbilityCell' then
        if SLOT_DATA['enable_triple_jump'] == 1 then
            if Tracker:FindObjectForCode('double_jump').Active == true and Tracker:FindObjectForCode('abilityCell').AcquiredCount >= 12 then
                Tracker:FindObjectForCode('tripleJump_logic').Active = true
            end
        end
    end
    -- Ultra Defence
    if item_name == 'AbilityCell' then
        if SLOT_DATA['enable_damage_boost'] == 1 then
            if Tracker:FindObjectForCode('abilityCell').AcquiredCount >= 12 then
                Tracker:FindObjectForCode('dBoost_logic').Active = true
            end
        end
    end
    -- Bash Grenade
    if item_name == 'Bash' or item_name == 'Grenade' then
        if Tracker:FindObjectForCode('bash').Active == true and Tracker:FindObjectForCode('grenade').Active == true then
            Tracker:FindObjectForCode('bashGrenade_logic').Active = true
        end
    end

    -- Rekindle
    if item_name == 'AbilityCell' then
        if SLOT_DATA['enable_rekindle'] == 1 then
            Tracker:FindObjectForCode('rekindle_logic').Active = true
        end
    end
end


-- called when a location gets cleared
function onLocation(location_id, location_name)
    if AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
        print(string.format("called onLocation: %s, %s", location_id, location_name))
    end
    if not AUTOTRACKER_ENABLE_LOCATION_TRACKING then
        return
    end
    local v = LOCATION_MAPPING[location_id]
    if not v and AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
        print(string.format("onLocation: could not find location mapping for id %s", location_id))
    end
    if not v[1] then
        return
    end
    local obj = Tracker:FindObjectForCode(v[1])
    if obj then
        if v[1]:sub(1, 1) == "@" then
            obj.AvailableChestCount = obj.AvailableChestCount - 1
        else
            obj.Active = true
        end
    elseif AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
        print(string.format("onLocation: could not find object for code %s", v[1]))
    end
    -- GOAL UPDATES
    if SLOT_DATA['goal'] == 0 then -- All Skill Tree's
        if location_name == "WallJumpSkillTree" then
            Tracker:FindObjectForCode("wall_jump_tree").Active = true
            Tracker:FindObjectForCode("TreesTotal").AcquiredCount = Tracker:FindObjectForCode("TreesTotal").AcquiredCount + 1

        elseif location_name == "ChargeFlameSkillTree" then
            Tracker:FindObjectForCode("charge_flame_tree").Active = true
            Tracker:FindObjectForCode("TreesTotal").AcquiredCount = Tracker:FindObjectForCode("TreesTotal").AcquiredCount + 1

        elseif location_name == "BashSkillTree" then
            Tracker:FindObjectForCode("bash_tree").Active = true
            Tracker:FindObjectForCode("TreesTotal").AcquiredCount = Tracker:FindObjectForCode("TreesTotal").AcquiredCount + 1

        elseif location_name == "ChargeJumpSkillTree" then
            Tracker:FindObjectForCode("charge_jump_tree").Active = true
            Tracker:FindObjectForCode("TreesTotal").AcquiredCount = Tracker:FindObjectForCode("TreesTotal").AcquiredCount + 1

        elseif location_name == "ClimbSkillTree" then
            Tracker:FindObjectForCode("climb_tree").Active = true
            Tracker:FindObjectForCode("TreesTotal").AcquiredCount = Tracker:FindObjectForCode("TreesTotal").AcquiredCount + 1

        elseif location_name == "DashSkillTree" then
            Tracker:FindObjectForCode("dash_tree").Active = true
            Tracker:FindObjectForCode("TreesTotal").AcquiredCount = Tracker:FindObjectForCode("TreesTotal").AcquiredCount + 1

        elseif location_name == "DoubleJumpSkillTree" then
            Tracker:FindObjectForCode("double_jump_tree").Active = true
            Tracker:FindObjectForCode("TreesTotal").AcquiredCount = Tracker:FindObjectForCode("TreesTotal").AcquiredCount + 1

        elseif location_name == "StompSkillTree" then
            Tracker:FindObjectForCode("climb_tree").Active = true
            Tracker:FindObjectForCode("TreesTotal").AcquiredCount = Tracker:FindObjectForCode("TreesTotal").AcquiredCount + 1

        elseif location_name == "GrenadeSkillTree" then
            Tracker:FindObjectForCode("grenade_tree").Active = true
            Tracker:FindObjectForCode("TreesTotal").AcquiredCount = Tracker:FindObjectForCode("TreesTotal").AcquiredCount + 1

        elseif location_name == "GlideSkillFeather" then
            Tracker:FindObjectForCode("feather_tree").Active = true
            Tracker:FindObjectForCode("TreesTotal").AcquiredCount = Tracker:FindObjectForCode("TreesTotal").AcquiredCount + 1
        else
        end
    end
    if SLOT_DATA['goal'] == 1 then -- All Mapstones
        if location_name == "GladesMap" then
            Tracker:FindObjectForCode("GladesMap").Active = true
            Tracker:FindObjectForCode("MapstonesTotal").AcquiredCount = Tracker:FindObjectForCode("MapstonesTotal").AcquiredCount + 1
        
        elseif location_name == "GroveMap" then
            Tracker:FindObjectForCode("GroveMap").Active = true
            Tracker:FindObjectForCode("MapstonesTotal").AcquiredCount = Tracker:FindObjectForCode("MapstonesTotal").AcquiredCount + 1

        elseif location_name == "GrottoMap" then
            Tracker:FindObjectForCode("GrottoMap").Active = true
            Tracker:FindObjectForCode("MapstonesTotal").AcquiredCount = Tracker:FindObjectForCode("MapstonesTotal").AcquiredCount + 1

        elseif location_name == "SwampMap" then
            Tracker:FindObjectForCode("SwampMap").Active = true
            Tracker:FindObjectForCode("MapstonesTotal").AcquiredCount = Tracker:FindObjectForCode("MapstonesTotal").AcquiredCount + 1

        elseif location_name == "ValleyMap" then
            Tracker:FindObjectForCode("ValleyMap").Active = true
            Tracker:FindObjectForCode("MapstonesTotal").AcquiredCount = Tracker:FindObjectForCode("MapstonesTotal").AcquiredCount + 1

        elseif location_name == "ForlornMap" then
            Tracker:FindObjectForCode("ForlornMap").Active = true
            Tracker:FindObjectForCode("MapstonesTotal").AcquiredCount = Tracker:FindObjectForCode("MapstonesTotal").AcquiredCount + 1

        elseif location_name == "SorrowMap" then
            Tracker:FindObjectForCode("SorrowMap").Active = true
            Tracker:FindObjectForCode("MapstonesTotal").AcquiredCount = Tracker:FindObjectForCode("MapstonesTotal").AcquiredCount + 1

        elseif location_name == "HoruMap" then
            Tracker:FindObjectForCode("HoruMap").Active = true
            Tracker:FindObjectForCode("MapstonesTotal").AcquiredCount = Tracker:FindObjectForCode("MapstonesTotal").AcquiredCount + 1

        elseif location_name == "BlackrootMap" then
            Tracker:FindObjectForCode("BlackrootMap").Active = true
            Tracker:FindObjectForCode("MapstonesTotal").AcquiredCount = Tracker:FindObjectForCode("MapstonesTotal").AcquiredCount + 1
        else
        end
    end

    -- Progressive Mapstones Location Clear and Mapstone Logic
    LOCAL_MAPSTONES = string.find(location_name, "ProgressiveMap")
    if  LOCAL_MAPSTONES ~= nil then
        if SLOT_DATA['mapstone_logic'] == 2 then
            locationMapstone(location_name)
            Tracker:FindObjectForCode('mapstone').AcquiredCount = Tracker:FindObjectForCode('mapstone').AcquiredCount - 1
            print('test')
        end
        
    end
end

-- called when a locations is scouted
function onScout(location_id, location_name, item_id, item_name, item_player)
    if AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
        print(string.format("called onScout: %s, %s, %s, %s, %s", location_id, location_name, item_id, item_name,
            item_player))
    end
    -- not implemented yet :(
end

-- called when a bounce message is received 
function onBounce(json)
    local data = json["data"]
    if data then
        --        if data["type"] == "MapUpdate" then
                    print(dump_table(data))
        --        end
            end

    if AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
        print(string.format("called onBounce: %s", dump_table(json)))
    end
    -- your code goes here
end

-- 

-- add AP callbacks
-- un-/comment as needed
Archipelago:AddClearHandler("clear handler", onClear)
if AUTOTRACKER_ENABLE_ITEM_TRACKING then
    Archipelago:AddItemHandler("item handler", onItem)
end
if AUTOTRACKER_ENABLE_LOCATION_TRACKING then
    Archipelago:AddLocationHandler("location handler", onLocation)
end


-- Archipelago:AddScoutHandler("scout handler", onScout)
Archipelago:AddBouncedHandler("bounce handler", onBounce)
Archipelago:AddSetReplyHandler("set reply handler", onSetReply)
-- Archipelago:AddSetReplyHandler("setReply", setReply)
Archipelago:AddRetrievedHandler("setReply", setReply)
Archipelago:AddRetrievedHandler("retrieved", retrieved)

Archipelago:Get({"Position"})



