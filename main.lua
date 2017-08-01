Object = require 'lib/classic'

vector = require "lib/hump.vector-light"
Timer = require 'lib/hump.timer'
Signal = require 'lib/hump.signal'
Lume = require 'lib/lume'

-- local profile = require("lib/profile")

io.stdout:setvbuf("no")


function loadConfigs()
  G = {}
  G.smiley = require('global/enemy_config')
  G.tower = require('global/tower_config')
  G.lvl = require('global/level_config')
end


function recursiveEnumerate(folder, file_list)
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

function requireFiles(files)
    for _, file in ipairs(files) do
        local basefile = file:sub(1, -5)
        require(basefile)
    end
end

function attachTowerToRoom(room)
  print('attach')
  for name, class in pairs(G.tower) do
    print(name)
    if class.getCible_ then
      class.getCible = function(...) 
        local ie = class.getCible_(room.ia, unpack(arg))
        return room.EM:get(ie)
      end
    end
    if _G[name] then
      _G[name].params = class
    end
    
  end

end

function love.load()
  local object_files = {}
  recursiveEnumerate('objects', object_files)
	requireFiles(object_files)
  
  loadConfigs()
  
  -- profile.hookall("Lua")
  -- profile.start()
  
  grid = Room()
  attachTowerToRoom(grid)
  
  grid:fromConfig(G.lvl.level1)

  
  GS = GameStats()
  GS:registerSignals()
  
	image = love.graphics.newImage("assets/wam.png")
	love.graphics.setNewFont(12)
 --  love.graphics.setColor(0,0,0)
  love.graphics.setBackgroundColor(0,0,0)

end


function love.keypressed(key)
  if key == 'space' then
    print('coucou')
    grid:togglePause()
  end
end

function love.update(dt)
  grid:update(dt)

end

function love.mousepressed(x, y, button, istouch)
  local ix, iy
  ix, iy = grid:xy2cell(x,y)
	if button == 1 then
    grid:getGrid():setWall(ix, iy)
  elseif button == 2 then
    grid:addTower(ix, iy, "Canon")
  end
  grid:updateIA()

end


function love.draw()
  love.graphics.print("Current FPS: "..tostring(love.timer.getFPS( )), 10, 10)
  GS:draw()
	grid:draw()
end
