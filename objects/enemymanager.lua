EnemyManager = Object:extend()



function EnemyManager:new()
  self.allEnemies = {}

  Signal.register('smiley.add', function(e) self:add(e) end)

end

function EnemyManager:add(enemy)
  if enemy then 
    table.insert(self.allEnemies, enemy)
    -- Signal.emit('smiley.add', enemy)
  end
end

function EnemyManager:get(ie)
  return self.allEnemies[ie]
end

function EnemyManager:clear()
  for i=#self.allEnemies,1,-1 do
    local e = self.allEnemies[i]
    self.allEnemies[i] = nil
    e:dead()
  end
  -- self.allEnemies = {}
end
  

local floor = math.floor
function EnemyManager:update(dt, grid, ia)
  
  for i=#self.allEnemies,1,-1 do
    local e = self.allEnemies[i]
      
    e:update(dt)
    local ix, iy = floor(e.x), floor(e.y)
    if ia:isOutside(ix, iy) then
      e:dead()
    else
      if grid:isWall(ix, iy) then
        e:invalidMove()
      else
        -- Set the enemy direction
        local ciblex, cibley = ia:findOutput(ix, iy)
        
        if ciblex then
          e:setCible(ciblex+0.5,cibley+0.5)
        else
          e:bug()
        end
      end

    end

    if e.isDead then
      table.remove(self.allEnemies, i)
    else
      e:resetForce()
    end
    
  end
  
  ::continue::
end

function EnemyManager:draw()
  for _,e in ipairs(self.allEnemies) do
    e:draw()
  end
end
    