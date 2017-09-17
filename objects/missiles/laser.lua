Laser = Object:extend()

function Laser:new(from, to, dps, radius, duration)
  self.radius2 = radius*radius
  self.x = from.x+0.5
  self.y = from.y+0.5
  self.cible = to
  self.dps = dps
  self.life = duration
  self.isDead = false 
end


function Laser:dead()
  self.isDead = true
end


function Laser:update(dt)
  self.life = self.life-dt
  if self.life < 0 then
    self:dead()
--  elseif vector.len2(self.x, self.y, self.cible.x, self.cible.y) > self.radius2 then
--    self:dead()
  elseif not self.cible.isDead then
    local dmg = self.dps*dt
    self.cible:hit(dmg)
  else
    self:dead()
  end     
end


function Laser:draw()
  love.graphics.setColor(255, 255, 255)
  local a, d = vector.toPolar(-self.x+ self.cible.x, -self.y+self.cible.y)
  love.graphics.draw(assets.rayon, self.x, self.y, a, d/32, 1/16, 0, 16)
  love.graphics.draw(assets.point, self.cible.x, self.cible.y, 0, 1/90, 1/90, 32, 32)  
end
