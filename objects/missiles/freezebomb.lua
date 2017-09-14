FreezeBomb = Object:extend()
FreezeBomb.v = 3.0

function FreezeBomb:new(from, toxy, ratio, explosionRadius)
  self.x = from.x+0.5
  self.y = from.y+0.5
  self.cible = toxy
  self.ratio = ratio
  self.explosionRadius = explosionRadius
  self.isDead = false
end

function FreezeBomb:dead()
  self.isDead = true
end

function FreezeBomb:update(dt)
  local dx, dy = self.cible.x - self.x, self.cible.y - self.y
  local d2 = vector.len2(dx, dy)  
  if d2 < 0.1 then
    self:dead()
    Signal.emit('missile.blizzard', self.cible, self.explosionRadius, self.ratio)
    Signal.emit('missile.add', Explosion(self.cible, self.explosionRadius))
  else
    local dirx, diry = vector.normalize(dx, dy)
    self.x = self.x + FreezeBomb.v*dirx*dt
    self.y = self.y + FreezeBomb.v*diry*dt    
  end
end

local atan2, pi = math.atan2, math.pi
function FreezeBomb:draw()
  love.graphics.setColor(255, 255, 255)
  -- love.graphics.circle('fill', self.x, self.y, 0.8)
  love.graphics.draw(assets.freezebomb, self.x, self.y, 
                     atan2(self.cible.y - self.y, self.cible.x - self.x)+pi/2,
                     1/64, 1/64,
                     32, 32)
end
