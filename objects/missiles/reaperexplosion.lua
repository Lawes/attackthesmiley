ReaperExplosion = Explosion:extend()

function ReaperExplosion:new(pos, radius, lifetime)
    ReaperExplosion.super.new(self, pos, radius, lifetime)
    self.spin = 0
    Gtimer:tween(.5, self, {spin=2*math.pi}, 'in-linear')
    self.radius = radius/2
    Gtimer:tween(0.3, self, {radius=radius}, 'out-expo', 
      function()
        Gtimer:tween(0.2, self, {radius=radius/2}, 'in-expo')
      end
      )
end


function ReaperExplosion:draw()
  love.graphics.setLineWidth(0.1)
  love.graphics.setColor(255,255,255, 128)
  -- love.graphics.circle('line', self.x, self.y, self.radius)
  love.graphics.draw(
    assets.ring, self.x, self.y,
    self.spin,
    2*self.radius/128, 2*self.radius/128,
    64, 64)    

end
  