u = require 'lib/dijkstra'


board = {
  {1,0,0,0},
  {0,0,1,2},
  {0,0,0,2},
  {0,1,0,0},
  {2,0,1,0}}
ncells = {5,4}


nboard = {}
for ix=0, ncells[1]-1 do
  nboard[ix] = {}
  for iy=0,ncells[2]-1 do
    nboard[ix][iy] = board[ix+1][iy+1]
  end
end
  

res1, res2 = u.Dijkstra(nboard, ncells)

print("end")
    