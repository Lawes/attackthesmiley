BodyIA = Object:extend()

U = require 'lib/dijkstra'

local floor = math.floor

function BodyIA:new()
 
end

function BodyIA:init(ncellsx, ncellsy)
  self.ncells = {x=ncellsx, y=ncellsy}
  self:clearBodyCache()
  
  self.gridCost = nil
  self.gridPath = nil
  
  self.bug = {}  
end

function BodyIA:clearBodyCache()
  if not self.body then 
    self.body = {}
    for ix=0,self.ncells.x-1 do
      self.body[ix] = {}
      for iy=0,self.ncells.y-1 do
        self.body[ix][iy] = {}
      end
    end
  end
  
  self.nbody = 0
  
  for ix=0,self.ncells.x-1 do
    for iy=0,self.ncells.y-1 do
      self.body[ix][iy] = {}
    end
  end
end

function BodyIA:howMany(ix, iy)

  return #self.body[ix][iy] or 0

  
end

function BodyIA:randomBody()
  return math.random(self.nbody)
end

function BodyIA:randomBodyAtDistance(x, y, d)
  return Lume.randomchoice(self:getBodyNearBy(x, y, math.ceil(d)))
end

function BodyIA:getMaxDensity(x, y, d)
  local ix, iy = floor(x), floor(y)
  local maxNbr, maxPos = 0, nil
  for dx=-d,d do
    local gx = self.body[ix+dx]
    if gx then
      for dy=-d,d do
        if gx[iy+dy] then
          local nbodyInCell = #gx[iy+dy]

          if nbodyInCell > maxNbr then
            maxNbr = nbodyInCell
            maxPos = {x=ix+dx, y=iy+dy}
          end
        end
        
        
      end
    end
  end
  return maxPos
end



function BodyIA:setBody(allbody)
  self:clearBodyCache()
  self.nbody = #allbody
  
  for ib, b in ipairs(allbody) do
    local ix, iy = floor(b.x), floor(b.y)
    local array = self.body[ix][iy]
    array[#array+1]= ib

    -- table.insert(self.body[ix][iy], ib)
  end  
end

function BodyIA:getBodyNearBy(x, y, d)
  local ix, iy = floor(x), floor(y)
  local res = {}
  for dx=-d,d do
    local gx = self.body[ix+dx]
    if gx then
      for dy=-d,d do
        local lbody = gx[iy+dy]
        if lbody then
          for _, v in ipairs(lbody) do
            res[#res+1] = v
          end
        end
      end
    end
  end
  return res  
end

function BodyIA:setGrid(grid)
  self.gridCost, self.gridPath = U.Dijkstra(grid, self.ncells.x, self.ncells.y)
end

function BodyIA:findOutput(ix, iy)
  if  self.gridPath == nil then
    return ix, iy
  end
  
  local cell = self.gridPath[ix][iy]
  if cell then
    return cell[1], cell[2]
  end
end

function BodyIA:isOutside(ix, iy)
  local res = false
  if self.gridCost ~= nil then
    if not self.gridCost[ix] then
      table.insert(self.bug, {ix, iy})
      res = true
    else
      res = self.gridCost[ix][iy] == 0
    end
  end
  return res
end

function BodyIA:draw()
  love.graphics.setColor(200, 100, 50)
  for _,v in ipairs(self.bug) do
    love.graphics.rectangle('fill', v[1], v[2], 1, 1)
  end
    
  
end