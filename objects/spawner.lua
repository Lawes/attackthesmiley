Spawner = Object:extend()


function Spawner:new(x, y, rate)
  self.x, self.y = x+0.5, y+0.5
  self.rate = rate
  
  self.toCreate = 0.0
  
  self.isPaused = true
end

function Spawner:togglePause()
  self.isPaused = not self.isPaused
end

function Spawner:update(dt)
  if not self.isPaused then self.toCreate = self.toCreate + dt*self.rate end
end

function Spawner:createEnemy()
  if self.toCreate >= 1.0 then
    local x = self.x + 0.5*math.random()-0.25
    local y = self.y + 0.5*math.random() - 0.25
    local e = Enemy(G.smiley.love)
    e:setPos(x, y)
    self.toCreate = self.toCreate -1.0
    return e
  end

end

function Spawner:draw()
  love.graphics.setColor(0, 255, 255)
  love.graphics.circle('line', self.x, self.y, 0.5)
end