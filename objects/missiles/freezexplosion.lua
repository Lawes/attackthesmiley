FreezeExplosion = Explosion:extend()

function FreezeExplosion:new(pos, radius, lifetime)
    FreezeExplosion.super.new(self, pos, radius, lifetime)
    self.spin = 0
    -- Gtimer:tween(2, self, {spin=math.pi}, 'in-linear')
    self.radius = radius/2
    psmfreeze:setPosition(self.x, self.y)
    psmfreeze:emit(10)
    Gtimer:tween(0.5, self, {radius=radius}, 'out-expo')
end
