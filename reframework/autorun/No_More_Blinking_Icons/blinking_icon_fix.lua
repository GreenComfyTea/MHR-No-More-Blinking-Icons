local blinking_icon_fix = {};

local config;
local customization_menu;
local table_helpers;

local gui_manager_type_def = sdk.find_type_definition("snow.gui.GuiManager");
local get_ref_gui_hud_method = gui_manager_type_def:get_method("get_refGuiHud");

local panel_type_def = sdk.find_type_definition("via.gui.Panel");
local get_component_method = panel_type_def:get_method("get_Component");

local gui_type_def = sdk.find_type_definition("via.gui.GUI");
local set_play_speed_method = gui_type_def:get_method("set_PlaySpeed");

blinking_icon_fix.gui_manager = nil;

function blinking_icon_fix.get_gui_manager()
	if blinking_icon_fix.gui_manager == nil then
		blinking_icon_fix.gui_manager = sdk.get_managed_singleton("snow.gui.GuiManager");

		if blinking_icon_fix.gui_manager == nil then
			customization_menu.status = "No GUI Manager";
			return;
		end
	end	
end

function blinking_icon_fix.set_timer_value(icon_object, timer_field, is_displayed_field, timer_field_name, last_timer_value, status_icons)
	if last_timer_value == nil then
		customization_menu.status = "No Last Timer Value";
		return 0;
	end
	
	if icon_object == nil then
		customization_menu.status = "No Icon Object";
		return last_timer_value;
	end

	local is_displayed = is_displayed_field:get_data(icon_object);
	if is_displayed == nil then
		customization_menu.status = "No is_displayed Field";
		return last_timer_value;
	end

	local timer_value = timer_field:get_data(icon_object);
	if timer_value == nil then
		customization_menu.status = "No Timer Value Field";
		return last_timer_value;
	end

	if timer_value < last_timer_value then
		return timer_value;
	end

	if status_icons.mode == "Always Adjusted" then
		if is_displayed then
			local new_timer_value = last_timer_value + status_icons.displayed_icon_update_speed;
			icon_object:set_field(timer_field_name, new_timer_value);
			return new_timer_value;
		else
			local new_timer_value = last_timer_value + status_icons.hidden_icon_update_speed;
			icon_object:set_field(timer_field_name, new_timer_value);
			return timer_value;
		end
	elseif status_icons.mode == "Adjusted when Visible" then
		if is_displayed then
			local new_timer_value = last_timer_value + status_icons.displayed_icon_update_speed;
			icon_object:set_field(timer_field_name, new_timer_value);
			return new_timer_value;
		else
			return timer_value;
		end

	elseif status_icons.mode == "Adjusted when Hidden" then
		if is_displayed then
			return timer_value;
		else
			local new_timer_value = last_timer_value + status_icons.hidden_icon_update_speed;
			icon_object:set_field(timer_field_name, new_timer_value);
			return new_timer_value;
		end

	elseif status_icons.mode == "Always Visible" then
		if is_displayed then
			icon_object:set_field(timer_field_name, last_timer_value);
			return last_timer_value;
		end

	elseif status_icons.mode == "Always Hidden" then
		if not is_displayed then
			icon_object:set_field(timer_field_name, last_timer_value);
			return last_timer_value;
		end
	end

	return timer_value;
end

function blinking_icon_fix.set_play_speed(panel, new_speed)
	if new_speed < 0 then
		new_speed = 0;
	end

	new_speed = new_speed + .0;

	local component = get_component_method:call(panel);
	if component == nil then
		customization_menu.status = "No Panel Component";
		return;
	end

	set_play_speed_method:call(component, new_speed);
end

function blinking_icon_fix.init_module()
	table_helpers = require("No_More_Blinking_Icons.table_helpers");
	config = require("No_More_Blinking_Icons.config");
	customization_menu = require("No_More_Blinking_Icons.customization_menu");
end

return blinking_icon_fix;