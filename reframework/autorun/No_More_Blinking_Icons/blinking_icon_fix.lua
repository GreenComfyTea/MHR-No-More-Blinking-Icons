local this = {};

local config;
local customization_menu;
local utils;

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

local panel_type_def = sdk.find_type_definition("via.gui.Panel");
local panel_get_actual_visible_method = panel_type_def:get_method("get_ActualVisible");
local set_play_frame_method = panel_type_def:get_method("set_PlayFrame");
local get_play_frame_method = panel_type_def:get_method("get_PlayFrame");
local get_play_state_method = panel_type_def:get_method("get_PlayState");

local texture_type_def = sdk.find_type_definition("via.gui.Texture");
local texture_get_actual_visible_method = texture_type_def:get_method("get_ActualVisible");

local gui_type_def = sdk.find_type_definition("via.gui.GUI");
local set_play_speed_method = gui_type_def:get_method("set_PlaySpeed");

this.gui_manager = nil;
local gui_manager_name = "snow.gui.GuiManager";

local FRAME_ADDITION = 3;

local status_icon_modes = {
	NORMAL = "Normal",
	ALWAYS_ADJUSTED = "Always Adjusted",
	ADJUSTED_WHEN_VISIBLE = "Adjusted when Visible",
	ADJUSTED_WHEN_HIDDEN = "Adjusted when Hidden",
	ALWAYS_VISIBLE = "Always Visible",
	ALWAYS_HIDDEN = "Always Hidden"
};

local weapon_icon_modes = {
	NORMAL = "Normal",
	ALWAYS_ADJUSTED = "Always Adjusted",
	ADJUSTED_WHEN_VISIBLE = "Adjusted when Visible",
	ADJUSTED_WHEN_WEAPON_ICON_VISIBLE = "Adjusted when Weapon Icon Visible",
	ADJUSTED_WHEN_DISCOVERED_ICON_VISIBLE = "Adjusted when Discovered Icon Visible",
	ADJUSTED_WHEN_READY_ICON_VISIBLE = "Adjusted when Ready Icon Visible",
	ADJUSTED_WHEN_HOST_ICON_VISIBLE = "Adjusted when Host Icon Visible",
	ADJUSTED_WHEN_HIDDEN = "Adjusted when Hidden",
	ALWAYS_VISIBLE_WEAPON_ICON = "Always Visible Weapon Icon",
	ALWAYS_VISIBLE_DISCOVERED_ICON = "Always Visible Discovered Icon",
	ALWAYS_VISIBLE_READY_ICON = "Always Visible Ready Icon",
	ALWAYS_HIDDEN = "Always Hidden"
};

local play_states = {
	DEFAULT = "DEFAULT",					-- DEFAULT = Weapon
	FOUND = "FOUND",						-- FOUND = Weapon + Discovery
	NOT_FOUND = "NOTFOUND",					-- NOTFOUND = Weapon + Ready
	ALL = "ALL",							-- ALL = Weapon + Discover + Ready
	READY = "Ready",						-- Ready = Ready
	DEFAULT_META_HW = "DEFAULT_metaHW",		-- DEFAULT_META_HW = Weapon
	FOUND_META_HW = "FOUND_metaHW",			-- FOUND_META_HW = Weapon + Discovery
	NOT_FOUND_META_HW = "NOTFOUND_metaHW",	-- NOTFOUND_META_HW = Weapon + Ready
	ALL_META_HW = "ALL_metaHW",				-- ALL_META_HW = Weapon + Discovery + Ready
};

function this.get_gui_manager()
	if this.gui_manager == nil then
		this.gui_manager = sdk.get_managed_singleton(gui_manager_name);

		if this.gui_manager == nil then
			customization_menu.status = "[blinking_icon_fix.get_gui_manager] No GUI Manager";
			return;
		end
	end	
end

function this.set_timer_value(icon_object, timer_field, is_displayed_field, timer_field_name, last_timer_value, status_icon_config)
	if last_timer_value == nil then
		customization_menu.status = "[blinking_icon_fix.set_timer_value] No Last Timer Value";
		return 0;
	end

	local is_displayed = is_displayed_field:get_data(icon_object);
	if is_displayed == nil then
		customization_menu.status = "[blinking_icon_fix.set_timer_value] No is_displayed Field";
		return last_timer_value;
	end

	local timer_value = timer_field:get_data(icon_object);
	if timer_value == nil then
		customization_menu.status = "[blinking_icon_fix.set_timer_value] No Timer Value Field";
		return last_timer_value;
	end

	if timer_value < last_timer_value then
		return timer_value;
	end

	local new_timer_value = last_timer_value;

	if is_displayed then
		new_timer_value = last_timer_value + status_icon_config.displayed_icon_timer_speed;
	else
		new_timer_value = last_timer_value + status_icon_config.hidden_icon_timer_speed;
	end

	if status_icon_config.mode == status_icon_modes.ALWAYS_ADJUSTED then
		icon_object:set_field(timer_field_name, new_timer_value);
		return new_timer_value;

	elseif status_icon_config.mode == status_icon_modes.ADJUSTED_WHEN_VISIBLE then
		if is_displayed then
			icon_object:set_field(timer_field_name, new_timer_value);
			return new_timer_value;
		end

	elseif status_icon_config.mode == status_icon_modes.ADJUSTED_WHEN_HIDDEN then
		if not is_displayed then
			icon_object:set_field(timer_field_name, new_timer_value);
			return new_timer_value;
		end

	elseif status_icon_config.mode == status_icon_modes.ALWAYS_VISIBLE then
		if is_displayed then
			icon_object:set_field(timer_field_name, last_timer_value);
			return last_timer_value;
		end

	elseif status_icon_config.mode == status_icon_modes.ALWAYS_HIDDEN then
		if not is_displayed then
			icon_object:set_field(timer_field_name, last_timer_value);
			return last_timer_value;
		end
	end

	return timer_value;
end

function this.set_play_frame(icon_change_panel, weapon_icon_panel, discovered_icon_texture, ready_icon_panel, host_icon_texture, last_play_frame, weapon_icon_config)

	if last_play_frame == nil then
		customization_menu.status = "[blinking_icon_fix.set_play_frame] No Last Play Frame";
		return 0;
	end

	local is_showing_weapon_icon = panel_get_actual_visible_method:call(weapon_icon_panel);
	if is_showing_weapon_icon == nil then
		customization_menu.status = "[blinking_icon_fix.set_play_frame] No Weapon Icon Visible";
		return last_play_frame;
	end

	local is_showing_discovered_icon = texture_get_actual_visible_method:call(discovered_icon_texture);
	if is_showing_discovered_icon == nil then
		customization_menu.status = "[blinking_icon_fix.set_play_frame] No Discovered Icon Visible";
		return last_play_frame;
	end

	local is_showing_ready_icon = false;
	if ready_icon_panel ~= nil then
		is_showing_ready_icon = panel_get_actual_visible_method:call(ready_icon_panel);
		if is_showing_ready_icon == nil then
			customization_menu.status = "[blinking_icon_fix.set_play_frame] No Ready Icon Visible";
			return last_play_frame;
		end
	end

	local is_showing_host_icon = false;
	if host_icon_texture ~= nil then
		is_showing_host_icon = panel_get_actual_visible_method:call(host_icon_texture);
		if is_showing_host_icon == nil then
			customization_menu.status = "[blinking_icon_fix.set_play_frame] No Host Icon Visible";
			return last_play_frame;
		end
	end

	local play_frame = get_play_frame_method:call(icon_change_panel);
	if play_frame == nil then
		customization_menu.status = "[blinking_icon_fix.set_play_frame] No Icon Change Panel Play Frame";
		return last_play_frame;
	end

	if play_frame < last_play_frame then
		return play_frame;
	end

	local new_play_frame = last_play_frame;

	if is_showing_weapon_icon then
		new_play_frame = last_play_frame + weapon_icon_config.weapon_icon_frame_speed;
	elseif is_showing_discovered_icon then
		new_play_frame = last_play_frame + weapon_icon_config.discovered_icon_frame_speed;
	elseif is_showing_ready_icon then
		new_play_frame = last_play_frame + weapon_icon_config.ready_icon_frame_speed;
	elseif is_showing_host_icon then
		new_play_frame = last_play_frame + weapon_icon_config.host_icon_frame_speed;
	else
		new_play_frame = last_play_frame + weapon_icon_config.hidden_icon_frame_speed;
	end

	local play_state = get_play_state_method:call(icon_change_panel);
	if play_state == nil then
		customization_menu.status = "[blinking_icon_fix.set_play_frame] No Play State";
		return last_play_frame;
	end

	if weapon_icon_config.mode == weapon_icon_modes.ALWAYS_ADJUSTED then
		set_play_frame_method:call(icon_change_panel, new_play_frame);
		return new_play_frame;

	elseif weapon_icon_config.mode == weapon_icon_modes.ADJUSTED_WHEN_VISIBLE then
		if is_showing_weapon_icon or is_showing_discovered_icon or is_showing_ready_icon or is_showing_host_icon then

			set_play_frame_method:call(icon_change_panel, new_play_frame);
			return new_play_frame;
		end

	elseif weapon_icon_config.mode == weapon_icon_modes.ADJUSTED_WHEN_WEAPON_ICON_VISIBLE then
		if is_showing_weapon_icon then

			if play_state ~= play_states.READY then

				set_play_frame_method:call(icon_change_panel, new_play_frame);
				return new_play_frame;
			end
		end

	elseif weapon_icon_config.mode == weapon_icon_modes.ADJUSTED_WHEN_DISCOVERED_ICON_VISIBLE then
		if is_showing_discovered_icon then

			if play_state == play_states.FOUND
			or play_state == play_states.FOUND_META_HW
			or play_state == play_states.ALL
			or play_state == play_states.ALL_META_HW then

				set_play_frame_method:call(icon_change_panel, new_play_frame);
				return new_play_frame;
			end
		end

	elseif weapon_icon_config.mode == weapon_icon_modes.ADJUSTED_WHEN_READY_ICON_VISIBLE then
		if is_showing_ready_icon then

			if play_state == play_states.NOT_FOUND
			or play_state == play_states.NOT_FOUND_META_HW
			or play_state == play_states.ALL
			or play_state == play_states.ALL_META_HW then

				set_play_frame_method:call(icon_change_panel, new_play_frame);
				return new_play_frame;
			end
		end

	elseif weapon_icon_config.mode == weapon_icon_modes.ADJUSTED_WHEN_HOST_ICON_VISIBLE then
		if is_showing_host_icon then

			set_play_frame_method:call(icon_change_panel, new_play_frame);
			return new_play_frame;
		end

	elseif weapon_icon_config.mode == weapon_icon_modes.ADJUSTED_WHEN_HIDDEN then
		if not is_showing_weapon_icon
		and not is_showing_discovered_icon
		and not is_showing_ready_icon
		and not is_showing_host_icon then

			set_play_frame_method:call(icon_change_panel, new_play_frame);
			return new_play_frame;
		end

	elseif weapon_icon_config.mode == weapon_icon_modes.ALWAYS_VISIBLE_WEAPON_ICON then
		if is_showing_weapon_icon then

			if play_state ~= play_states.READY then

				set_play_frame_method:call(icon_change_panel, last_play_frame + FRAME_ADDITION);
				return last_play_frame;
			end
		end

	elseif weapon_icon_config.mode == weapon_icon_modes.ALWAYS_VISIBLE_DISCOVERED_ICON then
		if is_showing_discovered_icon then

			if play_state == play_states.FOUND
			or play_state == play_states.FOUND_META_HW
			or play_state == play_states.ALL
			or play_state == play_states.ALL_META_HW then

				set_play_frame_method:call(icon_change_panel, last_play_frame + FRAME_ADDITION);
				return last_play_frame;
			end
		end

	elseif weapon_icon_config.mode == weapon_icon_modes.ALWAYS_VISIBLE_READY_ICON then
		if is_showing_ready_icon then

			if play_state == play_states.NOT_FOUND
			or play_state == play_states.NOT_FOUND_META_HW
			or play_state == play_states.ALL
			or play_state == play_states.ALL_META_HW then

				set_play_frame_method:call(icon_change_panel, last_play_frame + FRAME_ADDITION);
				return last_play_frame;
			end
		end

	elseif weapon_icon_config.mode == weapon_icon_modes.ALWAYS_HIDDEN then
		if not is_showing_weapon_icon
		and not is_showing_discovered_icon
		and not is_showing_ready_icon
		and not is_showing_host_icon then

			set_play_frame_method:call(icon_change_panel, last_play_frame + FRAME_ADDITION);
			return last_play_frame;
		end
	end

	return play_frame;

end

function this.init_module()
	utils = require("No_More_Blinking_Icons.utils");
	config = require("No_More_Blinking_Icons.config");
	customization_menu = require("No_More_Blinking_Icons.customization_menu");
end

return this;