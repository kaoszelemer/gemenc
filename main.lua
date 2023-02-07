ROT=require('rotLove.src.rot')
lurker = require('lib.lurker')
Camera = require('lib.humpcam')
bump = require('lib.bump')
Class = require('lib.30log')


--requires
Character = require('classes.characters.Character')
Player = require('classes.characters.Player')

local function mapcreator(x,y,val)
 
   
    MAP[x][y] = {
        type = val,
        w = 16,
        h = 16,
        x = x,
        y = y}

    mapWorld:add(MAP[x][y], MAP[x][y].x, MAP[x][y].y, MAP[x][y].w, MAP[x][y].h)
    
end


function love.load()
   -- f =ROT.Display:new(16,16)
   maxX, maxY = 32, 32
    em=ROT.Map.EllerMaze:new(maxX, maxY)

    mapWorld = bump.newWorld(64)
  --  em:create(calbak)
  MAP = {}
  for x = 1, maxX do
    MAP[x] = {}
    for y = 1, maxY do
        MAP[x][y] = 0
    end
  end


  em:create(mapcreator) 

  local playerx, playery

  for x = 1, math.floor((maxX / 2)) do
    for y = 1, math.floor((maxY / 2)) do
        if MAP[x][y].type == 1 then
            playerx = MAP[x][y].x * 8
            playery = MAP[x][y].y * 8
        end
        
    end
  end
  print(playerx, playery)
  player = Player(playerx, playery)




end




function love.update()
    lurker.update()
end

function love.draw() 
   for x = 1, maxX do
    for y = 1, maxY do
        local cell = MAP[x][y] 
        if cell.type == 0 then          
            love.graphics.setColor(1,1,1)
            love.graphics.rectangle('fill', (cell.x - 1) * 16, (cell.y -1) * 16, 16,16)
        end
    end
   end

   player:draw()

end