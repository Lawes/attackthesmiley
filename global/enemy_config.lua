
local M = {}

M.sun = {}
M.sun.type = "sun"
M.sun.life = 100.0
M.sun.speed = 1.0
M.sun.reward = 5
M.sun.color = {255,255,0}
M.sun.lvlup = function(e)
  e.life = e.life*1.2
end

M.annoyed = {}
M.annoyed.type = "annoyed"
M.annoyed.life = 125.0
M.annoyed.speed = 1.0
M.annoyed.reward = 7
M.annoyed.color = {0,0,255}
M.annoyed.lvlup = function(e)
  e.life = e.life*1.2
  e.speed = e.speed+0.3
end

M.halloween = {}
M.halloween.type = "halloween"
M.halloween.life = 125.0
M.halloween.speed = 1.0
M.halloween.reward = 11
M.halloween.color = {150,150,150}
M.halloween.lvlup = function(e)
  e.life = e.life*1.4
end

M.horror = {}
M.horror.type = "horror"
M.horror.life = 125.0
M.horror.speed = 1.0
M.horror.reward = 9
M.horror.color = {255,0,0}
M.horror.lvlup = function(e)
  e.life = e.life*1.5
  e.speed = e.speed+0.2
end

M.cry = {}
M.cry.type = "cry"
M.cry.life = 125.0
M.cry.speed = 1.0
M.cry.reward = 13
M.cry.color = {255,0,255}
M.cry.lvlup = function(e)
  e.life = e.life*2
  e.speed = e.speed+0.5
end

return M