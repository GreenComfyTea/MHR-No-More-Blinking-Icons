local utils = require("No_More_Blinking_Icons.utils");
local config = require("No_More_Blinking_Icons.config");

local customization_menu = require("No_More_Blinking_Icons.customization_menu");
local native_customization_menu = require("No_More_Blinking_Icons.native_customization_menu");

local blinking_icon_fix = require("No_More_Blinking_Icons.blinking_icon_fix");
local player_status_icon_fix = require("No_More_Blinking_Icons.player_status_icon_fix");
local player_weapon_icon_fix = require("No_More_Blinking_Icons.player_weapon_icon_fix");
local buddy_status_icon_fix = require("No_More_Blinking_Icons.buddy_status_icon_fix");
local buddy_weapon_icon_fix = require("No_More_Blinking_Icons.buddy_weapon_icon_fix");

utils.init_module();
config.init_module();

customization_menu.init_module();
native_customization_menu.init_module();

blinking_icon_fix.init_module();
player_status_icon_fix.init_module();
player_weapon_icon_fix.init_module();
buddy_status_icon_fix.init_module();
buddy_weapon_icon_fix.init_module();

log.info("[No More Blinking Icons] Loaded.");

re.on_draw_ui(function()
	if imgui.button("No More Blinking Icons v" .. config.current_config.version) then
		customization_menu.is_opened = not customization_menu.is_opened;
	end
end);


local gui_manager_type_def = sdk.find_type_definition("snow.gui.GuiManager");
local get_ref_gui_hud_method = gui_manager_type_def:get_method("get_refGuiHud");

local gui_hud_type_def = sdk.find_type_definition("snow.gui.GuiHud");
local update_master_player_info_hud_method = gui_hud_type_def:get_method("updateMasterPlayerInfoHud");
local calcTimerAdd_method = gui_hud_type_def:get_method("calcTimerAdd");
local quest_player_icon_change_panel_field = gui_hud_type_def:get_field("_questPlayerIconChangePanel");
--local quest_player_icon_change_panel_field = gui_hud_type_def:get_field("_questPlayerPanel");

re.on_pre_application_entry("UpdateGUI", function()
	
end);


re.on_frame(function()
	if not reframework:is_drawing_ui() then
		customization_menu.is_opened = false;
	end

	if customization_menu.is_opened then
		pcall(customization_menu.draw);
	end

	pcall(function()
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

		--weapon_icon_panel:set_ForceInvisible(false);

		--weapon_icon_panel:set_ForceInvisible(false);
		--weapon_icon_panel:set_Visible(true);

		-- DEFAULT = weapon icon all the time
		-- FOUND = weapon icon and visibility icon alternating
		-- NOTFOUND = weapon icon all the time
		-- ALL = ???
		-- READINESS = ready for a quest icon all the time

		--[[
			00 - 29 = weapon icon		= 0.5s
			30 - 40 = hidden			= 0.167s
			41 - 69 = visibility icon	= 0.5s
			69 - 80 = hidden			= 0.167s

			total 						= 1.333s
		]]

		xy = string.format(
			"%0.1f / %0.1f\n%s",
			weapon_icon_panel:get_PlayFrame(),
			weapon_icon_panel:get_StateFinishFrame(),
			""
		);
	end);
end);