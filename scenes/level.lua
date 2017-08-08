local level = {}

local function attachTowerToRoom(room)
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

function level:enter()
  self.room = Room(40, 200, 700, 500)
  attachTowerToRoom(self.room)
  
  self.room:fromConfig(G.lvl.level1)
  
  GS = GameStats()
  GS:registerSignals()
  
end

function level:keypressed(key)
  if key == 'space' then
    self.room:togglePause()
  end
  
end

function level:mousepressed(x, y, button, istouch)
  local ix, iy
  
  if suit.mouseInRect(self.room.offset.x, self.room.offset.y, self.room.size.x, self.room.size.y) then
    ix, iy = self.room:xy2cell(x,y)
    if button == 1 then
      self.room:getGrid():setWall(ix, iy)
    elseif button == 2 then
      self.room:addTower(ix, iy, "Canon")
    end
    self.room:updateIA()  
  end
  
end

function level:update(dt)
  
  suit.layout:reset(40, 700)
  suit.layout:padding(5,5)
  suit.Button('coucou', suit.layout:row(200,30))
  local handles = { 
    canon=suit.ImageButton(assets.towers_c, suit.layout:col(64,64)),
    laser=suit.ImageButton(assets.towers_l, suit.layout:col()),
    nuclear=suit.ImageButton(assets.towers_n, suit.layout:col()),
    freezer=suit.ImageButton(assets.towers_f, suit.layout:col()),
    boost=suit.ImageButton(assets.towers_b, suit.layout:col()),
    crusher=suit.ImageButton(assets.towers_r, suit.layout:col())}
  
  for k,h in pairs(handles) do
    if h.entered then
      print('hit',k)
    end
  end
  
  
  
  self.room:update(dt)  
end

function level:draw()
  love.graphics.print("Current FPS: "..tostring(love.timer.getFPS( )), 10, 10)
  GS:draw()
	self.room:draw()  
  suit.draw()
end

return level