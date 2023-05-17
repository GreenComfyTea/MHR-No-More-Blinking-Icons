local this = {};

local config;
local utils;
local customization_menu;
local blinking_icon_fix;

local sdk = sdk;
local tostring = tostring;
local pairs = pairs;
local ipairs = ipairs;
local tonumber = tonumber;
local require = require;
local pcall = pcall;
local table = table;
local string = string;
local Vector3f = Vector3f;
local d2d = d2d;
local math = math;
local json = json;
local log = log;
local fs = fs;
local next = next;
local type = type;
local setmetatable = setmetatable;
local getmetatable = getmetatable;
local assert = assert;
local select = select;
local coroutine = coroutine;
local utf8 = utf8;
local re = re;
local imgui = imgui;
local draw = draw;
local Vector2f = Vector2f;
local reframework = reframework;
local os = os;
local ValueType = ValueType;
local package = package;

local gui_manager_type_def = sdk.find_type_definition("snow.gui.GuiManager");
local get_ref_gui_hud_method = gui_manager_type_def:get_method("get_refGuiHud");

local gui_hud_type_def = sdk.find_type_definition("snow.gui.GuiHud");
local update_master_player_info_hud_method = gui_hud_type_def:get_method("updateMasterPlayerInfoHud");
local quest_player_icon_change_panel_field = gui_hud_type_def:get_field("_questPlayerIconChangePanel");
local quest_player_weapon_panel_field = gui_hud_type_def:get_field("_questPlayerWeaponPanel");
local quest_player_progress_panel_field = gui_hud_type_def:get_field("_questPlayerProgressPanel");

local gui_panel_type_def = sdk.find_type_definition("via.gui.Panel");
local get_prev_method = gui_panel_type_def:get_method("get_Prev");


local last_play_frame = 0;

function this.update_icon_frame()
	if config.current_config.weapon_icons.player.mode == "Normal" then
		return;
	end

	blinking_icon_fix.get_gui_manager();
	if blinking_icon_fix.gui_manager == nil then
		return;
	end
	
	local gui_hud = get_ref_gui_hud_method:call(blinking_icon_fix.gui_manager);
	if gui_hud == nil then
		customization_menu.status = "[player_weapon_icon_fix.update_icon_frame] No GUI HUD Object";
		return;
	end

	local icon_change_panel = quest_player_icon_change_panel_field:get_data(gui_hud);
	if icon_change_panel == nil then
		customization_menu.status = "[player_weapon_icon_fix.update_icon_frame] No Player Icon Change Panel";
		return;
	end

	local weapon_icon_panel = quest_player_weapon_panel_field:get_data(gui_hud);
	if weapon_icon_panel == nil then
		customization_menu.status = "[player_weapon_icon_fix.update_icon_frame] No Player Weapon Icon Panel";
		return;
	end

	local discovered_icon_texture = get_prev_method:call(weapon_icon_panel);
	if discovered_icon_texture == nil then
		customization_menu.status = "[player_weapon_icon_fix.update_icon_frame] No Player Discovered Icon Texture";
		return;
	end

	local ready_icon_panel = quest_player_progress_panel_field:get_data(gui_hud);
	if ready_icon_panel == nil then
		customization_menu.status = "[player_weapon_icon_fix.update_icon_frame] No Player Ready Icon Panel";
		return;
	end

	last_play_frame = blinking_icon_fix.set_play_frame(icon_change_panel, weapon_icon_panel, discovered_icon_texture, ready_icon_panel, nil,
		last_play_frame, config.current_config.weapon_icons.player);
end

function this.init_module()
	utils = require("No_More_Blinking_Icons.utils");
	config = require("No_More_Blinking_Icons.config");
	customization_menu = require("No_More_Blinking_Icons.customization_menu");
	blinking_icon_fix = require("No_More_Blinking_Icons.blinking_icon_fix");
end

return this;