local player_weapon_icon_fix = {};

local config;
local table_helpers;
local customization_menu;
local blinking_icon_fix;

local gui_manager_type_def = sdk.find_type_definition("snow.gui.GuiManager");
local get_ref_gui_hud_method = gui_manager_type_def:get_method("get_refGuiHud");

local gui_hud_type_def = sdk.find_type_definition("snow.gui.GuiHud");
local update_master_player_info_hud_method = gui_hud_type_def:get_method("updateMasterPlayerInfoHud");
local quest_player_icon_change_panel_field = gui_hud_type_def:get_field("_questPlayerIconChangePanel");

function player_weapon_icon_fix.update_icon_speed()
	if config.current_config.weapon_icons.player.mode == "Normal" then
		return;
	end

	if blinking_icon_fix.gui_manager == nil then
		blinking_icon_fix.gui_manager = sdk.get_managed_singleton("snow.gui.GuiManager");

		if blinking_icon_fix.gui_manager == nil then
			customization_menu.status = "No GUI Manager";
			return;
		end
	end
	
	local gui_hud = get_ref_gui_hud_method:call(blinking_icon_fix.gui_manager);
	if gui_hud == nil then
		customization_menu.status = "No GUI HUD Object";
		return;
	end

	local weapon_icon_panel = quest_player_icon_change_panel_field:get_data(gui_hud);
	if weapon_icon_panel == nil then
		customization_menu.status = "No Player Weapon Icon Panel";
		return;
	end

	blinking_icon_fix.set_play_speed(weapon_icon_panel, config.current_config.weapon_icons.player.icon_update_speed_multiplier);
end

function player_weapon_icon_fix.init_module()
	table_helpers = require("No_More_Blinking_Icons.table_helpers");
	config = require("No_More_Blinking_Icons.config");
	customization_menu = require("No_More_Blinking_Icons.customization_menu");
	blinking_icon_fix = require("No_More_Blinking_Icons.blinking_icon_fix");
end

return player_weapon_icon_fix;