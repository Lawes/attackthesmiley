local M = {}

M.level1 = {}
M.level1.ncells = {x=23, y=20}
M.level1.walls = {}
for ix=0,M.level1.ncells.x-1 do
  table.insert(M.level1.walls, {ix, 0})
  table.insert(M.level1.walls, {ix, M.level1.ncells.y-1})
end
for iy=0,M.level1.ncells.y-1 do
  table.insert(M.level1.walls, {0, iy})
  table.insert(M.level1.walls, {M.level1.ncells.x-1, iy})
end

M.level1.exits = { {21, 5}, {21,15}}
M.level1.spawners = {} -- {{1,10}}

return M
  