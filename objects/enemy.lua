Enemy = Object:extend()

function Enemy:new(params)
  for k,v in pairs(params) do
    self[k]= v
  end

  
  self.life = 200
  self.x = 0
  self.y = 0
  self.vx = 0
  self.vy = 0
  self.vref = math.random()*0.5+0.5
  
  self.oldPos={x=0, y=0}
  
  self.isMarked=false
  self.isDead = false
  
  self:resetForce()
  self:static()
end

function Enemy:hit(dmg)
  local dpv = self.life - dmg
  if dpv <= 0 then
    dpv = self.life
    self.life = 0
    self:dead()
  else
    self.life = dpv
  end
  Signal.emit("smiley.hit", dpv)
end

function Enemy:dead()
  self.isDead = true
  Signal.emit("smiley.dead", self)
end

function Enemy:resetForce()
  self.force = {x=0, y=0}
end

function Enemy:applyForce(F)
  self.force.x = self.force.x+F.x
  self.force.y = self.force.y+F.y
end

function Enemy:static()
  self.vx, self.vy = 0, 0
end

function Enemy:bug()
  self.isMarked=true
end

function Enemy:setCible(x, y)
  local d2 = vector.len2(self.x - x, self.y - y)
  if d2 < 1e-10 then
    self:static()
  else
    local r = -self.vref/math.sqrt(d2)
    self.vx, self.vy = r*(self.x - x), r*(self.y - y)
  end
end

function Enemy:setPos(x, y)
  self.x, self.y = x, y
end

function Enemy:getPos()
  return self.x, self.y
end

function Enemy:invalidMove()
  self.x = self.oldPos.x
  self.y = self.oldPos.y
end

function Enemy:update(dt)
  self.oldPos = {x=self.x, y=self.y}
  self.x = self.x + dt * (self.vx + self.force.x*dt)
  self.y = self.y + dt * (self.vy + self.force.y*dt)
end

function Enemy:draw()
  if self.isMarked then
    love.graphics.setColor(10, 195, 10)
  else
    love.graphics.setColor(195, 195, 10)
  end
  love.graphics.circle("fill", self.x, self.y, 0.2, 10)
  
end