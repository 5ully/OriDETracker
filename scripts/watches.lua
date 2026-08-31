function updateGoalLayout()
	AUTOTRACKER_ENABLE_GOAL_TRACKING = Tracker:FindObjectForCode("goal").AcquiredCount
  if AUTOTRACKER_ENABLE_GOAL_TRACKING == 1 then
    Tracker:AddLayouts("layouts/trackerMapstones.json")
  elseif AUTOTRACKER_ENABLE_GOAL_TRACKING == 2  then
		Tracker:AddLayouts("layouts/trackerWarmth.json")
  elseif AUTOTRACKER_ENABLE_GOAL_TRACKING == 3 then
		Tracker:AddLayouts("layouts/trackerRelic.json")
  elseif AUTOTRACKER_ENABLE_GOAL_TRACKING == 4 then
    Tracker:AddLayouts("layouts/tracker.json")
  else
   -- Tracker:AddLayouts("layouts/trackerTrees.json")
   -- Tracker:AddLayouts("layouts/trackerWarmth.json")
   -- Tracker:AddLayouts("layouts/trackerMapstones.json")
   -- Tracker:AddLayouts("layouts/broadcast.json")
      Tracker:AddLayouts("layouts/allGoals.json")
  end

end


if PopVersion > "0.1.0" then
	ScriptHost:AddWatchForCode("goalMode", "GOAL", updateGoalLayout)
end
