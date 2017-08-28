
local M = {}

M.Canon = {}
M.Canon.dmg = 100
M.Canon.reload = .1
M.Canon.distance = 3.0
M.Canon.nbfocus = 5
M.Canon.color = {200,10,10}
M.Canon.imgname = "towers_c"
M.Canon.getCible_ = function(ia, x, y) return ia:randomBodyAtDistance(x, y, M.Canon.distance) end

M.Blaster = {}
M.Blaster.dps = 100.0
M.Blaster.distance = 4.0
M.Blaster.reload = 3.0
M.Blaster.imgname = "towers_l"
M.Blaster.color = {10,200,80}
M.Blaster.getCible_ = function(ia, x, y) return ia:randomBodyAtDistance(x, y, M.Blaster.distance) end

M.Nuclear = {}
M.Nuclear.dmg = 200.0
M.Nuclear.distance = 6.0
M.Nuclear.radiusEffect = 2.0
M.Nuclear.reload = 3.0
M.Nuclear.imgname = "towers_n"
M.Nuclear.color = {10,10,200}
M.Nuclear.getCibleXY_ = function(ia, x, y) return ia:getMaxDensity(x, y, M.Nuclear.distance) end

M.Freezer = {}
M.Freezer.distance = 6.0
M.Freezer.radiusEffect = 1.0
M.Freezer.reload = 3.0
M.Freezer.speedReduction = 80
M.Freezer.imgname = "towers_f"
M.Freezer.color = {200,10,200}
M.Freezer.getCibleXY_ = function(ia, x, y) return ia:getMaxDensity(x, y, M.Freezer.distance) end

M.Booster = {}
M.Booster.power = 1.1
M.Booster.imgname = "towers_b"
M.Booster.color = {200,200,10}

M.Crusher = {}
M.Crusher.dmg = 50.0
M.Crusher.radiusEffect = 2.0
M.Crusher.reload = 0.5
M.Crusher.imgname = "towers_r"
M.Crusher.color = {10,200,200}
M.Crusher.getCibleXY_ = function(ia, x, y) return ia:randomBodyAtDistance(x, y, M.Crusher.radiusEffect) and {x=x, y=y} or nil end

M.Wall = {}
M.Wall.imgname = "wall2"

return M