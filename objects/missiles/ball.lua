Ball = Object:extend()
Ball.v = 4.0

function Ball:new(from, to, dmg)
  self.x = from.x+0.5
  self.y = from.y+0.5
  self.cible = to
  self.dmg = dmg
  self.isDead = false
end

function Ball:dead()
  self.isDead = true
end

function Ball:update(dt)
  if not self.cible.isDead then
    local dx, dy = self.cible.x - self.x, self.cible.y - self.y
    local d2 = vector.len2(dx, dy)
    if d2 < 0.1 then
      self:dead()
      self.cible:hit(self.dmg)
    else
      local dirx, diry = vector.normalize(dx, dy)
      self.x = self.x + Ball.v*dirx*dt
      self.y = self.y + Ball.v*diry*dt
    end
  else
    self:dead()
  end

end

function Ball:draw()
  love.graphics.setColor(0,0,255)
  love.graphics.circle('fill', self.x, self.y, 0.2)
end