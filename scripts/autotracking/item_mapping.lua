-- use this file to map the AP item ids to your items
-- first value is the code of the target item and the second is the item type (currently only "toggle", "progressive" and "consumable" but feel free to expand for your needs!)
-- here are the SM items as an example: https://github.com/Cyb3RGER/sm_ap_tracker/blob/main/scripts/autotracking/item_mapping.lua
ITEM_MAPPING = {
	[262144] = {"abilityCell", "consumable"},
	[262145] = {"healthCell", "consumable"},
	[262146] = {"energyCell", "consumable"},
	[262147] = {"keystone", "consumable"},
	[262148] = {"mapstone", "consumable"},
	[262149] = {"GinsoKey", "toggle"},
	[262150] = {"Gumon_seal", "toggle"},
	[262151] = {"Sunstone", "toggle"},
	[262152] = {"Clean_water", "toggle"},
	[262153] = {"Wind", "toggle"},

	[262154] = {"wall_jump", "toggle"},
	[262155] = {"charge_flame", "toggle"},
	[262156] = {"double_jump", "toggle"},
	[262157] = {"bash", "toggle"},
	[262158] = {"stomp", "toggle"},
	[262159] = {"glide", "toggle"},
	[262160] = {"climb", "toggle"},
	[262161] = {"charge_jump", "toggle"},
	[262162] = {"dash", "toggle"},
	[262163] = {"grenade", "toggle"},

	[262164] = {"gladesTP", "toggle"},
	[262165] = {"hollowTP", "toggle"},
	[262166] = {"swampTP", "toggle"},
	[262167] = {"grottoTP", "toggle"},
	[262168] = {"ginsoTP", "toggle"},
	[262169] = {"valleyTP", "toggle"},
	[262170] = {"forlornTP", "toggle"},
	[262171] = {"sorrowTP", "toggle"},
	[262172] = {"horuTP", "toggle"},
	[262173] = {"burrowsTP", "toggle"},

	[262174] = {"ex15", "consumable"},
	[262175] = {"ex50", "consumable"},
	[262176] = {"ex100", "consumable"},
	[262177] = {"ex200", "consumable"}
}