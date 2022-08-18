local player_weapon_icon_fix = {};

local config;
local table_helpers;
local customization_menu;
local blinking_icon_fix;

local gui_manager_type_def = sdk.find_type_definition("snow.gui.GuiManager");
local get_ref_gui_hud_method = gui_manager_type_def:get_method("get_refGuiHud");

local gui_hud_type_def = sdk.find_type_definition("snow.gui.GuiHud");
local buddy_disp_list_field = gui_hud_type_def:get_field("_BuddyDispList");

local buddy_otomo_info_list_field_type_def = buddy_disp_list_field:get_type();
local get_count_method = buddy_otomo_info_list_field_type_def:get_method("get_Count");
local get_item_method = buddy_otomo_info_list_field_type_def:get_method("get_Item");

local buddy_display_type_def = sdk.find_type_definition("snow.gui.GuiHud.BuddyDisp");
local buddy_weapon_icon_change_panel_field = buddy_display_type_def:get_field("pnl_IconChange");

function player_weapon_icon_fix.update_icon_speed()
	if config.current_config.weapon_icons.others.mode == "Normal" then
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

	local buddy_display_list = buddy_disp_list_field:get_data(gui_hud);
	if buddy_display_list == nil then
		customization_menu.status = "No Buddy Weapon Icon List";
		return;
	end

	local buddy_display_list_count = get_count_method:call(buddy_display_list);
	if buddy_display_list_count == nil then
		customization_menu.status = "No Buddy Weapon Icon list Count";
		return;
	end

	local new_speed = config.current_config.weapon_icons.others.icon_update_speed_multiplier;

	for i = 0, buddy_display_list_count - 1 do
		local buddy_display = get_item_method:call(buddy_display_list, i);
		if buddy_display == nil then
			customization_menu.status = "No Buddy Display Object";
			goto continue;
		end

		local weapon_icon_panel = buddy_weapon_icon_change_panel_field:get_data(buddy_display);
		if weapon_icon_panel == nil then
			customization_menu.status = "No Buddy Weapon Icon Panel";
			goto continue;
		end

		blinking_icon_fix.set_play_speed(weapon_icon_panel, new_speed);
		::continue::
	end
end

function player_weapon_icon_fix.init_module()
	table_helpers = require("No_More_Blinking_Icons.table_helpers");
	config = require("No_More_Blinking_Icons.config");
	customization_menu = require("No_More_Blinking_Icons.customization_menu");
	blinking_icon_fix = require("No_More_Blinking_Icons.blinking_icon_fix");
end

return player_weapon_icon_fix;