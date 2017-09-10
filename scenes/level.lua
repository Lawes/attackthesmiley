local level = {}

local function attachTowerToRoom(room)
  print('attach')
  for name, class in pairs(G.tower) do
    print(name)
    if class.getCible_ then
      class.getCible = function(...) 
        local ie = class.getCible_(room.ia, ...)
        return room.EM:get(ie)
      end
    elseif class.getCibleXY_ then
      class.getCible = function(...) 
        return class.getCibleXY_(room.ia, ...)
      end      
    end
    if _G[name] then
      _G[name].params = class
    end
    
  end

end

function level:enter()
  self.ui_select=nil
  
  self.room = Room(40, 200, 700, 500)
  attachTowerToRoom(self.room)
  
  self.room:fromConfig(G.lvl.level1)
  
  GS = GameStats()
  GS:registerSignals()
  
end

function level:keypressed(key)
  if key == 'space' then
    self.room:togglePause()
  elseif key == 'u' then
    self.room:upgradeTowers()
  end
  
end

function level:mousemoved( x, y, dx, dy, istouch) 

end

function level:mousepressed(x, y, button, istouch)
  if suit.mouseInRect(self.room.offset.x, self.room.offset.y, self.room.size.x, self.room.size.y)
     and button == 1 then
    local ix, iy = self.room:xy2cell(x,y)
	if self.room:isFree(ix, iy) then
	  print('build',self.ui_select)
	  self.room:putBuilding(ix, iy, self.ui_select or 'Wall')
      self.room:updateIA()  
	end
  end
  
end

local function mydraw(r, g, b, img, x, y)
	return function(img, x, y)
		love.graphics.setColor(255, 255, 255)
		love.graphics.draw(img,x,y)
		love.graphics.setLineWidth(5)
    love.graphics.setColor(r,g,b)
		love.graphics.rectangle('line', x, y, img:getWidth(), img:getHeight())
	end
end

function level:update(dt)
  love.graphics.setColor(255,255,255)
  suit.layout:reset(40, 730)
  suit.layout:padding(10)
  if suit.Button('reset', suit.layout:row(100,30)).hit then
	self.ui_select=nil
  end
  
  local handles = {}
  for k,w in pairs(G.tower) do
    local color = {255,255,255}
    if self.ui_select==k then
      color = {255,0,0}
    end
      
    handles[k] = suit.ImageButton(assets[w.imgname.."_g"], {active=assets[w.imgname], draw=mydraw(unpack(color))}, suit.layout:col(64,64))
  end
  
  for k,h in pairs(handles) do
    if h.hit then
      self.ui_select=k	  
      print('hit',k)
    end
  end
  
  
  
  self.room:update(dt)
  
  if suit.mouseInRect(self.room.offset.x, self.room.offset.y, self.room.size.x, self.room.size.y) then
    if self.ui_select then
	
      local ix, iy = self.room:xy2cell(love.mouse.getPosition())
      local color = {0,255,0}
      if self.room:isFree(ix, iy) then
        color = {0,0,255}
      end
      self.plot_select = {img=assets[G.tower[self.ui_select].imgname], x=ix, y=iy, color=color}
    end
  else
	self.plot_select = nil
  end
  
end

function level:draw()
  love.graphics.print("Current FPS: "..tostring(love.timer.getFPS( )), 10, 10)
  GS:draw()
  if self.plot_select then
    self.room:addtodraw(self.plot_select)
  end
  self.room:draw()  

	
  suit.draw()
end

return level