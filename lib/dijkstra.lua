require 'math'

local M = {}

local function getArray(size, val)
	local res = {}
	for i =1,size do
		res[i] = val
	end
	return res
	
end


local function extractMinIndex(array, distances)
  local indice,_ = next(array)
  local minval = distances[indice]
  local v
  for i,_ in pairs(array) do
    v = distances[i]
    if v < minval then
      indice, minval = i, v
    end
  end
  
  return indice
  
end

local sqrt2 = math.sqrt(2)
local function possibleNeighbour(grid, ix, iy)
  local res = {{0,1,1},{0,-1,1}}
  if grid[ix-1] then
    res[#res+1]= {-1,0,1}
    if grid[ix-1][iy]~=nil and grid[ix][iy-1]~=nil then res[#res+1]= {-1,-1,sqrt2} end
    if grid[ix-1][iy]~=nil and grid[ix][iy+1]~=nil then res[#res+1]= {-1,1,sqrt2} end
  end
  if grid[ix+1] then
    res[#res+1]= {1,0,1}
    if grid[ix+1][iy]~=nil and grid[ix][iy-1]~=nil then res[#res+1]= {1,-1,sqrt2} end
    if grid[ix+1][iy]~=nil and grid[ix][iy+1]~=nil then res[#res+1]= {1,1,sqrt2} end
  end    
  return res
end

function M.Dijkstra(inTable, ncellsx, ncellsy)

	local totalCells = ncellsx*ncellsy
	
	local convXYtoN = {}
	local convNtoXY = {}
	
	local distances = getArray(totalCells, math.huge)
  local directions = getArray(totalCells, -1)
	local unvisitedNodes = getArray(totalCells, true)
  local open = {}
	
	local icount=1
	for ix=0, ncellsx-1 do
    convXYtoN[ix] = {}
		for iy=0, ncellsy-1 do
			cellType = inTable[ix][iy]
			
      if cellType < 0 then goto continue end
        
			convXYtoN[ix][iy] = icount
			convNtoXY[icount] = {ix,iy}

			if cellType == 2 then
        -- print(ix, iy, icount)
        distances[icount] = 0
        directions[icount] = icount
        open[icount] = true
			end
      ::continue::
      
			icount = icount+1
		end
	end

  if  next(open) == nil then
    return
  end

	local indice, ix, iy, tmpx, tmpy, tmpn, d
  while next(open) ~= nil do
    indice = extractMinIndex(open, distances)
    -- print("indice", indice, 'distance', distances[indice])

    ix = convNtoXY[indice][1]
    iy = convNtoXY[indice][2]
    local nb = possibleNeighbour(convXYtoN, ix, iy)
    for _,v in ipairs(nb) do
      tmpx = ix+v[1]
      tmpy = iy+v[2]

      tmpn = convXYtoN[tmpx][tmpy]
      if tmpn then

          d = distances[indice]+v[3]
          -- d = distances[indice]+1
          -- print('test node', tmpn, 'distance',d, 'ref',distances[tmpn])
          if d < distances[tmpn] then
            -- print('update', tmpn)
            distances[tmpn] = d
            directions[tmpn] = indice
          end
          
          if open[tmpn] == nil and unvisitedNodes[tmpn] then
            open[tmpn] = true
            -- print('goto open', tmpn)
          end
        end

    end
    open[indice] = nil
    unvisitedNodes[indice] = false

  end

  local resCost, resDir = {}, {}
  for ix=0, ncellsx-1 do
    resCost[ix] = {}
    resDir[ix]= {}
    
		for iy=0, ncellsy-1 do
      local n = convXYtoN[ix][iy]
      resCost[ix][iy]= distances[n]
      resDir[ix][iy]= convNtoXY[directions[n]]
      
    end
  end
  
  return resCost, resDir
end

return M
