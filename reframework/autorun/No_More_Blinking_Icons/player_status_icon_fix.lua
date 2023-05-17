local this = {};

local config;
local utils;
local customization_menu;
local blinking_icon_fix;
local player_weapon_icon_fix;
local buddy_weapon_icon_fix;

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
local update_master_player_info_method = gui_hud_type_def:get_method("updateMasterPlayerInfo");

local is_displayed_field = gui_hud_type_def:get_field("_questPlayerStatusIconDisp");
local timer_field_name = "_questPlayerStatusIconBlinkTimer";
local timer_field = gui_hud_type_def:get_field(timer_field_name);

local last_timer_value = 0;

function this.post_update_master_player_info()
	customization_menu.status = "OK";
	
	blinking_icon_fix.get_gui_manager();
	if blinking_icon_fix.gui_manager == nil then
		return;
	end
	
	local gui_hud = get_ref_gui_hud_method:call(blinking_icon_fix.gui_manager);
	if gui_hud == nil then
		customization_menu.status = "[player_status_icon_fix.post_update_master_player_info] No GUI HUD Object";
		return;
	end

	last_timer_value = blinking_icon_fix.set_timer_value(gui_hud, timer_field, is_displayed_field, timer_field_name,
		last_timer_value, config.current_config.status_icons.player);
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
		if config.current_config.enabled then
			this.post_update_master_player_info();
			player_weapon_icon_fix.update_icon_frame();
		end
		
		return retval;
	end
	);
end

return this;