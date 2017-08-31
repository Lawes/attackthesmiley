Enemy = Object:extend()

function Enemy:new(name, lvl)
  
  local params = G.smiley[name]
  
  local plvl = lvl or 1
  self.lvl = plvl
 
  for k,v in pairs(params) do
    self[k]= v
  end
  if params.lvlup then
    while plvl > 1 do
      params.lvlup(self)
      plvl = plvl -1
    end
  end

  self.x = 0
  self.y = 0
  self.vx = 0
  self.vy = 0
  self.vref = self.speed*(1.0+math.random()*0.1)
  
  self.oldPos={x=0, y=0}
  
  self.isMarked=false
  self.isDead = false
  
  self.freezeratio = 0
  
  self:resetForce()
  self:static()
end

function Enemy:hit(dmg)
  local dpv = self.life - dmg
  if dpv <= 0 then
    dmg = self.life
    self.life = 0
    self:dead()
    if self.lvl > 1 then
      Signal.emit("smiley.add", 
                  Enemy(self.type, self.lvl-1):setPos(self.x, self.y))
      Signal.emit("smiley.add", 
                  Enemy(self.type, self.lvl-1):setPos(self.x, self.y))
    end
  else
    self.life = dpv
  end
  Signal.emit("smiley.hit", dmg)
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
  return self
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
  local slow = (100.0-self.freezeratio)/100.0
  self.x = self.x + dt * (slow * self.vx + self.force.x*dt)
  self.y = self.y + dt * (slow * self.vy + self.force.y*dt)
end

function Enemy:freeze(s)
  if self.freezeratio < s then
    self.freezeratio = s
    Gtimer:after(2, function() if self then self.freezeratio = 0 end end)
  end
end


function Enemy:draw()
  local r = 0.15*(1+self.lvl)
  local lvlcolor
  local rb = r*1.2
  
  if self.isMarked then
    love.graphics.setColor(100, 100, 100)
  else
    love.graphics.setColor(255, 255, 255)
  end
  love.graphics.draw(assets[self.type], self.x-r, self.y-r, 0, 2*r/64)

  if self.freezeratio > 0 then
    lvlcolor=255-40*self.lvl
    love.graphics.setColor(10, lvlcolor, lvlcolor)
  else
    lvlcolor=255-70*self.lvl
    love.graphics.setColor(lvlcolor, lvlcolor, lvlcolor)
  end
  love.graphics.draw(assets.smiley_border, self.x-rb, self.y-rb, 0, 2*rb/32) 


end