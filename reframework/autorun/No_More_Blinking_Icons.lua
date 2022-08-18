local table_helpers = require("No_More_Blinking_Icons.table_helpers");
local config = require("No_More_Blinking_Icons.config");

local customization_menu = require("No_More_Blinking_Icons.customization_menu");
local native_customization_menu = require("No_More_Blinking_Icons.native_customization_menu");

local blinking_icon_fix = require("No_More_Blinking_Icons.blinking_icon_fix");
local player_status_icon_fix = require("No_More_Blinking_Icons.player_status_icon_fix");
local player_weapon_icon_fix = require("No_More_Blinking_Icons.player_weapon_icon_fix");
local buddy_status_icon_fix = require("No_More_Blinking_Icons.buddy_status_icon_fix");
local buddy_weapon_icon_fix = require("No_More_Blinking_Icons.buddy_weapon_icon_fix");

table_helpers.init_module();
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

re.on_frame(function()
	if not reframework:is_drawing_ui() then
		customization_menu.is_opened = false;
	end

	if customization_menu.is_opened then
		pcall(customization_menu.draw);
	end
end);