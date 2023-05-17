local this = {};

local config;
local utils;
local customization_menu;
local blinking_icon_fix;
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
local update_buddy_info_hud_method = gui_hud_type_def:get_method("updateBuddyInfo");

local buddy_info_list_field = gui_hud_type_def:get_field("_BuddyInfoList");
local buddy_servant_info_list_field = gui_hud_type_def:get_field("_BuddyServantInfoList");
local buddy_otomo_info_list_field = gui_hud_type_def:get_field("_BuddyOtomoInfoList");

local buddy_otomo_info_list_field_type_def = buddy_otomo_info_list_field:get_type();
local get_count_method = buddy_otomo_info_list_field_type_def:get_method("get_Count");
local get_item_method = buddy_otomo_info_list_field_type_def:get_method("get_Item");

local buddy_info_type_def = sdk.find_type_definition("snow.gui.GuiHud.BuddyInfo");
local debuff_status_field = buddy_info_type_def:get_field("DebuffStatus");
local buff_status_field = buddy_info_type_def:get_field("BuffStatus");
local other_status_field = buddy_info_type_def:get_field("OtherStatus");

local buddy_info_status_ctrl_type_def = sdk.find_type_definition("snow.gui.GuiHud.BuddyInfo.StatusCtrl");
local is_displayed_field = buddy_info_status_ctrl_type_def:get_field("isAnimeDisp");
local timer_field_name = "Timer";
local timer_field = buddy_info_status_ctrl_type_def:get_field(timer_field_name);

local last_timer_values = {
	players = {
		debuffs = {},
		buffs = {},
		others = {}
	},
	servants = {
		debuffs = {},
		buffs = {},
		others = {}
	},
	otomos = {
		debuffs = {},
		buffs = {},
		others = {}
	}
};

function this.fix_buddy_list(buddy_list, _last_timer_values, status_icon_config)
	local buddy_list_count = get_count_method:call(buddy_list);
	if buddy_list_count == nil then
		customization_menu.status = "[buddy_status_icon_fix.fix_buddy_list] No Buddy List Count";
		return;
	end
	
	for i = 0, buddy_list_count - 1 do
		local buddy_info = get_item_method:call(buddy_list, i);
		if buddy_info == nil then
			customization_menu.status = "[buddy_status_icon_fix.fix_buddy_list] No Buddy Info";
			goto continue;
		end

		local debuff_status = debuff_status_field:get_data(buddy_info);
		if debuff_status ~= nil then
			_last_timer_values.debuffs[i + 1] = blinking_icon_fix.set_timer_value(debuff_status, timer_field, is_displayed_field,
				timer_field_name, _last_timer_values.debuffs[i + 1], status_icon_config);
		end
		
		local buff_status = buff_status_field:get_data(buddy_info);
		if buff_status ~= nil then
			
			_last_timer_values.buffs[i + 1] = blinking_icon_fix.set_timer_value(buff_status, timer_field, is_displayed_field,
				timer_field_name, _last_timer_values.buffs[i + 1], status_icon_config);
		end
	
		local other_status = other_status_field:get_data(buddy_info);
		if other_status ~= nil then
			_last_timer_values.others[i + 1] = blinking_icon_fix.set_timer_value(other_status, timer_field, is_displayed_field,
				timer_field_name, _last_timer_values.others[i + 1], status_icon_config);
		end

		::continue::
	end
end

function this.post_update_buddy_info_hud()
	
	blinking_icon_fix.get_gui_manager();
	if blinking_icon_fix.gui_manager == nil then
		return;
	end
	
	local gui_hud = get_ref_gui_hud_method:call(blinking_icon_fix.gui_manager);
	if gui_hud == nil then
		customization_menu.status = "[buddy_status_icon_fix.update_buddy_info_hud] No GUI HUD Object";
		return;
	end

	local buddy_info_list = buddy_info_list_field:get_data(gui_hud);
	if buddy_info_list == nil then
		customization_menu.status = "[buddy_status_icon_fix.update_buddy_info_hud] No Buddy Info List";
	else
		this.fix_buddy_list(buddy_info_list, last_timer_values.players, config.current_config.status_icons.other_players);
	end

	local buddy_servant_info_list = buddy_servant_info_list_field:get_data(gui_hud);
	if buddy_servant_info_list == nil then
		customization_menu.status = "[buddy_status_icon_fix.update_buddy_info_hud] No Buddy Servant Info List";
	else
		this.fix_buddy_list(buddy_servant_info_list, last_timer_values.servants, config.current_config.status_icons.servants);
	end

	local buddy_otomo_info_list = buddy_otomo_info_list_field:get_data(gui_hud);
	if buddy_otomo_info_list == nil then
		customization_menu.status = "[buddy_status_icon_fix.update_buddy_info_hud] No Buddy Otomo Info List";
	else
		this.fix_buddy_list(buddy_otomo_info_list, last_timer_values.otomos, config.current_config.status_icons.otomos);
	end
end

function this.init_module()
	utils = require("No_More_Blinking_Icons.utils");
	config = require("No_More_Blinking_Icons.config");
	customization_menu = require("No_More_Blinking_Icons.customization_menu");
	blinking_icon_fix = require("No_More_Blinking_Icons.blinking_icon_fix");
	buddy_weapon_icon_fix = require("No_More_Blinking_Icons.buddy_weapon_icon_fix");

	sdk.hook(
		update_buddy_info_hud_method, function()
		end, function(retval)
			if config.current_config.enabled then
				this.post_update_buddy_info_hud();
				buddy_weapon_icon_fix.update_icon_frames();
			end
			
			return retval;
		end
	);
end

return this;