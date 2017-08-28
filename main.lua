Object = require 'lib/classic'

suit = require 'lib/suit'

vector = require "lib/hump.vector-light"
Timer = require 'lib/hump.timer'
Signal = require 'lib/hump.signal'
Gamestate = require 'lib/hump.gamestate'
Lume = require 'lib/lume'

assets = require('lib/cargo').init('assets')

-- local profile = require("lib/profile")

io.stdout:setvbuf("no")

level = require 'scenes/level'

local function loadConfigs()
  G = {}
  G.smiley = require('global/enemy_config')
  G.tower = require('global/tower_config')
  G.lvl = require('global/level_config')
  G.wave = require('global/wave_config')
end


local function recursiveEnumerate(folder, file_list)
    local items = love.filesystem.getDirectoryItems(folder)
    for _, item in ipairs(items) do
        local file = folder .. '/' .. item
        if love.filesystem.isFile(file) then
            table.insert(file_list, file)
        elseif love.filesystem.isDirectory(file) then
            recursiveEnumerate(file, file_list)
        end
    end
end

local function requireFiles(files)
    for _, file in ipairs(files) do
        local basefile = file:sub(1, -5)
        require(basefile)
    end
end



function love.load()
  local object_files = {}
  recursiveEnumerate('objects', object_files)
	requireFiles(object_files)
  
  loadConfigs()
  
  -- profile.hookall("Lua")
  -- profile.start()
  

	love.graphics.setNewFont(12)
  love.graphics.setBackgroundColor(0,0,0)

  Gamestate.registerEvents()
  Gamestate.switch(level)

end

