
GameStats = Object:extend()


function GameStats:new()
  
  self.totalpv = 0
  self.playercash = 0
  self.huntingTable = {}
  self.smileyInGame = {}
  
  for t, info in pairs(G.smiley) do
    self.smileyInGame[t] = 0
    self.huntingTable[t] = 0
  end
  self.bufferDmg = 0
  self.effectiveDps = 0
  Gtimer:every(3, function() 
      self.effectiveDps = self.bufferDmg/3.
      self.bufferDmg = 0.0
      end)
  
end

function GameStats:newSmileyInGame(e)
  self.totalpv = self.totalpv + e.life
  self.smileyInGame[e.type] = self.smileyInGame[e.type] + 1
end

function GameStats:deadSmiley(e)
  -- self.totalpv = self.totalpv - G.conf_smiley[e.type].life
  -- self.smileyInGame[e.type] = self.smileyInGame[e.type] - 1
  self.huntingTable[e.type] = self.huntingTable[e.type] + 1
  self.playercash = self.playercash + G.smiley[e.type].reward
end

function GameStats:lessPV(dmg)
  self.totalpv = self.totalpv - dmg
  self.bufferDmg = self.bufferDmg + dmg
end

function GameStats:registerSignals()
  Signal.register( 'smiley.add', function (e) 
      self:newSmileyInGame(e)
  end)
  Signal.register( 'smiley.dead', function (e)
      self:deadSmiley(e) 
  end)
  Signal.register( 'smiley.hit', function (dmg)
      self:lessPV(dmg) 
  end)
  -- 'smiley.hit'
  
  
end


function GameStats:draw()  
  love.graphics.setColor(200,200,200)
  love.graphics.print("Cash: "..tostring(self.playercash), 10, 50)
  love.graphics.print("Pvin Game: "..tostring(math.floor(self.totalpv)), 10, 65)
  love.graphics.print('Effective DPS: '..tostring(math.floor(self.effectiveDps)), 10, 80)
  local i=1
  for name, c in pairs(self.smileyInGame) do
    love.graphics.print(name..' : '..tostring(c), 200, 10+i*15)
    i = i+1
  end
  
  
  
end