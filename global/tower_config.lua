
local M = {}

M.Canon = {}
M.Canon.dmg = 200
M.Canon.reload = .1
M.Canon.distance = 3.0
M.Canon.nbfocus = 5
M.Canon.color = {200,10,10}
M.Canon.imgname = "towers_c"
M.Canon.getCible_ = function(ia, x, y) return ia:randomBody() end

M.Laser = {}
M.Laser.dps = 50.0
M.Laser.distance = 4.0
M.Laser.reload = 1.0
M.Laser.imgname = "towers_l"
M.Laser.color = {10,200,10}

M.Nuclear = {}
M.Nuclear.dmg = 10.0
M.Nuclear.distance = 10.0
M.Nuclear.radiusEffect = 2.0
M.Nuclear.reload = 3.0
M.Nuclear.imgname = "towers_n"
M.Nuclear.color = {10,10,200}

M.Freezer = {}
M.Freezer.distance = 2.0
M.Freezer.radiusEffect = 1.0
M.Freezer.reload = 2.0
M.Freezer.speedReduction = 0.8
M.Freezer.imgname = "towers_f"
M.Freezer.color = {200,10,200}

M.Booster = {}
M.Booster.power = 1.1
M.Booster.imgname = "towers_b"
M.Booster.color = {200,200,10}

M.Crusher = {}
M.Crusher.dmg = 5.0
M.Crusher.radiusEffect = 1.0
M.Crusher.reload = 0.5
M.Crusher.imgname = "towers_r"
M.Crusher.color = {10,200,200}

M.Wall = {}
M.Wall.imgname = "wall2"

return M