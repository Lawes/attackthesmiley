vector = require "lib/hump.vector-light"

local M = {}

local floor = math.floor
local function singleWallForce(x, y, dx, dy, factor)
  local r
  local F={x=0, y=0}

  if dx == -1 then
    F.x = 1.0 - (x - floor(x))
  elseif dx == 1 then
    F.x = floor(x) - x
  end
  
  if dy == -1 then
    F.y = 1.0 - (y - floor(y))
  elseif dy == 1 then
    F.y = floor(y) - y
  end  
  
  return {x=F.x*factor, y=F.y*factor}
end

function M.applyWallForce(allbody, grid, factor)
  if not next(allbody) then
    goto endFunc
  end  
 
  for ib, b in ipairs(allbody) do
    local resF = {x=0, y=0}
    for _, dir in ipairs(grid:getWallNearBy(b.x, b.y)) do
      local F = singleWallForce(b.x, b.y, dir[1], dir[2], factor)
      resF.x = resF.x + F.x
      resF.y = resF.y + F.y
    end
    
    b:applyForce(resF)
  end

  ::endFunc:: 
end




local function singleBodyForce(ibody, interaction, dref, factor)
  local fx, fy = 0,0
  local rref = 1.0/dref
  for _, info in pairs(interaction) do
    if info.dist < dref then
      local const=(1.0-info.dist*rref)
      fx = fx + const*info.u.x
      fy = fy + const*info.u.y
    end
  end
  
  return {x=fx*factor, y=fy*factor}
end


local function distAndVect(b1, b2)
  local dx, dy = b1.x-b2.x, b1.y-b2.y
  local d = vector.len(dx, dy)
  local res = {dist=d, u={x=0, y=0}}
  if d > 1e-6 then
    local r = 1.0/d
    res.u.x = r*dx
    res.u.y = r*dy
  end
  
  return res

end



function M.applyBodyForce(allbody, spatial, factor)
  if not next(allbody) then
    goto endFunc
  end

  local distCache = {}
  for ib in pairs(allbody) do   
    distCache[ib] = {}
  end
  
  for ib, b in ipairs(allbody) do
    local ix, iy = floor(b.x), floor(b.y)
    local distib = distCache[ib]
    -- print("-----",ib)
    for _, inearb in ipairs( spatial:getBodyNearBy(ix, iy, 2) ) do
      if ib ~= inearb and not distib[inearb] then
      -- if ib ~= inearb  then
        local d = distAndVect( b, allbody[inearb])
        distib[inearb] = d
        distCache[inearb][ib] = {dist=d.dist, u={x=-d.u.x, y=-d.u.y}}
      end
    end
  end
  
  for ib, b in ipairs(allbody) do
    local F = singleBodyForce(ib, distCache[ib], 2.0, factor)
    b:applyForce(F)
  end
  
  ::endFunc::
end

return M