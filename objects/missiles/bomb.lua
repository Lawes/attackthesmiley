Bomb = Object:extend()
Bomb.v = 3.0

function Bomb:new(from, toxy, dmg, explosionRadius)
  self.x = from.x+0.5
  self.y = from.y+0.5
  self.cible = toxy
  self.dmg = dmg
  self.explosionRadius = explosionRadius
  self.isDead = false
end

function Bomb:dead()
  self.isDead = true
end

function Bomb:update(dt)
  local dx, dy = self.cible.x - self.x, self.cible.y - self.y
  local d2 = vector.len2(dx, dy)  
  if d2 < 0.1 then
    self:dead()
    Signal.emit('missile.explosion', self.cible, self.explosionRadius, self.dmg)
    Signal.emit('missile.add', Explosion(self.cible, self.explosionRadius))
  else
    local dirx, diry = vector.normalize(dx, dy)
    self.x = self.x + Bomb.v*dirx*dt
    self.y = self.y + Bomb.v*diry*dt    
  end
end

function Bomb:draw()
  love.graphics.setColor(0, 175, 255)
  love.graphics.circle('fill', self.x, self.y, 0.6)
end


  