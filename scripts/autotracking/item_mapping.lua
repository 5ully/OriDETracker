-- use this file to map the AP item ids to your items
-- first value is the code of the target item and the second is the item type (currently only "toggle", "progressive" and "consumable" but feel free to expand for your needs!)
-- here are the SM items as an example: https://github.com/Cyb3RGER/sm_ap_tracker/blob/main/scripts/autotracking/item_mapping.lua
ITEM_MAPPING = {
	[262144] = {"abilityCell", "consumable"},
	[262145] = {"healthCell", "consumable"},
	[262146] = {"energyCell", "consumable"},
	[262147] = {"SpiritFlame", "toggle"},
	[262148] = {"GinsoKey", "toggle"},
	[262149] = {"Gumon_seal", "toggle"},
	[262150] = {"Sunstone", "toggle"},
	[262151] = {"Clean_water", "toggle"},
	[262152] = {"Wind", "toggle"},

	[262153] = {"wall_jump", "toggle"},
	[262154] = {"charge_flame", "toggle"},
	[262155] = {"double_jump", "toggle"},
	[262156] = {"bash", "toggle"},
	[262157] = {"stomp", "toggle"},
	[262158] = {"glide", "toggle"},
	[262159] = {"climb", "toggle"},
	[262160] = {"charge_jump", "toggle"},
	[262161] = {"dash", "toggle"},
	[262162] = {"grenade", "toggle"},

	[262163] = {"gladesTP", "toggle"},
	[262164] = {"hollowTP", "toggle"},
	[262165] = {"swampTP", "toggle"},
	[262166] = {"grottoTP", "toggle"},
	[262167] = {"ginsoTP", "toggle"},
	[262168] = {"valleyTP", "toggle"},
	[262169] = {"forlornTP", "toggle"},
	[262170] = {"sorrowTP", "toggle"},
	[262171] = {"horuTP", "toggle"},
	[262172] = {"burrowsTP", "toggle"},

	[262173] = {"warmthFragment", "consumable"},
	[262174] = {"Relic", "consumable"},

	[262175] = {"keystone", "consumable"},
	[262176] = {"localKeystoneGlades", "consumable"},
	[262177] = {"localKeystoneGrotto", "consumable"},
	[262178] = {"localKeystoneGinso", "consumable"},
	[262179] = {"localKeystoneSwamp", "consumable"},
	[262180] = {"localKeystoneMisty", "consumable"},
	[262181] = {"localKeystoneForlorn", "consumable"},
	[262182] = {"localKeystoneSorrow", "consumable"},

	[262183] = {"MapStone", "consumable"},
	[262184] = {"localMapstoneGlades", "toggle"},
	[262185] = {"localMapstoneGrove", "toggle"},
	[262186] = {"localMapstoneGrotto", "toggle"},
	[262187] = {"localMapstoneSwamp", "toggle"},
	[262188] = {"localMapstoneValley", "toggle"},
	[262189] = {"localMapstoneForlorn", "toggle"},
	[262190] = {"localMapstoneSorrow", "toggle"},
	[262191] = {"localMapstoneHoru", "toggle"},
	[262192] = {"localMapstoneBlackroot", "toggle"},

	[262193] = {"HealthRegen", "toggle"},
	[262194] = {"EnergyRegen", "toggle"},

	[262195] = {"ex15", "consumable"},
	[262196] = {"ex50", "consumable"},
	[262197] = {"ex100", "consumable"},
	[262198] = {"ex200", "consumable"}
}