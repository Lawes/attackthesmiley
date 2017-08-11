Room = Object:extend()

Physics = require 'global/physics'


function Room:new(x, y, w, h)
  self.ncells = {x=1, y=1}
  self:setSize(w, h)
  self:setOffset(x, y)
  
  self.isPaused = true

  self.spawners = {}
  self.factors = {wall=10.0, body=5.0}
  
  self.ia = BodyIA()
  self.EM = EnemyManager()
  self.MM = MissileManager()
  Gtimer = Timer.new()
  
  self.allsmiley = {}
  for k,v in pairs(G.smiley) do
    self.allsmiley[#self.allsmiley+1] = k
  end
    
  
end

function Room:togglePause()
  self.isPaused = not self.isPaused
end

function Room:start()
  self.isPaused = false
end

function Room:pause()
  self.isPaused = true
end
  

function Room:fromConfig(lvl)
  
  self.ncells = lvl.ncells

  self.ia:init(self.ncells.x, self.ncells.y)
  self.grid = Grid(self.ncells.x, self.ncells.y)
  
  for _,item in pairs(lvl.walls) do
    self.grid:setWall(item[1], item[2])
  end
  for _,item in pairs(lvl.exits) do
    self.grid:setExit(item[1], item[2])
  end
  for _,item in pairs(lvl.spawners) do
    local s = Spawner(item[1], item[2], 10)
    s:togglePause()
    table.insert(self.spawners, s)
  end

  self:updateDxDy()
  
  self.towers = {}
  
  self:updateIA()
  
end

function Room:putBuilding(ix, iy, typeof)
  if typeof == 'Wall' then
    self.grid:setWall(ix, iy)
  else
    local tower = _G['Canon'](ix, iy)
    tower:start()
    table.insert(self.towers, tower)
    self.grid:setTower(ix, iy)
  end
end

function Room:clear()
  self.grid:clear()
  self:updateIA()
end

function Room:updateIA()
  self.ia:setGrid(self.grid:getPtr())
end

function Room:setSize(wx, wy)
	self.size = {x=wx, y=wy}
	self:updateDxDy()
end

function Room:setOffset(x, y)
	self.offset = {x=x,y=y}
end

function Room:updateDxDy()
	self.dx = self.size.x/self.ncells.x
	self.dy = self.size.y/self.ncells.y
end

function Room:xy2cell(x, y)
	local cx = math.max(math.min(math.floor((x - self.offset.x)/self.dx), self.ncells.x-1),0)
	local cy = math.max(math.min(math.floor((y - self.offset.y)/self.dy), self.ncells.y-1),0)
	return cx, cy
end

function Room:cell2xy(cx, cy)
  return cx*self.dx + self.offset.x, cy*self.dy+self.offset.y
end

function Room:getGrid()
  return self.grid
end

function Room:isFree(ix, iy)
  return (self.ia:howMany(ix, iy) == 0) and self.grid:isFree(ix, iy)
end

function Room:update(dt)
  if self.isPaused then
    return
  end
  
  Gtimer:update(dt)
  
  self.ia:setBody(self.EM.allEnemies)
  Physics.applyBodyForce(self.EM.allEnemies, self.ia, self.factors.body)
  Physics.applyWallForce(self.EM.allEnemies, self.grid, self.factors.wall)
  
  self.EM:update(dt, self.grid, self.ia)
  self.MM:update(dt)
  
  for _,s in pairs(self.spawners) do
    s:update(dt)
    repeat
      local e = s:createEnemy(G.smiley[Lume.randomchoice(self.allsmiley)])
      self.EM:add(e)

    until(e == nil)
  end
  
end

function Room:addtodraw(info)
  self.todraw = info
end

function Room:draw()
  love.graphics.push()
  love.graphics.translate(self.offset.x, self.offset.y)
  love.graphics.scale(self.dx, self.dy)
  love.graphics.setLineWidth(0.1)
  local gx, gy, v
  love.graphics.setColor(100,100,100)
  
  love.graphics.draw(assets.bg1, 0, 0, 0, self.ncells.x/assets.bg1:getWidth(), self.ncells.y/assets.bg1:getHeight())
  
	for ix=0,self.ncells.x do
		love.graphics.line(ix, 0, ix, self.ncells.y)
	end

	for ix=0,self.ncells.y do
		love.graphics.line(0, ix, self.ncells.x, ix)
	end

  local dxwall, dywall = assets.bgwalls:getWidth()/self.ncells.x, assets.bgwalls:getHeight()/self.ncells.y
	for ix = 0,self.ncells.x-1 do
		for iy = 0, self.ncells.y-1 do
      v = self.grid.data[ix][iy]
			if v == -1 then
        local quad = love.graphics.newQuad(ix*dxwall, iy*dywall, dxwall, dywall, 
                          assets.bgwalls:getWidth(), assets.bgwalls:getHeight())
        love.graphics.setColor(255,255,255)
        love.graphics.draw(assets.bgwalls, quad, ix, iy, 0, 1/dxwall, 1/dywall)
			elseif v == 2 then
				love.graphics.setColor(10,250,10)
				love.graphics.rectangle('fill', ix, iy, 1, 1)			
			end
		end
	end

  
  for _,s in pairs(self.spawners) do
    s:draw()
  end
  
  for _,t in pairs(self.towers) do
    t:draw()
  end
  
  self.EM:draw()
  self.MM:draw()
  
  self.ia:draw()
  
  if self.todraw then
	love.graphics.setColor(unpack(self.todraw.color))
	local img=self.todraw.img
	love.graphics.draw(img, self.todraw.x, self.todraw.y, 0, 1/img:getWidth(), 1/img:getHeight())
	self.todraw = nil
  end
  
  -- self.tower:draw()
  
  love.graphics.pop()
 
end