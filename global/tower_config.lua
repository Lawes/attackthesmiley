
local M = {}

M.Canon = {}
M.Canon.dmg = 200
M.Canon.reload = .1
M.Canon.distance = 3.0
M.Canon.nbfocus = 5
M.Canon.getCible_ = function(ia, x, y) return ia:randomBody() end

M.laser = {}
M.laser.dps = 50.0
M.laser.distance = 4.0
M.laser.reload = 1.0

M.nuclear = {}
M.nuclear.dmg = 10.0
M.nuclear.distance = 10.0
M.nuclear.radiusEffect = 2.0
M.nuclear.reload = 3.0

M.freezer = {}
M.freezer.distance = 2.0
M.freezer.radiusEffect = 1.0
M.freezer.reload = 2.0
M.freezer.speedReduction = 0.8

M.booster = {}
M.booster.power = 1.1

M.crusher = {}
M.crusher.dmg = 5.0
M.crusher.radiusEffect = 1.0
M.crusher.reload = 0.5


return M