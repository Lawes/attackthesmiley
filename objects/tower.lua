Tower = Object:extend()



function Tower:new(x, y, params)
  self.isPaused = true
  
  self.x, self.y = x, y
  for k,v in pairs(params) do
    self[k] = v
  end
  
  self.shotAction = nil

end

function Tower:start()
  self:stop()
  self.isPaused = false
  self.shotAction = Gtimer:every(self.reload, function() self:shot() end)
  
end

function Tower:stop()
  if self.shotAction then
    Gtimer:cancel(self.shotAction)
  end
end
  


function Tower:draw()
  love.graphics.setColor(unpack(self.color))
  love.graphics.draw(assets[self.imgname], self.x, self.y, 0, 1./64)
end

Canon = Tower:extend()


function Canon:new(x, y)
  Canon.super.new(self, x, y, Canon.params)
end

function Canon:shot()
  local cible = self.getCible(
    self.x,
    self.y,
    self.distance)
  if cible then
    Signal.emit(
      "missile.add", 
      Ball({x=self.x, y=self.y}, cible, self.dmg)
    )
  end
end
