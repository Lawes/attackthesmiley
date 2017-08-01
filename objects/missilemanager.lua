MissileManager = Object:extend()

function MissileManager:new()
  self.list = {}
  Signal.register(
    "missile.add", 
    function(m)
      self:add(m)
    end)
end

function MissileManager:add(m)
  if m then
    table.insert(self.list, m)
  end
end

function MissileManager:update(dt)
  for i=#self.list,1,-1 do
    local m = self.list[i]
    m:update(dt)
    
    if m.isDead then
      table.remove(self.list, i)
    end
  end
end

function MissileManager:draw()
  for _,e in ipairs(self.list) do
    e:draw()
  end  
  
end
