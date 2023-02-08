ROT=require('rotLove.src.rot')
lurker = require('lib.lurker')
Camera = require('lib.humpcam')
bump = require('lib.bump')
Class = require('lib.30log')
Camera = require('lib.humpcam')
--GLOBALS
MOUSEX, MOUSEY = 0, 0

--requires
Character = require('classes.characters.Character')
Player = require('classes.characters.Player')

Weapon = require('classes.weapons.Weapon')
Pistol = require('classes.weapons.Pistol')

local function mapcreator(x,y,val)
 
   
    MAP[x][y] = {
        type = val,
        w = 16,
        h = 16,
        x = x,
        y = y}

    if val == 1 then
        mapWorld:add(MAP[x][y], MAP[x][y].x * MAP[x][y].w, MAP[x][y].y * MAP[x][y].h, MAP[x][y].w, MAP[x][y].h)
        table.insert(MAP.walltiles, MAP[x][y])
    end

    if val == 0 then
        table.insert(MAP.emptytiles, MAP[x][y])
    end
    
end


function love.load()
    love.graphics.setDefaultFilter("nearest", "nearest") 
   -- f =ROT.Display:new(16,16)
   maxX, maxY = 32, 32
    em=ROT.Map.EllerMaze:new(maxX, maxY)

    mapWorld = bump.newWorld(64)
  --  em:create(calbak)
  MAP = {}
  MAP.emptytiles = {}
  MAP.walltiles = {}
  for x = 1, maxX do
    MAP[x] = {}
    for y = 1, maxY do
        MAP[x][y] = 0
    end
  end


  em:create(mapcreator) 
  
   local playerx = (MAP.emptytiles[1].x * 16) + 4
   local playery = (MAP.emptytiles[1].y * 16) + 4
 

  print(playerx, playery)
  player = Player(playerx, playery)

  player.camera = Camera(player.x, player.y, 6)

  INVENTORY = {}

  --debug purposes
  INVENTORY[1] = Pistol()

end


function love.mousemoved( x, y)
    MOUSEX = x
    MOUSEY = y
end



function love.update(dt)
    lurker.update()
    player:move(dt)
    player:physics(dt)
    local dx,dy = player.x - player.camera.x, player.y - player.camera.y
    player.camera:move(dx/2, dy/2)
    INVENTORY[1]:update(dt)

end

function love.draw() 
    player.camera:attach()



        for x = 1, maxX do
            for y = 1, maxY do
                local cell = MAP[x][y] 
                if cell.type == 1 then          
                    love.graphics.setColor(1,1,1)
                    love.graphics.rectangle('fill', (cell.x) * 16, (cell.y) * 16, 16,16)
                end
            end
        end

        player:draw()

        if INVENTORY ~= nil then
            INVENTORY[1]:draw()
        end
  


   player.camera:detach()


end