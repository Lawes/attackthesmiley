Explosion = Object:extend()

function Explosion:new(pos, radius, lifetime)
  self.x = pos.x+0.5
  self.y = pos.y+0.5
  self.radius = radius
  self.isDead = false
  self.time=lifetime or 2.0
end

function Explosion:dead()
  self.isDead = true
end

function Explosion:update(dt)
  self.time = self.time - dt
  if self.time < 0 then
    self:dead()
  end
end


function Explosion:draw()
  love.graphics.setLineWidth(0.1)
  love.graphics.setColor(200,30,30)
  love.graphics.circle('line', self.x, self.y, self.radius)
end
  
  