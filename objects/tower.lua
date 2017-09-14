Tower = Object:extend()



function Tower:new(x, y, params)
  self.isUpgrading = false
  self.isPaused = true
  self.lvl = 1
  
  self.x, self.y = x, y
  for k,v in pairs(params) do
    self[k] = v
  end

  self.shotAction = nil

end

function Tower:getTxtParams()
  local txt='Tower: '..self.type
  if self.type == 'Freezer' then
    txt = txt..string.format(', Freeze %d%%', self.speedReduction)
  elseif self.type == 'Laser' then
    txt = txt..string.format(', Dps %d', self.dps)
  else
    txt = txt..string.format(', Dps %d', self.dmg/self.reload)
  end
  
  if self.radiusEffect then
    txt = txt..", explosion: "..tostring(self.radiusEffect)
  end
  return txt

end


function Tower:lvlup()
  if not self.isPaused then
    self.isUpgrading = true
    self:stop()
    Gtimer:after(5, function()
        self:start()
        self.lvl = self.lvl+1
        self.upgrade(self)
        self.isUpgrading = false
        end)
  end
  
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
  if self.isUpgrading then
    love.graphics.setColor(120, 120, 120)
  else
    love.graphics.setColor(unpack(self.color))
  end
  love.graphics.draw(assets[self.imgname], self.x, self.y, 0, 1./64)
end

Canon = Tower:extend()


function Canon:new(x, y)
  Canon.super.new(self, x, y, Canon.params)
end

function Canon:shot()
  local cible = self.getCible(self.x, self.y)
  if cible then
    Signal.emit(
      "missile.add", 
      Ball({x=self.x, y=self.y}, cible, self.dmg)
    )
  end
end

Blaster = Tower:extend()

function Blaster:new(x, y)
  Blaster.super.new(self, x, y, Blaster.params)
end

function Blaster:shot()
  local cible = self.getCible(self.x, self.y)
  if cible then
    Signal.emit(
      "missile.add",
      Laser({x=self.x, y=self.y}, cible, self.dps, self.distance, self.reload)
    )
  end
end

Nuclear = Tower:extend()

function Nuclear:new(x, y)
  Nuclear.super.new(self, x, y, Nuclear.params)
end

function Nuclear:shot()
  local ciblexy = self.getCible(self.x, self.y)
  if ciblexy then
    Signal.emit(
      "missile.add",
      Bomb({x=self.x, y=self.y}, ciblexy, self.dmg, self.radiusEffect))
  end
end

Crusher = Tower:extend()
function Crusher:new(x, y)
  Crusher.super.new(self, x, y, Crusher.params)
end

function Crusher:shot()
  local ciblexy = self.getCible(self.x, self.y)
  if ciblexy then
    Signal.emit('missile.explosion', ciblexy, self.radiusEffect, self.dmg)
    Signal.emit('missile.add', ReaperExplosion(ciblexy, self.radiusEffect, 0.5))
  end
end

Freezer = Tower:extend()

function Freezer:new(x, y)
    Freezer.super.new(self, x, y, Freezer.params)
end

function Freezer:shot()
  local ciblexy = self.getCible(self.x, self.y)
  if ciblexy then
    Signal.emit('missile.add',
      FreezeBomb({x=self.x, y=self.y}, ciblexy, self.speedReduction, self.radiusEffect))
  end
end

