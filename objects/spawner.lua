Spawner = Object:extend()


function Spawner:new(x, y, rate)
  self.x, self.y = x+0.5, y+0.5
  self.rate = rate
  
  self.toCreate = 0.0
  self.isPaused = true
end

function Spawner:togglePause()
  self.isPaused = not self.isPaused
end

function Spawner:update(dt)
  if not self.isPaused then self.toCreate = self.toCreate + dt*self.rate end
end

function Spawner:createEnemy(einfo)
  if self.toCreate >= 1.0 then
    local x = self.x + 0.5*math.random()-0.25
    local y = self.y + 0.5*math.random() - 0.25
    
    local e = Enemy(einfo):setPos(x, y)
    self.toCreate = self.toCreate -1.0
    return e
  end

end

function Spawner:draw()
  love.graphics.setColor(0, 255, 255)
  love.graphics.circle('line', self.x, self.y, 0.5)
end

WaveSpawner = Object:extend()


local function genListToCreate(wavecfg)
  local res = {}
  
  for name, nlvl in pairs(wavecfg) do
    for ilvl,nperlvl in ipairs(nlvl) do
      while nperlvl > 0 do
        res[#res+1] = {name, ilvl }
        nperlvl = nperlvl-1
      end
    end
  end
  return res

end



function WaveSpawner:new(x, y, w, h, wavecfg)
  self.x, self.y = x, y
  self.w, self.h = w, h
  self.all = genListToCreate(wavecfg.smiley)
  self.rate = wavecfg.rate
  self.isPaused = true
  self.isNew = true
  
  self:reload()
  
end

function WaveSpawner:reload()
  print('reload')
  self.wave = Lume.shuffle(self.all)
  self.toCreate = 0.0
  self.isFinished = false  
  self.isNew = true
end


function WaveSpawner:togglePause()
  self.isPaused = not self.isPaused
end

function WaveSpawner:update(dt)
  if not self.isPaused and not self.isFinished then 
    self.isNew = false
    self.toCreate = self.toCreate + dt*self.rate 
  end
end

function WaveSpawner:createEnemy()
  if #self.wave == 0 and not self.isFinished then
    self.isFinished = true
    print('Ask for reload')
    Gtimer:after(10, function() 
        self:reload() 
      end)
  end
  
  if self.toCreate >= 1.0 and not self.isFinished then
    local x = self.x + self.w*math.random()
    local y = self.y + self.h*math.random()
    local tmp = self.wave[#self.wave]
    self.wave[#self.wave] = nil
    print('Create', tmp[1], tmp[2])
    local e = Enemy(tmp[1], tmp[2]):setPos(x, y)
    self.toCreate = self.toCreate -1.0
    return e
  end

end

function WaveSpawner:draw()
  love.graphics.setColor(0, 255, 255)
  love.graphics.rectangle('line', self.x, self.y, self.w, self.h)
end