local this = {};

local config;
local utils;
local customization_menu;
local blinking_icon_fix;
local player_weapon_icon_fix;
local buddy_weapon_icon_fix;

local gui_manager_type_def = sdk.find_type_definition("snow.gui.GuiManager");
local get_ref_gui_hud_method = gui_manager_type_def:get_method("get_refGuiHud");

local gui_hud_type_def = sdk.find_type_definition("snow.gui.GuiHud");
local update_master_player_info_method = gui_hud_type_def:get_method("updateMasterPlayerInfo");

local is_displayed_field = gui_hud_type_def:get_field("_questPlayerStatusIconDisp");
local timer_field_name = "_questPlayerStatusIconBlinkTimer";
local timer_field = gui_hud_type_def:get_field(timer_field_name);

local last_timer_value = 0;

function this.post_update_master_player_info()
	customization_menu.status = "OK";
	
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

	last_timer_value = blinking_icon_fix.set_timer_value(gui_hud, timer_field, is_displayed_field, timer_field_name, last_timer_value, config.current_config.status_icons.player);
end

function this.init_module()
	utils = require("No_More_Blinking_Icons.utils");
	config = require("No_More_Blinking_Icons.config");
	customization_menu = require("No_More_Blinking_Icons.customization_menu");
	blinking_icon_fix = require("No_More_Blinking_Icons.blinking_icon_fix");
	player_weapon_icon_fix = require("No_More_Blinking_Icons.player_weapon_icon_fix");
	buddy_weapon_icon_fix = require("No_More_Blinking_Icons.buddy_weapon_icon_fix");

	sdk.hook(update_master_player_info_method, function()
	end,
	function(retval)
		this.post_update_master_player_info();

		player_weapon_icon_fix.update_icon_speed();
		buddy_weapon_icon_fix.update_icon_speed();
		
		return retval;
	end
	);
end

return this;