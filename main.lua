ROT=require('rotLove.src.rot')
lurker = require('lib.lurker')
Camera = require('lib.humpcam')
bump = require('lib.bump')
Class = require('lib.30log')
Camera = require('lib.humpcam')
Timer = require('lib.humptimer')
--GLOBALS

GLOBALS = {
}

MOUSEX, MOUSEY = 0, 0

--requires
Character = require('classes.characters.Character')
Player = require('classes.characters.Player')

Weapon = require('classes.weapons.Weapon')
Pistol = require('classes.weapons.Pistol')

FieldItem = require('classes.items.FieldItem')
Medpack = require('classes.items.Medpack')

Bullet = require('classes.Bullet')



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
if x <= 0 or y <= 0 then  return end
if x > maxX or y > maxY then return end

 MAP[x][y].visible = true

end

local function initPlayer()
    local playerx = (MAP.emptytiles[1].x * 16) + 4
    local playery = (MAP.emptytiles[1].y * 16) + 4
  
    player = Player(playerx, playery)
    
    player.camera = Camera(player.x, player.y, 6)
    player.fov=ROT.FOV.Precise:new(lightCalbak)
    player.fov:compute(math.floor((player.x - 4) / 16), math.floor((player.y -4) / 16), 2, computeCalbak)
end


local function spawnItems()
  
    local ix = MAP.emptytiles[love.math.random(2,#MAP.emptytiles)].x * 16
    local iy = MAP.emptytiles[love.math.random(2,#MAP.emptytiles)].y * 16
    print(ix, iy)
    print("addded")
    table.insert(ITEMS, Medpack(ix,iy))
end





function love.load()
  love.graphics.setDefaultFilter("nearest", "nearest") 
  
  maxX, maxY = 32, 32
  em=ROT.Map.EllerMaze:new(maxX, maxY)

  mapWorld = bump.newWorld(64)

  MAP = {}
  MAP.emptytiles = {}
  MAP.walltiles = {}
  ITEMS = {}

  

  for x = 1, maxX do
    MAP[x] = {}
    for y = 1, maxY do
        MAP[x][y] = 0
    end
  end

  em:create(mapcreator) 

  for i = 1, 16 do
    spawnItems()
  end


  initPlayer()


  INVENTORY = {}

  BULLETS = {}

  --debug purposes
  INVENTORY[1] = Pistol()


    
end

function love.update(dt)
    MOUSEX, MOUSEY = player.camera:worldCoords(love.mouse.getPosition())
    lurker.update()
    player:move(dt)
    player:physics(dt)
    Timer.update(dt)

    player.camera:lookAt(player.x, player.y)
    INVENTORY[1]:update(dt)
    for i = 1, #BULLETS do
        BULLETS[i]:update(dt)
    end
   
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
  
        for i = 1, #BULLETS do
            BULLETS[i]:draw()
        end

        for i = 1, #ITEMS do
         --   print(ITEMS[i].x)
            ITEMS[i]:draw()
        end

   player.camera:detach()


end


function love.mousepressed(x, y, button, istouch)
    if button == 1 then 
        player:action(MOUSEX,MOUSEY)
    end
 end