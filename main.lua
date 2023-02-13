ROT=require('rotLove.src.rot')
--lurker = require('lib.lurker')
Camera = require('lib.humpcam')
bump = require('lib.bump')
Class = require('lib.30log')
Camera = require('lib.humpcam')
Timer = require('lib.humptimer')
Luastar = require('lib.luastar')
--GLOBALS

GLOBALS = {
}

MOUSEX, MOUSEY = 0, 0
maxX, maxY = 16, 16


--requires
Character = require('classes.characters.Character')
Player = require('classes.characters.Player')
Enemy = require('classes.characters.Enemy')

Weapon = require('classes.weapons.Weapon')
Pistol = require('classes.weapons.Pistol')
Drill = require('classes.weapons.Drill')

FieldItem = require('classes.items.FieldItem')
Medpack = require('classes.items.Medpack')
Ammo = require('classes.items.Ammo')
DrillItem = require('classes.items.DrillItem')

Stairs = require('classes.items.Stairs')

Bullet = require('classes.Bullet')
EnemyBullet = require('classes.EnemyBullet')
DrillBullet = require('classes.DrillBullet')



StateMachine = require('classes.StateMachine')


gameState = StateMachine({
    game = {
        name = "game",
        transitions = {"game", "starting", "gameover", "map"} 
    },

    map = {
        name = "map",
        transitions = {"game", "map"}
    },

    starting = {
        name =  "starting",
        transitions = {"starting", "game"}
    },

    gameover = {
        name = "gameover", 
        transitions = {"starting","gameover"}
    },

    },
    "starting"
)




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
        
     --[[    if x == 4 and y == 4 then
            
            val = 0
        end ]]

    if val == 0 then
        table.insert(MAP.emptytiles, MAP[x][y])
    end

 --   print(MAP[x][y].type)
  

    
end

local function lightCalbak(fov, x, y)

  
    if x == nil or y == nil then return end 
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
if MAP[x][y] ~= nil then
    MAP[x][y].visible = true
end
 

end

local function initPlayer(p)
   -- print(MAP.emptytiles[1].x * 16, "KAJAJAJSKJDSLJDSLKJDKLJ")
    local playerx = (MAP.emptytiles[1].x * 16) + 4
    local playery = (MAP.emptytiles[1].y * 16) + 4
    
    player = Player(playerx, playery)
    if p == nil then
       
        player.camera = Camera(player.x, player.y, 6)
        player.fov=ROT.FOV.Precise:new(lightCalbak)
        player.fov:compute(math.floor((player.x - 4) / 16), math.floor((player.y -4) / 16), 2, computeCalbak)

        player.munition = 5
    else
        player.camera = Camera(player.x, player.y, 6)
        player.fov=ROT.FOV.Precise:new(lightCalbak)
        player.fov:compute(math.floor((player.x - 4) / 16), math.floor((player.y -4) / 16), 2, computeCalbak)
        player.hp = p.hp
        player.munition = p.munition
        player.x = playerx
        player.y = playery
        player.tx = math.floor(playerx / 16)
        player.ty = math.floor(playery / 16)
    end
end


local function spawnItems(mpnum, bunum)
  

    for i = 1, mpnum do
        local ix = MAP.emptytiles[love.math.random(2,#MAP.emptytiles)].x * 16
        local iy = MAP.emptytiles[love.math.random(2,#MAP.emptytiles)].y * 16
        local tx = ix /16
        local ty = iy /16
        if MAP[tx][ty].type == 0 and not MAP[tx][ty].occupied then
            table.insert(ITEMS, Medpack(ix,iy))
          --  MAP[tx][ty].type = 2
            MAP[tx][ty].occupied = true
        end
    end

    for i = 1, bunum  do
        local ix = MAP.emptytiles[love.math.random(2,#MAP.emptytiles)].x * 16
        local iy = MAP.emptytiles[love.math.random(2,#MAP.emptytiles)].y * 16
        local tx = ix /16
        local ty = iy /16

        if MAP[tx][ty].type == 0 and not MAP[tx][ty].occupied then
            table.insert(ITEMS, Ammo(ix,iy))
           -- MAP[tx][ty].type = 2
            MAP[tx][ty].occupied = true
        end
    end

    if LEVEL == 2 then
     
        table.insert(ITEMS, DrillItem(player.x + 8,player.y))
    
    end

      

end

local function spawnEnemies(num)
    for i = 1, num do
        local ix = MAP.emptytiles[love.math.random(4,#MAP.emptytiles)].x * 16
        local iy = MAP.emptytiles[love.math.random(4,#MAP.emptytiles)].y * 16
        local tx = ix /16
        local ty = iy /16
        if MAP[tx][ty].type == 0 then
            table.insert(ENEMIES, Enemy(ix,iy))

        end
    end

end


local function spawnStairs()

    for x = maxX /2, maxX do
        for y = maxY /2, maxY do
         --   print(MAP[x][y].occupied ~= true)
            if MAP[x][y].occupied ~= true and MAP[x][y].type == 0 and not MAP.stairsinserted then
                MAP[x][y].occupied = true
                table.insert(ITEMS, Stairs(x * 16, y * 16))
                MAP.stairsinserted = true
                print("stairs inserted")
            end
        end
    end

end

local function chooseRandomMap()
    local case = love.math.random(1,4)
    local mapmaker
    if LEVEL == 1 then case = 1  end
    if case == 1 then
        maxX, maxY = 16,16
        mapmaker = ROT.Map.EllerMaze:new(maxX, maxY)
        print("ellermaze")
        MAP.type = "ellermaze"
    elseif case == 3 then
        maxX, maxY = 48,48
       mapmaker = ROT.Map.Cellular:new(maxX, maxY)
       MAP.type = "Cellular"
       print("cellular")

    elseif case == 2 then
        maxX, maxY = 64,64
        local rng = {4}
        mapmaker = ROT.Map.Rogue:new(maxX, maxY,  {3,2,4,4})
        MAP.type = "Uniform"
        print("Uniform")
    elseif case == 4 then
        maxX, maxY = 32,32
        MAP.type = "IceyMaze"
       mapmaker = ROT.Map.IceyMaze:new(maxX, maxY)
    end

  
    return mapmaker

end

local function setDifficultyForMapAndLevel()
    if MAP.type == "Cellular" then
        MAP.maxitem = {10, 24}
        MAP.maxenemy = 50 + LEVEL
      end
      if MAP.type == "ellermaze" then
        MAP.maxitem = {5, 8}
        MAP.maxenemy = 10 + LEVEL
      end
      if MAP.type == "Uniform" then
        MAP.maxitem = {20, 40}
        MAP.maxenemy = 80 + LEVEL
      end
      if MAP.type == "IceyMaze" then
        MAP.maxitem = {8, 12}
        MAP.maxenemy = 30 + LEVEL
      end
end

local function setTileImagesForMap(type)
    print(type)
    if type == "ellermaze" then
        TILES.floor = TILES.ellerfloor
        TILES.wall = TILES.ellerwall
    elseif type == "Uniform" then
        TILES.floor = TILES.uniformfloor
        TILES.wall = TILES.uniformwall
    elseif type == "IceyMaze" then
        TILES.floor = TILES.iceyfloor
        TILES.wall = TILES.iceywall
    elseif type == "Cellular" then
        TILES.floor = TILES.cellularfloor
        TILES.wall = TILES.cellularwall
    end

end


function changeLevel()
    LEVEL = LEVEL + 1
   MAP = {}
   ENEMIES = {}
   ITEMS = {}
   BLOODSPLATTERS = {}
  
   MAP.walltiles = {}
   MAP.emptytiles = {}
   MAP.itemtiles = {}
   for i = 1, #BULLETS do
 
    if BULLETS[i] ~= nil then
   
        table.remove(BULLETS, i)
      
    end
  end
   BULLETS = {}
   print("changing level to level"..LEVEL)


   local mapmaker = chooseRandomMap()
   setTileImagesForMap(MAP.type)
   for x = 1, maxX do
    MAP[x] = {}
    for y = 1, maxY do
        MAP[x][y] = {}
        MAP[x][y].visible = false
    end
   end
   
  -- 
 
if MAP.type == "Cellular" then
    mapmaker:randomize(0.5)

end



  
    mapWorld = bump.newWorld(64)
    mapmaker:create(mapcreator) 
    setDifficultyForMapAndLevel()
    initPlayer(player)
    spawnStairs()

    spawnItems(MAP.maxitem[1],MAP.maxitem[2])
    spawnEnemies(MAP.maxenemy)

    player.fov=ROT.FOV.Precise:new(lightCalbak)
  


    
end




function love.load()
  love.graphics.setDefaultFilter("nearest", "nearest") 
  love.mouse.setVisible(false)
  mouseReticleImage = love.graphics.newImage("assets/reticle.png")


    
    
    mapWorld = bump.newWorld(64)
    
    MAP = {}
    LEVEL = 1
    MAP.emptytiles = {}
    MAP.walltiles = {}
    MAP.itemtiles = {}
    MAP.maxitem = {5, 12}
    MAP.maxenemy = 10
    ITEMS = {}
    ENEMIES = {}
    BLOODSPLATTERS = {}


    TILES = {
        wall = {},
        floor = {},
        ellerfloor = {img = love.graphics.newImage("assets/floortile.png")},
        ellerwall = {img = love.graphics.newImage("assets/walltile.png")},
        iceyfloor = {img = love.graphics.newImage("assets/iceymazetile.png")},
        iceywall = {img = love.graphics.newImage("assets/iceymazewall.png")},
        cellularfloor = {img = love.graphics.newImage("assets/cellulartile.png")},
        cellularwall = {img = love.graphics.newImage("assets/cellularwall.png")},
        uniformfloor = {img = love.graphics.newImage("assets/uniformtile.png")},
        uniformwall = {img = love.graphics.newImage("assets/uniformwall.png")}
    }

    IMAGES = {
        titlescreen = love.graphics.newImage("assets/titlescreen.png"),
        godeeper = love.graphics.newImage("assets/godeeper.png")
    }
    
    
    local mapmaker = chooseRandomMap()
    setTileImagesForMap(MAP.type)
    for x = 1, maxX do
        MAP[x] = {}
        for y = 1, maxY do
            MAP[x][y] = 0
        end
    end
    setDifficultyForMapAndLevel()
    
    if MAP.type == "Cellular" then
        
        mapmaker:randomize(0.5)

    end

--[[     if MAP.type == "Uniform" then
        for x = 1, maxX do
            MAP[x] = {}
            for y = 1, maxY do
                MAP[x][y] = {}
            end
        end
    end ]]
    mapmaker:create(mapcreator) 


    initPlayer()
    --print(MAP.maxitem)
    spawnStairs()
    spawnItems(MAP.maxitem[1],MAP.maxitem[2])
    spawnEnemies(MAP.maxenemy)



  INVENTORY = {}

  BULLETS = {}

  --debug purposes
  INVENTORY[1] = Pistol()

   -- print(gameState.state)
    
end

function love.update(dt)

    if gameState.state == gameState.states.game then
      --  print("kldjssdkldskl")
        MOUSEX, MOUSEY = player.camera:worldCoords(love.mouse.getPosition())
     --   lurker.update()
        player:move(dt)
        player:update(dt)
        Character:update(dt)
        player:physics(dt)
       

        player.camera:lookAt(player.x, player.y, 6)
        INVENTORY[1]:update(dt)
        for i = 1, #BULLETS do
            if BULLETS[i] ~= nil then
                BULLETS[i]:update(dt)
            end
        end

        for i = 1, #ITEMS do
    
                ITEMS[i]:updateVisibility()
        
        end
    
        for i = 1, #ENEMIES do
        
                ENEMIES[i]:move(dt)
                ENEMIES[i]:update(dt)
        end
    end


    Timer.update(dt)
   -- print(ENEMIES[1].x)
   
end

function love.draw() 

    if gameState.state == gameState.states.starting then
        love.graphics.draw(IMAGES.titlescreen, 0,0)
    end

    if gameState.state == gameState.states.game then
        player.camera:attach()
  
        for x = 1, maxX do
            for y = 1, maxY do
                if MAP[x][y] ~= nil then
                    local cell = MAP[x][y] 

                    if cell.type == 1 and cell.visible then          
                        --[[ love.graphics.setColor(1,1,1)
                        love.graphics.rectangle('fill', (cell.x) * 16, (cell.y) * 16, 16,16) ]]
                        love.graphics.draw(TILES.wall.img, cell.x * 16, cell.y * 16)
                    end
                    if cell.type == 0 and cell.visible then
                        love.graphics.draw(TILES.floor.img, cell.x * 16, cell.y* 16)
                    end
                end
            end
        end

        
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
        
        
        player:draw()
        for i = 1, #ENEMIES do
            ENEMIES[i]:draw()
        end
        love.graphics.draw(mouseReticleImage, MOUSEX, MOUSEY)

        player.camera:detach()

        love.graphics.print("AMMO: "..player.munition, 0,0)
        love.graphics.print("HP: "..player.hp, 0,16)
        if player.standingonStairs then
           
            love.graphics.draw(IMAGES.godeeper, player.x + 200, player.y + 80)
        end
    end

    if gameState.state == gameState.states.map then
        for x = 1, maxX do
            for y = 1, maxY do
                if MAP[x][y] ~= nil then
                    local cell = MAP[x][y] 

                    if cell.type == 1 and cell.visible then          
                        --[[ love.graphics.setColor(1,1,1)
                        love.graphics.rectangle('fill', (cell.x) * 16, (cell.y) * 16, 16,16) ]]
                        love.graphics.draw(TILES.wall.img, cell.x * 16, cell.y * 16)
                    end
                    if cell.type == 0 and cell.visible then
                        love.graphics.draw(TILES.floor.img, cell.x * 16, cell.y* 16)
                    end
                    for i = 1, #ITEMS do
                        --   print(ITEMS[i].x)
                        ITEMS[i]:draw()
                    end
                    player:draw()
                end
            end
        end
    end

   

end


function love.mousepressed(x, y, button, istouch)

    if gameState.state == gameState.states.starting then
        gameState:changeState(gameState.states.game)
    end


    if gameState.state == gameState.states.game then
        if button == 1 then 
            player:action(MOUSEX,MOUSEY)
        end
    end
 end

 function love.keypressed(key)
    if gameState.state == gameState.states.map and player.onMap == true then
        if key == "tab" then
        
            Timer.after(0.5, function ()
                 player.onMap = false
            end)

            player.camera.scale = 6

            gameState:changeState(gameState.states.game)
        end
    
    end
    
    if gameState.state == gameState.states.game and player.onMap ~= true then
            if key == "tab" then
                player.camera.scale = 1
            gameState:changeState(gameState.states.map)
            
            player.onMap = true

            end
    end


 end