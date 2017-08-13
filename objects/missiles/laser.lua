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
  love.graphics.setColor(255, 165, 0)
  love.graphics.setLineWidth(1)
  love.graphics.line(self.x, self.y, self.cible.x, self.cible.y)
end
