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
local buddy_disp_list_field = gui_hud_type_def:get_field("_BuddyDispList");

local buddy_otomo_info_list_field_type_def = buddy_disp_list_field:get_type();
local get_count_method = buddy_otomo_info_list_field_type_def:get_method("get_Count");
local get_item_method = buddy_otomo_info_list_field_type_def:get_method("get_Item");

local buddy_display_type_def = sdk.find_type_definition("snow.gui.GuiHud.BuddyDisp");
local buddy_icon_change_panel_field = buddy_display_type_def:get_field("pnl_IconChange");
local buddy_weapon_icon_panel_field = buddy_display_type_def:get_field("pnl_WeaponIcon");
local buddy_discover_icon_texture_field = buddy_display_type_def:get_field("tex_DiscoverIcon");
local buddy_progress_icon_panel_field = buddy_display_type_def:get_field("pnl_ProgressIcon");

local panel_type_def = sdk.find_type_definition("via.gui.Panel");
local get_child_method = panel_type_def:get_method("get_Child");

local last_play_frames = {};

function this.update_icon_frames()
	if config.current_config.weapon_icons.others.mode == "Normal" then
		return;
	end

	blinking_icon_fix.get_gui_manager();
	if blinking_icon_fix.gui_manager == nil then
		return;
	end
	
	local gui_hud = get_ref_gui_hud_method:call(blinking_icon_fix.gui_manager);
	if gui_hud == nil then
		customization_menu.status = "[buddy_weapon_icon_fix.update_icon_frames] No GUI HUD Object";
		return;
	end

	local buddy_display_list = buddy_disp_list_field:get_data(gui_hud);
	if buddy_display_list == nil then
		customization_menu.status = "[buddy_weapon_icon_fix.update_icon_frames] No Buddy Weapon Icon List";
		return;
	end

	local buddy_display_list_count = get_count_method:call(buddy_display_list);
	if buddy_display_list_count == nil then
		customization_menu.status = "[buddy_weapon_icon_fix.update_icon_frames] No Buddy Weapon Icon list Count";
		return;
	end

	for i = 0, buddy_display_list_count - 1 do
		local buddy_display = get_item_method:call(buddy_display_list, i);
		if buddy_display == nil then
			customization_menu.status = "[buddy_weapon_icon_fix.update_icon_frames] No Buddy Display Object";
			goto continue;
		end

		local icon_change_panel = buddy_icon_change_panel_field:get_data(buddy_display);
		if icon_change_panel == nil then
			customization_menu.status = "[buddy_weapon_icon_fix.update_icon_frames] No Buddy Icon Change Panel";
			goto continue;
		end

		local weapon_icon_panel = buddy_weapon_icon_panel_field:get_data(buddy_display);
		if weapon_icon_panel == nil then
			customization_menu.status = "[buddy_weapon_icon_fix.update_icon_frames] No Buddy Weapon Icon Panel";
			goto continue;
		end

		local discovered_icon_texture = buddy_discover_icon_texture_field:get_data(buddy_display);
		if discovered_icon_texture == nil then
			customization_menu.status = "[buddy_weapon_icon_fix.update_icon_frames] No Buddy Discovered Icon Texture";
			goto continue;
		end

		local host_icon_texture = get_child_method:call(icon_change_panel);
		if host_icon_texture == nil then
			customization_menu.status = "[buddy_weapon_icon_fix.update_icon_frames] No Buddy Host Icon Texture";
			goto continue;
		end

		last_play_frames[i + 1] = blinking_icon_fix.set_play_frame(icon_change_panel, weapon_icon_panel, discovered_icon_texture, nil, host_icon_texture,
			last_play_frames[i + 1], config.current_config.weapon_icons.others);
		::continue::
	end
end

function this.init_module()
	utils = require("No_More_Blinking_Icons.utils");
	config = require("No_More_Blinking_Icons.config");
	customization_menu = require("No_More_Blinking_Icons.customization_menu");
	blinking_icon_fix = require("No_More_Blinking_Icons.blinking_icon_fix");
end

return this;