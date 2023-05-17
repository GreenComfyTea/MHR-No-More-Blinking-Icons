local this = {};

local utils;
local config;
local customization_menu;
local player_status_icon_fix;

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

local mod_menu_api_package_name = "ModOptionsMenu.ModMenuApi";
local mod_menu = nil;

local native_UI = nil;

local status_icon_mode_descriptions = {
	"Set Status Icon Blinking Mode to \"Normal\".",
	"Set Status Icon Blinking Mode to \"Always Adjusted\".",
	"Set Status Icon Blinking Mode to \"Adjusted when\nVisible\".",
	"Set Status Icon Blinking Mode to \"Adjusted when\nHidden\".",
	"Set Status Icon Blinking Mode to \"Always Visible\".",
	"Set Status Icon Blinking Mode to \"Always Hidden\"."
};

local player_weapon_icon_mode_descriptions = {
	"Set Player's Weapon/Discovered/Ready Icon Blinking\nMode to \"Normal\".",
	"Set Player's Weapon/Discovered/Ready Icon Blinking\nMode to \"Always Adjusted\".",
	"Set Player's Weapon/Discovered/Ready Icon Blinking\nMode to \"Adjusted when Visible\".",
	"Set Player's Weapon/Discovered/Ready Icon Blinking\nMode to \"Adjusted when Weapon Icon Visible\".",
	"Set Player's Weapon/Discovered/Ready Icon Blinking\nMode to \"Adjusted when Discovered Icon Visible\".",
	"Set Player's Weapon/Discovered/Ready Icon Blinking\nMode to \"Adjusted when Ready Icon Visible\".",
	"Set Player's Weapon/Discovered/Ready Icon Blinking\nMode to \"Adjusted when Hidden\".",
	"Set Player's Weapon/Discovered/Ready Icon Blinking\nMode to \"Always Visible Weapon Icon\".",
	"Set Player's Weapon/Discovered/Ready Icon Blinking\nMode to \"Always Visible Discovered Icon\".",
	"Set Player's Weapon/Discovered/Ready Icon Blinking\nMode to \"Always Visible Ready Icon\".",
	"Set Player's Weapon/Discovered/Ready Icon Blinking\nMode to \"Always Hidden\"."
};

local others_weapon_icon_mode_descriptions = {
	"Set Others' Weapon/Discovered/Ready Icon Blinking\nMode to \"Normal\".",
	"Set Others' Weapon/Discovered/Ready Icon Blinking\nMode to \"Always Adjusted\".",
	"Set Others' Weapon/Discovered/Ready Icon Blinking\nMode to \"Adjusted when Visible\".",
	"Set Others' Weapon/Discovered/Ready Icon Blinking\nMode to \"Adjusted when Weapon Icon Visible\".",
	"Set Others' Weapon/Discovered/Ready Icon Blinking\nMode to \"Adjusted when Discovered Icon Visible\".",
	"Set Others' Weapon/Discovered/Ready Icon Blinking\nMode to \"Adjusted when Host Icon Visible\".",
	"Set Others' Weapon/Discovered/Ready Icon Blinking\nMode to \"Adjusted when Hidden\".",
	"Set Others' Weapon/Discovered/Ready Icon Blinking\nMode to \"Always Visible Weapon Icon\".",
	"Set Others' Weapon/Discovered/Ready Icon Blinking\nMode to \"Always Visible Discovered Icon\".",
	"Set Others' Weapon/Discovered/Ready Icon Blinking\nMode to \"Always Visible Host Icon\".",
	"Set Others' Weapon/Discovered/Ready Icon Blinking\nMode to \"Always Hidden\"."
};

--no idea how this works but google to the rescue
--can use this to check if the api is available and do an alternative to avoid complaints from users
function this.is_module_available(name)
	if package.loaded[name] then
		return true;
	else
		for _, searcher in ipairs(package.searchers or package.loaders) do
			local loader = searcher(name);

			if type(loader) == 'function' then
				package.preload[name] = loader;
				return true;
			end
		end

		return false;
	end
end

function this.draw()
	local changed = false;
	local config_changed = false;
	local new_value = 0;
	local index = 0; 

	mod_menu.Label("Created by: <COL RED>GreenComfyTea</COL>", "",
		"Donate: <COL RED>https://streamelements.com/greencomfytea/tip</COL>\nBuy me a tea: <COL RED>https://ko-fi.com/greencomfytea</COL>\nSometimes I stream: <COL RED>twitch.tv/greencomfytea</COL>");
	mod_menu.Label("Version: <COL RED>" .. config.current_config.version .. "</COL>", "",
		"Donate: <COL RED>https://streamelements.com/greencomfytea/tip</COL>\nBuy me a tea: <COL RED>https://ko-fi.com/greencomfytea</COL>\nSometimes I stream: <COL RED>twitch.tv/greencomfytea</COL>");

	--imgui.text("Status: " .. tostring(customization_menu.status));

	if true then
		mod_menu.Header("Global Settings");

		changed, config.current_config.enabled = mod_menu.CheckBox("Enabled", config.current_config.enabled, "Enable/Disable \"No More Blinking Icons\" Mod.\n");
		config_changed = config_changed or changed;

		if mod_menu.Button("", "Reset Config", false, "Reset All Values to Default.") then
			config.reset();
			config_changed = true;

			mod_menu.Repaint();
		end
	end

	if true then
		mod_menu.Header("Status Icons - Player");

		changed, index = mod_menu.Options("Mode",
			utils.table.find_index(customization_menu.status_icon_modes, config.current_config.status_icons.player.mode),
			customization_menu.status_icon_modes,
			status_icon_mode_descriptions,
			"Adjust Player Status Icon Blinking Mode.");
		config_changed = config_changed or changed;

		if changed then
			config.current_config.status_icons.player.mode = customization_menu.status_icon_modes[index];
		end
		
		changed, new_value = mod_menu.FloatSlider("Displayed Icon Timer Speed (x10)",
			config.current_config.status_icons.player.displayed_icon_timer_speed * 10, 0, 10, "Adjust Icon Timer Speed when it's displayed.\nDisplayed value is 10 times bigger than the real one.");
		config_changed = config_changed or changed;

		if changed then
			config.current_config.status_icons.player.displayed_icon_timer_speed = new_value / 10;
		end

		changed, new_value = mod_menu.FloatSlider("Hidden Icon Timer Speed (x10)",
			config.current_config.status_icons.player.hidden_icon_timer_speed * 10, 0, 10, "Adjust Icon Timer Speed when it's hidden.\nDisplayed value is 10 times bigger than the real one.");
		config_changed = config_changed or changed;

		if changed then
			config.current_config.status_icons.player.hidden_icon_timer_speed  = new_value / 10;
		end
	end

	if true then
		mod_menu.Header("Status Icons - Other Players");

		changed, index = mod_menu.Options("Mode",
			utils.table.find_index(customization_menu.status_icon_modes, config.current_config.status_icons.other_players.mode),
			customization_menu.status_icon_modes,
			status_icon_mode_descriptions,
			"Adjust Other Player Status Icon Blinking Mode.");
		config_changed = config_changed or changed;

		if changed then
			config.current_config.status_icons.other_players.mode = customization_menu.status_icon_modes[index];
		end
		
		changed, new_value = mod_menu.FloatSlider("Displayed Icon Timer Speed (x10)",
			config.current_config.status_icons.other_players.displayed_icon_timer_speed * 10, 0, 10, "Adjust Icon Timer Speed when it's displayed.\nDisplayed value is 10 times bigger than the real one.");
		config_changed = config_changed or changed;

		if changed then
			config.current_config.status_icons.other_players.displayed_icon_timer_speed = new_value / 10;
		end

		changed, new_value = mod_menu.FloatSlider("Hidden Icon Timer Speed (x10)",
			config.current_config.status_icons.other_players.hidden_icon_timer_speed * 10, 0, 10, "Adjust Icon Timer Speed when it's hidden.\nDisplayed value is 10 times bigger than the real one.");
		config_changed = config_changed or changed;

		if changed then
			config.current_config.status_icons.other_players.hidden_icon_timer_speed  = new_value / 10;
		end
	end

	if true then
		mod_menu.Header("Status Icons - Followers");

		changed, index = mod_menu.Options("Mode",
			utils.table.find_index(customization_menu.status_icon_modes, config.current_config.status_icons.servants.mode),
			customization_menu.status_icon_modes,
			status_icon_mode_descriptions,
			"Adjust Follower Status Icon Blinking Mode.");
		config_changed = config_changed or changed;

		if changed then
			config.current_config.status_icons.servants.mode = customization_menu.status_icon_modes[index];
		end
		
		changed, new_value = mod_menu.FloatSlider("Displayed Icon Timer Speed (x10)",
			config.current_config.status_icons.servants.displayed_icon_timer_speed * 10, 0, 10, "Adjust Icon Timer Speed when it's displayed.\nDisplayed value is 10 times bigger than the real one.");
		config_changed = config_changed or changed;

		if changed then
			config.current_config.status_icons.servants.displayed_icon_timer_speed = new_value / 10;
		end

		changed, new_value = mod_menu.FloatSlider("Hidden Icon Timer Speed (x10)",
			config.current_config.status_icons.servants.hidden_icon_timer_speed * 10, 0, 10, "Adjust Icon Timer Speed when it's hidden.\nDisplayed value is 10 times bigger than the real one.");
		config_changed = config_changed or changed;

		if changed then
			config.current_config.status_icons.servants.hidden_icon_timer_speed  = new_value / 10;
		end
	end

	if true then
		mod_menu.Header("Status Icons - Buddies");

		changed, index = mod_menu.Options("Mode",
			utils.table.find_index(customization_menu.status_icon_modes, config.current_config.status_icons.otomos.mode),
			customization_menu.status_icon_modes,
			status_icon_mode_descriptions,
			"Adjust Buddy Status Icon Blinking Mode.");
		config_changed = config_changed or changed;

		if changed then
			config.current_config.status_icons.otomos.mode = customization_menu.status_icon_modes[index];
		end
		
		changed, new_value = mod_menu.FloatSlider("Displayed Icon Timer Speed (x10)",
			config.current_config.status_icons.otomos.displayed_icon_timer_speed * 10, 0, 10, "Adjust Icon Timer Speed when it's displayed.\nDisplayed value is 10 times bigger than the real one.");
		config_changed = config_changed or changed;

		if changed then
			config.current_config.status_icons.otomos.displayed_icon_timer_speed = new_value / 10;
		end

		changed, new_value = mod_menu.FloatSlider("Hidden Icon Timer Speed (x10)",
			config.current_config.status_icons.otomos.hidden_icon_timer_speed * 10, 0, 10, "Adjust Icon Timer Speed when it's hidden.\nDisplayed value is 10 times bigger than the real one.");
		config_changed = config_changed or changed;

		if changed then
			config.current_config.status_icons.otomos.hidden_icon_timer_speed  = new_value / 10;
		end
	end

	if true then
		mod_menu.Header("Weapon Icons - Player");

		changed, index = mod_menu.Options("Mode",
			utils.table.find_index(customization_menu.player_weapon_icon_modes, config.current_config.weapon_icons.player.mode),
			customization_menu.player_weapon_icon_modes,
			player_weapon_icon_mode_descriptions,
			"Adjust Player's Weapon/Discovered/Ready Icon\nBlinking Mode.");
		config_changed = config_changed or changed;

		if changed then
			config.current_config.weapon_icons.player.mode = customization_menu.player_weapon_icon_modes[index];
		end
		
		changed, config.current_config.weapon_icons.player.weapon_icon_frame_speed = mod_menu.FloatSlider("Weapon Icon Frame Speed",
			config.current_config.weapon_icons.player.weapon_icon_frame_speed, 0, 2, "Adjust Player's Weapon Icon Frame Speed.");
		config_changed = config_changed or changed;

		changed, config.current_config.weapon_icons.player.discovered_icon_frame_speed = mod_menu.FloatSlider("Discovered Icon Frame Speed",
			config.current_config.weapon_icons.player.discovered_icon_frame_speed, 0, 2, "Adjust Player's Discovered Icon Frame Speed.");
		config_changed = config_changed or changed;

		changed, config.current_config.weapon_icons.player.ready_icon_frame_speed = mod_menu.FloatSlider("Ready Icon Frame Speed",
			config.current_config.weapon_icons.player.ready_icon_frame_speed, 0, 2, "Adjust Player's Ready Icon Frame Speed.");
		config_changed = config_changed or changed;

		changed, config.current_config.weapon_icons.player.hidden_icon_frame_speed = mod_menu.FloatSlider("Hidden Icon Frame Speed",
			config.current_config.weapon_icons.player.hidden_icon_frame_speed, 0, 2, "Adjust Player's Hidden Icon Frame Speed.");
		config_changed = config_changed or changed;
	end

	if true then
		mod_menu.Header("Weapon Icons - Others");

		changed, index = mod_menu.Options("Mode",
		utils.table.find_index(customization_menu.others_weapon_icon_modes, config.current_config.weapon_icons.others.mode),
			customization_menu.others_weapon_icon_modes,
			others_weapon_icon_mode_descriptions,
			"Adjust Others' Weapon/Discovered/Host Icon\nBlinking Mode.");
		config_changed = config_changed or changed;

		if changed then
			config.current_config.weapon_icons.others.mode = customization_menu.others_weapon_icon_modes[index];
		end

		changed, config.current_config.weapon_icons.others.weapon_icon_frame_speed = mod_menu.FloatSlider("Weapon Icon Frame Speed",
			config.current_config.weapon_icons.others.weapon_icon_frame_speed, 0, 2, "Adjust Others' Weapon Icon Frame Speed");
		config_changed = config_changed or changed;

		changed, config.current_config.weapon_icons.others.discovered_icon_frame_speed = mod_menu.FloatSlider("Discovered Icon Frame Speed",
			config.current_config.weapon_icons.others.discovered_icon_frame_speed, 0, 2, "Adjust Others' Discovered Icon Frame Speed.");
		config_changed = config_changed or changed;

		changed, config.current_config.weapon_icons.others.host_icon_frame_speed = mod_menu.FloatSlider("Host Icon Frame Speed",
			config.current_config.weapon_icons.others.host_icon_frame_speed, 0, 2, "Adjust Others' Host Icon Frame Speed.");
		config_changed = config_changed or changed;

		changed, config.current_config.weapon_icons.others.hidden_icon_frame_speed = mod_menu.FloatSlider("Hidden Icon Frame Speed",
			config.current_config.weapon_icons.others.hidden_icon_frame_speed, 0, 2, "Adjust Others' Hidden Icon Frame Speed.");
	end

	if config_changed then
		config.save();
	end
end

function this.on_reset_all_settings()
	config.current_config = utils.table.deep_copy(config.default_config);
end

function this.init_module()
	utils = require("No_More_Blinking_Icons.utils");
	config = require("No_More_Blinking_Icons.config");
	customization_menu = require("No_More_Blinking_Icons.customization_menu");
	player_status_icon_fix = require("No_More_Blinking_Icons.player_status_icon_fix");

	if this.is_module_available(mod_menu_api_package_name) then
		mod_menu = require(mod_menu_api_package_name);
	end

	if mod_menu == nil then
		log.info("[No More Blinking Icons] No mod_menu_api API package found. You may need to download it or something.");
		return;
	end

	native_UI = mod_menu.OnMenu(
		"No More Blinking Icons",
		"Fixes insane status and weapon icon blinking. No more\nepilepsy.",
		this.draw
	);

	native_UI.OnResetAllSettings = this.on_reset_all_settings;

end

return this;
