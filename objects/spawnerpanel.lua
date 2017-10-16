SpawnerPanel = Object:extend()

function SpawnerPanel:new(x, y, w, h)
  self.panel = {x=x, y=y, w=w, h=h}
  self.wave = {}
end

function SpawnerPanel:loadwave(l, rate)
  self.time=1

  self.wave = {}
  for i=#l,1,-1 do
    self.wave[#self.wave+1] = l[i]
  end
  self.r = rate
  
end


function SpawnerPanel:update(dt)
  self.time = self.time+dt
end


function SpawnerPanel:draw()
  love.graphics.setColor(255,0,0)
  love.graphics.rectangle('line', self.panel.x, self.panel.y, self.panel.w, self.panel.h)
  local r = self.panel.w/#self.wave
  for iw, w in ipairs(self.wave) do
    love.graphics.setColor(255,255,255)
    local dx = self.time * self.r/#self.wave * self.panel.w
    local x = dx - iw*self.panel.w/#self.wave
    if x > 0 and x < self.panel.w then
      love.graphics.draw(assets[w[1]], self.panel.x + x, self.panel.y + self.panel.h*(w[2]/3), 0, w[2]/5)
    end

  end

end
