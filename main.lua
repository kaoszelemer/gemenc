ROT=require('rotLove.src.rot')
lurker = require('lib.lurker')
Camera = require('lib.humpcam')
bump = require('lib.bump')
Class = require('lib.30log')
Camera = require('lib.humpcam')
--GLOBALS

GLOBALS = {



}

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

local function lightCalbak(fov, x, y)


    if x <= 0 or x >= maxX then return end
    if y <= 0 or y >= maxY then return end


    if MAP[x][y].type == 0 then
        return true
    end

    return false
end

function computeCalbak(x, y, r, v)
if x <= 0 or y <= 0 then print ("x kevesebb mint 0") return end
if x > maxX or y > maxY then print ("y kevesebb mint 0") return end

 MAP[x][y].visible = true

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

  player = Player(playerx, playery)
  
  player.camera = Camera(player.x, player.y, 6)
  player.fov=ROT.FOV.Precise:new(lightCalbak)
  INVENTORY = {}
  
  --debug purposes
  INVENTORY[1] = Pistol()
  player.fov:compute(math.floor((player.x - 4) / 16), math.floor((player.y -4) / 16), 2, computeCalbak)
 -- player.fov:compute(player.x , player.y , 10, computeCalbak)
    
end

function love.update(dt)
    MOUSEX, MOUSEY = player.camera:worldCoords(love.mouse.getPosition())
    lurker.update()
    player:move(dt)
    player:physics(dt)

    player.camera:lookAt(player.x, player.y)
    INVENTORY[1]:update(dt)
   
end

function love.draw() 
    player.camera:attach()
    
    
    
        for x = 1, maxX do
            for y = 1, maxY do
                local cell = MAP[x][y] 

                if cell.type == 1 and cell.visible then          
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