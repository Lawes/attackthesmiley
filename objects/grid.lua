Grid = Object:extend()



function Grid:new(nxcells, nycells)
  self.ncells = {x=nxcells, y=nycells}
  self.data = {}
	for ix = 0, nxcells-1 do
		self.data[ix] = {}
		for iy = 0, nycells-1 do
			self.data[ix][iy] = 0
		end
	end  
  
end

function Grid:clear()
	for ix = 0,self.ncells.x-1 do
		for iy = 0, self.ncells.y-1 do
			self.data[ix][iy] = 0
		end
	end
end
local floor = math.floor

function Grid:isWall(ix, iy)
  return self.data[ix][iy] < 0
end

function Grid:getWallNearBy(x, y)
  local res = {}
  local ix, iy = floor(x), floor(y)
  for dx=-1,1 do
    local gx = self.data[ix+dx]
    if gx then
      for dy=-1,1 do
        if gx[iy+dy] then
          if gx[iy+dy] < 0 then res[#res+1]= {dx, dy} end
        end
      end
    end
  end
  return res
end

function Grid:isFree(ix, iy)
  return self.data[ix][iy] == 0
end

function Grid:toggle_set(x, y, val)
  local ix, iy, v=floor(x), floor(y), val
  if self.data[ix][iy] ~=0 then
    v = 0
  end
  self.data[ix][iy] = v
end

function Grid:setTower(ix, iy)
  self.data[ix][iy] = -2
end
  

function Grid:setWall(ix, iy)
  self:toggle_set(ix, iy, -1)
end

function Grid:setExit(ix, iy)
  self:toggle_set(ix, iy, 2)
end

function Grid:getPtr()
  return self.data
end

function Grid:get(ix, iy)
  return self.data[ix][iy]
end

function Grid:safeget(ix, iy)
  if ix<0 or ix >= self.ncells.x or iy<0 or iy>=self.ncells.y then
    return nil
  end
  
  return self:get(ix, iy)
end