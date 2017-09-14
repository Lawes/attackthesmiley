NukExplosion = Explosion:extend()

function NukExplosion:new(pos, radius, lifetime)
    NukExplosion.super.new(self, pos, radius, lifetime)
    self.spin = 0
    -- Gtimer:tween(2, self, {spin=math.pi}, 'in-linear')
    self.radius = radius/2
    Gtimer:tween(0.5, self, {radius=radius}, 'out-expo')
end


function NukExplosion:draw()
  love.graphics.setLineWidth(0.1)
  love.graphics.setColor(255,255,255, 128)
  love.graphics.circle('line', self.x, self.y, self.radius)
  love.graphics.draw(
    assets.fire, self.x, self.y,
    self.spin,
    2*self.radius/128, 2*self.radius/128,
    64, 64)    
  love.graphics.setColor(255,255,255, 255)
end
  