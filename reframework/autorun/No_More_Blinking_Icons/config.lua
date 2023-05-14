local this = {};

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

this.current_config = nil;
this.config_file_name = "No More Blinking Icons/config.json";

this.default_config = {};

function this.init()
	this.default_config = {
		status_icons = {
			player = {
				mode = "Always Adjusted",
				displayed_icon_update_speed = 0.005,
				hidden_icon_update_speed = 0.01
			},

			other_players = {
				mode = "Always Adjusted",
				displayed_icon_update_speed = 0.005,
				hidden_icon_update_speed = 0.01
			},

			servants = {
				mode = "Always Adjusted",
				displayed_icon_update_speed = 0.005,
				hidden_icon_update_speed = 0.01
			},

			otomos = {
				mode = "Always Adjusted",
				displayed_icon_update_speed = 0.005,
				hidden_icon_update_speed = 0.01
			}
		},
		weapon_icons = {
			player = {
				mode = "Adjusted",
				icon_update_speed_multiplier = 0.2
			},

			others = {
				mode = "Adjusted",
				icon_update_speed_multiplier = 0.2
			}
		}
	};
end

function this.load()
	local loaded_config = json.load_file(this.config_file_name);
	if loaded_config ~= nil then
		log.info("[No More Blinking Icons] config.json loaded successfully");
		this.current_config = utils.merge(this.default_config, loaded_config);
	else
		log.error("[No More Blinking Icons] Failed to load config.json");
		this.current_config = utils.deep_copy(this.default_config);
	end
end

function this.save()
	-- save current config to disk, replacing any existing file
	local success = json.dump_file(this.config_file_name, this.current_config);
	if success then
		log.info("[No More Blinking Icons] config.json saved successfully");
	else
		log.error("[No More Blinking Icons] Failed to save config.json");
	end
end

function this.init_module()
	utils = require("No_More_Blinking_Icons.utils");

	this.init();
	this.load();
	this.current_config.version = "2.0";
end

return this;
