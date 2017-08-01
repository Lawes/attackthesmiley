
local profile = require('lib/profile')

function test()
  local a = {}
  
  for ix=0,100 do
    a[ix] = {}
    for iy=0,100 do
      a[ix][iy]= {}
    end
  end
  
  return a
end


function test1(a)
  local a = {}
  for ix=0,100 do
    a[ix] = {}
    for iy=0,100 do
      a[ix][iy]= {}
    end
  end
  return a
end

function test2(a)
  
  for ix=0,100 do
    local item = a[ix]
    for iy=0,100 do
      item[iy]= nil
    end
  end
  return a
end

function testInsert(a)
  for ix=0,100 do
    for iy=0,100 do
      -- local item = a[ix][iy]
      --item[#item+1] = 1
    end
  end
  return a
end  


profile.hookall("Lua")
profile.start()
local a = test()
for ix=1,100 do
  a[0][0] = {1,2,3}
  a=test1(a)
  testInsert(a)
end
a[0][0] = {1,2,3}
for ix=1,100 do
  a[0][0] = {1,2,3}
  a=test2(a)
end

profile.stop()
print(a)
print("coucou")
print(profile.report('time'))