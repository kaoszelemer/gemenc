ROT=require('rotLove.src.rot')
--lurker = require('lib.lurker')
Camera = require('lib.humpcam')
bump = require('lib.bump')
Class = require('lib.30log')
Camera = require('lib.humpcam')
Timer = require('lib.humptimer')
Luastar = require('lib.luastar')
Ripple = require('lib.ripple')
--GLOBALS

GLOBALS = {
    bossonwhichlevel = 4,
    mgonwhichlevel = 3,
    sgonwhichlevel = 6,
    drillonwhichlevel = 2,
    howlongbeforestart = 3,
    drawenemycolliders = false,
    timebetweenspecialshots = 5,
    numberofenemies = 0,
    numberofitems = 0,
    numberofvisibletiles = 0,
    howmanylevelstoskip = 1,
--    startonwhichlevel = 11
}


local shadowCanvas


MOUSEX, MOUSEY = 0, 0
maxX, maxY = 16, 16
tileW, tileH = 32,32
SOUNDS = require('sounds')

--requires
Character = require('classes.characters.Character')
Player = require('classes.characters.Player')
Enemy = require('classes.characters.Enemy')
Turret = require('classes.characters.Turret')
Tank = require('classes.characters.Tank')
Spider = require('classes.characters.Spider')
Commando = require('classes.characters.Commando')
BossRobot = require('classes.characters.BossRobot')
BossSpider = require('classes.characters.BossSpider')
BossRefrig = require('classes.characters.BossRefrig')
Sniper = require('classes.characters.Sniper')
FreezeTower = require('classes.characters.FreezeTower')

Weapon = require('classes.weapons.Weapon')
Pistol = require('classes.weapons.Pistol')
Drill = require('classes.weapons.Drill')
MachineGun = require('classes.weapons.MachineGun')
Specialweapon = require('classes.weapons.Specialweapon')
ShotGun = require('classes.weapons.ShotGun')

FieldItem = require('classes.items.FieldItem')
Medpack = require('classes.items.Medpack')
Ammo = require('classes.items.Ammo')
DrillItem = require('classes.items.DrillItem')
Shield = require('classes.items.Shield')
MGitem = require('classes.items.MGitem')
SpeedUp = require('classes.items.SpeedUp')
SGitem = require('classes.items.SGitem')

Stairs = require('classes.items.Stairs')

Bullet = require('classes.Bullet')
EnemyBullet = require('classes.EnemyBullet')
DrillBullet = require('classes.DrillBullet')
TankBullet = require('classes.TankBullet')
SpecialBullet = require('classes.SpecialBullet')
FreezeBullet = require('classes.FreezeBullet')
lilFreezeBullet = require('classes.lilFreezeBullet')

Card = require('classes.cards.Card')
MaxHpUp = require('classes.cards.MaxHpUp')
MaxSpUp = require('classes.cards.MaxSpUp')
MaxSpeedUp = require('classes.cards.MaxSpeedUp')


StateMachine = require('classes.Statemachine')


SCREENSHAKE = {

    t = 0,
    shakeDuration = -1,
    shakeMagnitude = 0

}


gameState = StateMachine({
    game = {
        name = "game",
        transitions = {"game", "starting", "gameover", "map", "trans", "pause", "levelup"} 
    },

    map = {
        name = "map",
        transitions = {"game", "map", "trans"}
    },

    starting = {
        name =  "starting",
        transitions = {"starting", "game", "trans", "countback"}
    },

    gameover = {
        name = "gameover", 
        transitions = {"starting","gameover", "trans"}
    },

    trans = {
        name = "trans",
        transitions = {"starting", "gameover", "game", "map", "trans", "countback"}
    },

    countback = {
        name = "countback",
        transitions = {"starting", "trans", "game", "countback", "starting", "levelup"}
    
    },

    pause = {
        name = "pause",
        transitions = {"game", "pause"}
    },

    levelup = {
        name = "levelup",
        transitions = {"game", "levelup", "countback"}
    }

    },
    "starting"
)


function shuffleTable(t)
    for i = #t, 2, -1 do
      local j = love.math.random(i)
      t[i], t[j] = t[j], t[i]
    end
end

function shuffleTableXY(t)

    for i = #t, 2, -1 do
        local j = love.math.random(i)
        t[i].x, t[i].y, t[j].x, t[j].y = t[j].x, t[j].y, t[i].x, t[i].y
    end

end


function screenShake(dur, mag)

    SCREENSHAKE.t, SCREENSHAKE.shakeDuration, SCREENSHAKE.shakeMagnitude = 0, dur, mag

end

local function mapcreator(x,y,val)
 
   
    MAP[x][y] = {
        type = val,
        w = tileW,
        h = tileH,
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

    local playerx = (MAP.emptytiles[1].x * tileW) + 4
    local playery = (MAP.emptytiles[1].y * tileH) + 4
  
    table.remove(MAP.emptytiles, 1)
    
    
    player = Player(playerx, playery)
    player.specialweapon = {}
    table.insert(player.specialweapon, Specialweapon(playerx, playery))
    
    MAP[player.tx][player.ty].occupied = true
    if p == nil then
       
        player.camera = Camera(player.x, player.y, 4)
        player.fov=ROT.FOV.Precise:new(lightCalbak)
        player.fov:compute(math.floor((player.x - 4) / tileW), math.floor((player.y -4) / tileH), 2, computeCalbak)

        player.munition = 51
    else
        player.hp = p.hp
        player.sp = p.sp
        player.xp = p.xp
        player.level = p.level
        player.maxhp =  p.maxhp
        player.maxsp = p.maxsp
        player.speed = p.speed
        if p.originalspeed ~= nil then
            player.originalspeed = p.originalspeed
        end
        player.maxxp = p.maxxp
        player.munition = p.munition
        player.x = playerx
        player.y = playery
        player.tx = math.floor(playerx / tileW)
        player.ty = math.floor(playery / tileH)
        player.camera = Camera(player.x, player.y, 4)
        player.fov=ROT.FOV.Precise:new(lightCalbak)
        player.fov:compute(math.floor((player.x - 4) / tileW), math.floor((player.y -4) / tileH), 2, computeCalbak)
    end
end


local function spawnItems(mpnum, bunum)
  

    for i = 1, mpnum do
        local ix = MAP.emptytiles[love.math.random(2,#MAP.emptytiles)].x * tileW
        local iy = MAP.emptytiles[love.math.random(2,#MAP.emptytiles)].y * tileH
        local tx = ix / tileW
        local ty = iy / tileH
        if MAP[tx][ty].type == 0 and not MAP[tx][ty].occupied then
            table.insert(ITEMS, Medpack(ix + tileW / 2 - 4,iy + tileW/ 2- 4))
          --  MAP[tx][ty].type = 2
            MAP[tx][ty].occupied = true
        end
    end

    for i = 1, bunum  do
        local ix = MAP.emptytiles[love.math.random(2,#MAP.emptytiles)].x * tileW
        local iy = MAP.emptytiles[love.math.random(2,#MAP.emptytiles)].y * tileH
        local tx = ix / tileW
        local ty = iy / tileH

        if MAP[tx][ty].type == 0 and not MAP[tx][ty].occupied then
            table.insert(ITEMS, Ammo(ix + tileW / 2 - 4,iy + tileW/ 2 - 4))
           -- MAP[tx][ty].type = 2
           GLOBALS.numberofitems = GLOBALS.numberofitems + 1
            MAP[tx][ty].occupied = true
        end
    end

    if LEVEL == GLOBALS.drillonwhichlevel then
        GLOBALS.numberofitems = GLOBALS.numberofitems + 1
        table.insert(ITEMS, DrillItem(player.x + 8,player.y + 8))
    
    end
    if LEVEL == GLOBALS.mgonwhichlevel then
        GLOBALS.numberofitems = GLOBALS.numberofitems + 1
        table.insert(ITEMS, MGitem(player.x + 8,player.y + 8))
    
    end
    if LEVEL == GLOBALS.sgonwhichlevel then
        GLOBALS.numberofitems = GLOBALS.numberofitems + 1
        table.insert(ITEMS, SGitem(player.x + 8,player.y + 8))
    end

    local ix = MAP.emptytiles[love.math.random(2,#MAP.emptytiles)].x * tileW
    local iy = MAP.emptytiles[love.math.random(2,#MAP.emptytiles)].y * tileH
    local tx = ix / tileW
    local ty = iy / tileH

    if MAP[tx][ty].type == 0  then
        GLOBALS.numberofitems = GLOBALS.numberofitems + 1
        table.insert(ITEMS, Shield(ix + tileW / 2,iy + tileW/ 2))
       -- MAP[tx][ty].type = 2
        MAP[tx][ty].occupied = true
    end
    local ix = MAP.emptytiles[love.math.random(2,#MAP.emptytiles)].x * tileW
    local iy = MAP.emptytiles[love.math.random(2,#MAP.emptytiles)].y * tileH
    local tx = ix / tileW
    local ty = iy / tileH
    if MAP[tx][ty].type == 0 then
        GLOBALS.numberofitems = GLOBALS.numberofitems + 1
        table.insert(ITEMS, SpeedUp(ix + tileW / 2 - 8,iy + tileW/ 2 - 8))
       -- MAP[tx][ty].type = 2
        MAP[tx][ty].occupied = true
    end

      

end

local function spawnEnemies(num)

    if num == 1 then
        local ix = MAP[maxX/2][maxY/2].x * tileW
        local iy = MAP[maxX/2][maxY/2].x * tileH
        if LEVEL == GLOBALS.bossonwhichlevel * 4 then

            table.insert(ENEMIES, BossRobot(ix - 32,iy - 32))
            return
        end
        if LEVEL == GLOBALS.bossonwhichlevel * 2 then
            table.insert(ENEMIES, BossSpider(ix - 32,iy - 32))
            return
        end
        if LEVEL == GLOBALS.bossonwhichlevel * 3 then
            table.insert(ENEMIES, BossRefrig(ix - 32,iy - 32))
            return
        end
        if LEVEL == GLOBALS.bossonwhichlevel then
            Timer.every(1, function ()
                local index = love.math.random(4,#MAP.emptytiles)
                local ix = MAP.emptytiles[index].x * tileW
                local iy = MAP.emptytiles[index].y * tileH
                local tx = ix / tileW
                local ty = iy / tileH
                
                if MAP[tx][ty].type == 0 then
                    table.insert(ENEMIES, Commando(ix + tileW / 2 - 4,iy + tileW/ 2 - 4))
                   GLOBALS.numberofenemies = GLOBALS.numberofenemies + 1
                end
            end, 40)
            Timer.after(23, function ()
                Timer.every(1, function ()
                    local index = love.math.random(4,#MAP.emptytiles)
                    local ix = MAP.emptytiles[index].x * tileW
                    local iy = MAP.emptytiles[index].y * tileH
                    local tx = ix / tileW
                    local ty = iy / tileH
                    
                    if MAP[tx][ty].type == 0 then
                        table.insert(ENEMIES, Enemy(ix + tileW / 2 - 4,iy + tileW/ 2 - 4))
                    --    table.remove(MAP.emptytiles, index)
                        GLOBALS.numberofenemies = GLOBALS.numberofenemies + 1
                    end
                end, 40)
                Timer.every(2, function ()
                    local index = love.math.random(4,#MAP.emptytiles)
                    local ix = MAP.emptytiles[index].x * tileW
                    local iy = MAP.emptytiles[index].y * tileH
                    local tx = ix / tileW
                    local ty = iy / tileH
                    
                    if MAP[tx][ty].type == 0 then
                        table.insert(ENEMIES, Tank(ix + tileW / 2 - 4,iy + tileW/ 2 - 4))
                        GLOBALS.numberofenemies = GLOBALS.numberofenemies + 1
                      --  table.remove(MAP.emptytiles, index)
                    end
                end, 10)
                
            end)
            return
        end
    end

    if LEVEL < GLOBALS.bossonwhichlevel then

        for i = 1, num /2 do
    
            local index = love.math.random(4,#MAP.emptytiles)
            local ix = MAP.emptytiles[index].x * tileW
            local iy = MAP.emptytiles[index].y * tileH
            local tx = ix / tileW
            local ty = iy / tileH
            
            if MAP[tx][ty].type == 0 then
                table.insert(ENEMIES, Enemy(ix + tileW / 2 - 4,iy + tileW/ 2 - 4))
                table.remove(MAP.emptytiles, index)
                GLOBALS.numberofenemies = GLOBALS.numberofenemies + 1
            end
        end
    elseif LEVEL > GLOBALS.bossonwhichlevel and LEVEL < GLOBALS.bossonwhichlevel * 2 then
        for i = 1, num /4 do
    
            local index = love.math.random(4,#MAP.emptytiles)
            local ix = MAP.emptytiles[index].x * tileW
            local iy = MAP.emptytiles[index].y * tileH
            local tx = ix / tileW
            local ty = iy / tileH
            
            if MAP[tx][ty].type == 0 then
                table.insert(ENEMIES, Enemy(ix + tileW / 2 - 4,iy + tileW/ 2 - 4))
                table.remove(MAP.emptytiles, index)
                GLOBALS.numberofenemies = GLOBALS.numberofenemies + 1
            end
        end
        for i = 1, num /4 do
    
            local index = love.math.random(4,#MAP.emptytiles)
            local ix = MAP.emptytiles[index].x * tileW
            local iy = MAP.emptytiles[index].y * tileH
            local tx = ix / tileW
            local ty = iy / tileH
            
            if MAP[tx][ty].type == 0 then
                table.insert(ENEMIES, Commando(ix + tileW / 2 - 4,iy + tileW/ 2 - 4))
                table.remove(MAP.emptytiles, index)
                GLOBALS.numberofenemies = GLOBALS.numberofenemies + 1
            end
        end
    elseif LEVEL > GLOBALS.bossonwhichlevel * 2 and LEVEL < GLOBALS.bossonwhichlevel * 3 then
        for i = 1, num /4 do
    
            local index = love.math.random(4,#MAP.emptytiles)
            local ix = MAP.emptytiles[index].x * tileW
            local iy = MAP.emptytiles[index].y * tileH
            local tx = ix / tileW
            local ty = iy / tileH
            
            if MAP[tx][ty].type == 0 then
                table.insert(ENEMIES, Sniper(ix + tileW / 2 - 4,iy + tileW/ 2 - 4))
                table.remove(MAP.emptytiles, index)
                GLOBALS.numberofenemies = GLOBALS.numberofenemies + 1
            end
        end
        for i = 1, num /4 do
    
            local index = love.math.random(4,#MAP.emptytiles)
            local ix = MAP.emptytiles[index].x * tileW
            local iy = MAP.emptytiles[index].y * tileH
            local tx = ix / tileW
            local ty = iy / tileH
            
            if MAP[tx][ty].type == 0 then
                table.insert(ENEMIES, Commando(ix + tileW / 2 - 4,iy + tileW/ 2 - 4))
                table.remove(MAP.emptytiles, index)
                GLOBALS.numberofenemies = GLOBALS.numberofenemies + 1
            end
        end
    else
        for i = 1, num /2 do
    
            local index = love.math.random(4,#MAP.emptytiles)
            local ix = MAP.emptytiles[index].x * tileW
            local iy = MAP.emptytiles[index].y * tileH
            local tx = ix / tileW
            local ty = iy / tileH
            
            if MAP[tx][ty].type == 0 then
                table.insert(ENEMIES, Sniper(ix + tileW / 2 - 4,iy + tileW/ 2 - 4))
                table.remove(MAP.emptytiles, index)
                GLOBALS.numberofenemies = GLOBALS.numberofenemies + 1
            end
        end
        for i = 1, num /2 do
    
            local index = love.math.random(4,#MAP.emptytiles)
            local ix = MAP.emptytiles[index].x * tileW
            local iy = MAP.emptytiles[index].y * tileH
            local tx = ix / tileW
            local ty = iy / tileH
            
            if MAP[tx][ty].type == 0 then
                table.insert(ENEMIES, Commando(ix + tileW / 2 - 4,iy + tileW/ 2 - 4))
                table.remove(MAP.emptytiles, index)
                GLOBALS.numberofenemies = GLOBALS.numberofenemies + 1
            end
        end
    end

  

    if LEVEL < GLOBALS.bossonwhichlevel * 2 then 

        for i = num/4, num do
            if #MAP.emptytiles > 0 then
                local index = love.math.random(4,#MAP.emptytiles)
                local ix = MAP.emptytiles[index].x * tileW
                local iy = MAP.emptytiles[index].y * tileH
                local tx = ix / tileW
                local ty = iy / tileH
                if MAP[tx][ty].type == 0 then
                    table.insert(ENEMIES, Turret(ix + tileW / 2  - 8,iy + tileW/ 2 - 8))
                    table.remove(MAP.emptytiles, index)
                    GLOBALS.numberofenemies = GLOBALS.numberofenemies + 1
                end
            end
        end
    else
        for i = num/4, num do
            if #MAP.emptytiles > 0 then
                local index = love.math.random(4,#MAP.emptytiles)
                local ix = MAP.emptytiles[index].x * tileW
                local iy = MAP.emptytiles[index].y * tileH
                local tx = ix / tileW
                local ty = iy / tileH
                if MAP[tx][ty].type == 0 then
                    table.insert(ENEMIES, FreezeTower(ix + tileW / 2  - 8,iy + tileW/ 2 - 8))
                    table.remove(MAP.emptytiles, index)
                    GLOBALS.numberofenemies = GLOBALS.numberofenemies + 1
                end
            end
        end
    end



    for i = num/4, num do
        if #MAP.emptytiles > 0 then
            local index = love.math.random(4,#MAP.emptytiles)
            local ix = MAP.emptytiles[index].x * tileW
            local iy = MAP.emptytiles[index].y * tileH
            local tx = ix / tileW
            local ty = iy / tileH
            if MAP[tx][ty].type == 0 then
                table.insert(ENEMIES, Tank(ix + tileW / 2 - 4, (iy + tileW/ 2) - 4))
              
                GLOBALS.numberofenemies = GLOBALS.numberofenemies + 1
            end
        end
    end

    for i = 1, num do
        local index = love.math.random(4,#MAP.emptytiles)
        local ix = MAP.emptytiles[index].x * tileW
        local iy = MAP.emptytiles[index].y * tileH
        local tx = ix / tileW
        local ty = iy / tileH
        if MAP[tx][ty].type == 0 then
            table.insert(ENEMIES, Spider(ix + tileW / 2 - 4, (iy + tileW/ 2) - 4))
       
            GLOBALS.numberofenemies = GLOBALS.numberofenemies + 1
        end
    end


end


function spawnStairs()

    for x = 6, maxX do
        for y = 6, maxY do
         --   print(MAP[x][y].occupied ~= true)
            if MAP[x][y].occupied ~= true and not MAP.stairsinserted and MAP[x][y].type ~= 1 then
                MAP[x][y].occupied = true
                MAP[x][y].type = 0
                table.insert(ITEMS, Stairs(x * tileW, y * tileH))
                MAP.stairsinserted = true
                print("stairs inserted")
            end
        end
    end

end

local function chooseRandomMap()
  
    local mapmaker
    if LEVEL <= GLOBALS.bossonwhichlevel then
        maxX, maxY = 13 + LEVEL,13 + LEVEL  
        mapmaker = ROT.Map.EllerMaze:new(maxX, maxY)
        print("ellermaze")
        MAP.type = "ellermaze"
    end
    if LEVEL > GLOBALS.bossonwhichlevel and LEVEL <= GLOBALS.bossonwhichlevel * 2 then
        maxX, maxY = 14 + LEVEL , 14 + LEVEL
        mapmaker = ROT.Map.Cellular:new(maxX, maxY)
        MAP.type = "Cellular"
        print("cellular")
    end
    if LEVEL > GLOBALS.bossonwhichlevel * 2 and LEVEL <= GLOBALS.bossonwhichlevel * 3 then
        maxX, maxY = 18,18
        MAP.type = "IceyMaze"
        mapmaker = ROT.Map.IceyMaze:new(maxX, maxY)
        print("IceyMaze")
    end
    if LEVEL > GLOBALS.bossonwhichlevel * 3 and LEVEL == GLOBALS.bossonwhichlevel * 4 then
        maxX, maxY = 28,28
        mapmaker = ROT.Map.Rogue:new(maxX, maxY,  {1,1,1,1})
        MAP.type = "Uniform"
        print("Uniform")
    end  
    return mapmaker

end

local function setDifficultyForMapAndLevel()
    if MAP.type == "Cellular" then
        MAP.maxitem = {10, 24}
        MAP.maxenemy = 30 + (LEVEL * 4)
      end
      if MAP.type == "ellermaze" then
        MAP.maxitem = {5, 8}
        MAP.maxenemy = 10 + (LEVEL * 4)
      end
      if MAP.type == "Uniform" then
        MAP.maxitem = {20, 40}
        MAP.maxenemy = 40 + (LEVEL * 4)
      end
      if MAP.type == "IceyMaze" then
        MAP.maxitem = {8, 12}
        MAP.maxenemy = 20 + (LEVEL * 4)
      end

end

local function setTileImagesForMap(type)

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

local function createBossMap()
    if LEVEL == GLOBALS.bossonwhichlevel then
        
        maxX = 16
        maxY = 16
    elseif LEVEL == GLOBALS.bossonwhichlevel * 2 then
        maxX = 12
        maxY = 12
    elseif LEVEL == GLOBALS.bossonwhichlevel * 3 then
        maxX = 13
        maxY = 13
    elseif LEVEL == GLOBALS.bossonwhichlevel * 4 then
        maxX = 14
        maxY = 14
    end


    for x = 1, maxX do
        MAP[x] = {}
        for y = 1, maxY do
            MAP[x][y] = {}
            MAP[x][y].visible = true
            MAP[x][y].x = x
            MAP[x][y].y = y
            MAP[x][y].w = tileW
            MAP[x][y].h = tileH
            if x == 1 or x == maxX or y == 1 or y == maxY then
                MAP[x][y].type = 1
                mapWorld:add(MAP[x][y], MAP[x][y].x * MAP[x][y].w, MAP[x][y].y * MAP[x][y].h, MAP[x][y].w, MAP[x][y].h)
                table.insert(MAP.walltiles, MAP[x][y])
            else
                MAP[x][y].type = 0
                table.insert(MAP.emptytiles, MAP[x][y])
            end
        
        end
    end

    if LEVEL == GLOBALS.bossonwhichlevel then
        MAP.maxitem = {15, 20}
    end

    if LEVEL == GLOBALS.bossonwhichlevel * 2 then
        MAP.maxitem = {13, 38}
    end

    if LEVEL == GLOBALS.bossonwhichlevel * 3 then
        MAP.maxitem = {13, 38}
    end

    if LEVEL == GLOBALS.bossonwhichlevel * 4 then
        MAP.maxitem = {15, 50}
    end

   




end

local function createMapTransitionVariables()
    local explosion_center_x, explosion_center_y = maxX * tileW / 2, maxY * tileH / 2 -- center of the map
    local explosionforce = 10
    
    for x = 1, maxX do
        for y = 1, maxY do

            local tile_center_x, tile_center_y = (x - 0.5) * tileW, (y - 0.5) * tileH -- center of the tile
            local dx, dy = tile_center_x - explosion_center_x, tile_center_y - explosion_center_y -- vector from the center of the map to the center of the tile
            local magnitude = math.sqrt(dx * dx + dy * dy) -- distance from the center of the map to the center of the tile
            local direction = math.atan2(dy, dx) -- direction from the center of the map to the center of the tile
            local velocity_magnitude = (1 - magnitude / math.sqrt(maxX * tileW * maxY * tileH)) * explosionforce -- scale the magnitude based on the distance from the center of the map
            local velocity_x = velocity_magnitude * math.cos(direction)
            local velocity_y = velocity_magnitude * math.sin(direction)

            MAP[x][y].velocities = {x = velocity_x, y = velocity_y}
        end
    end
end


function changeLevel()
    MUSICS[3]:stop()
    MUSICS[2]:resume()
    LEVEL = LEVEL + GLOBALS.howmanylevelstoskip
    GLOBALS.numberofenemies = 0
    GLOBALS.numberofitems = 0
 

    MAP = nil
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

 

   if LEVEL % GLOBALS.bossonwhichlevel == 0 then
    MUSICS[2]:pause()
    MUSICS[3]:play()
    mapWorld = bump.newWorld(64)
    createBossMap()
    createMapTransitionVariables()
    initPlayer(player)
    spawnItems(MAP.maxitem[1],MAP.maxitem[2])
    spawnEnemies(1)
    player.fov=ROT.FOV.Precise:new(lightCalbak)
    player.camera.scale = 3
   else
        player.camera.scale = 4
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
        createMapTransitionVariables()
        setDifficultyForMapAndLevel()
        initPlayer(player)
        spawnStairs()

        spawnItems(MAP.maxitem[1],MAP.maxitem[2])
        spawnEnemies(MAP.maxenemy)

        player.fov=ROT.FOV.Precise:new(lightCalbak)
        player.progress = 0
        player.totalprogress = GLOBALS.numberofenemies + GLOBALS.numberofitems
  
    end
  


    
end

local function drawGUI()






    love.graphics.setColor(0,0,0)
    love.graphics.rectangle("fill", 0, 0, 800,70)
    love.graphics.setColor(1,1,1)

    
    local rectangle = {x = 5, y = 5, w = player.hp * (12 - player.hplevel*3), h = 40}
    local sprectangle = {x = 5, y = 47, w = player.sp * (12 - player.splevel*3), h = 25}
    local xprectangle = {x = 5, y = 73, w = player.xp * 1.5, h = 8}


    love.graphics.setColor(COLORS.blue)
    love.graphics.rectangle("fill", sprectangle.x, sprectangle.y, sprectangle.w, sprectangle.h)
    love.graphics.setColor(COLORS.white)
    love.graphics.rectangle("line", sprectangle.x-1,sprectangle.y-1, (player.maxsp * (12 - player.splevel*3)) +2,sprectangle.h+2)
    love.graphics.setFont(FONT.f16)
    love.graphics.print("SP", 6,46)

    love.graphics.setColor(COLORS.yellow)
    love.graphics.rectangle("fill", xprectangle.x, xprectangle.y, xprectangle.w, xprectangle.h)
    love.graphics.setColor(COLORS.white)
    love.graphics.rectangle("line", xprectangle.x-1,xprectangle.y-1, (player.maxxp * 1.5) +2,xprectangle.h+2)
    love.graphics.setFont(FONT.f8)
    love.graphics.print("XP", 6,72)


    
    local r = (rectangle.w * COLORS.green[1] + (200 - rectangle.w) * COLORS.red[1]) / 200
    local g = (rectangle.w * COLORS.green[2] + (200 - rectangle.w) * COLORS.red[2]) / 200
    local b = (rectangle.w * COLORS.green[3] + (200 - rectangle.w) * COLORS.red[3]) / 200


    love.graphics.setColor(r,g,b,1)
    love.graphics.rectangle("fill", rectangle.x, rectangle.y, rectangle.w, rectangle.h)
    love.graphics.setColor(COLORS.white)

    love.graphics.rectangle("line", rectangle.x-1,rectangle.y-1, (player.maxhp * (12 - player.hplevel*3)) +2,rectangle.h+2)

    love.graphics.setFont(FONT.f16)
    love.graphics.print("HP", 6,6)

    love.graphics.setFont(FONT.f16)
    love.graphics.print("AMMO", 410, rectangle.y)
    love.graphics.setFont(FONT.f24)
    love.graphics.print(player.munition, 510, rectangle.y)


    love.graphics.setFont(FONT.f16)
    love.graphics.print("FLOOR", 590, rectangle.y)
    love.graphics.setFont(FONT.f24)
    love.graphics.print("-"..LEVEL, 690, rectangle.y)

    if LEVEL % GLOBALS.bossonwhichlevel ~= 0 then

        local lineWidth = 2
        local radius = 20
        local x,y = 770, 30
        -- Redraw the progress bar
        love.graphics.setLineWidth(lineWidth)

        -- Draw the empty circle
        love.graphics.setColor(COLORS.white)
        love.graphics.circle("line", x, y, radius)

        -- Draw the filled portion of the circle
        love.graphics.setColor(COLORS.lightgreen)
        love.graphics.arc("fill", x, y, radius, -math.pi / 2, -math.pi / 2 + player.progress * 2 * math.pi)

        -- Apply a mask to the filled portion of the circle to make it circular
        love.graphics.stencil(function()
            love.graphics.circle("fill", x, y, radius)
        end, "replace", 1)
        love.graphics.setStencilTest("equal", 1)
        love.graphics.setColor(0, 0, 0, 0.1)
        love.graphics.rectangle("fill", x - radius, y - radius, radius * 2, radius * 2)
        love.graphics.setStencilTest()
            
        love.graphics.setColor(COLORS.white)
        love.graphics.setFont(FONT.f16)
        love.graphics.print("%", x-10, y-10)

    end

    
end




function love.load()
    love.graphics.setDefaultFilter("nearest", "nearest") 
    shadowCanvas = love.graphics.newCanvas()
    love.mouse.setVisible(false)
    mouseReticleImage = love.graphics.newImage("assets/reticle.png")

    COLORS = {
       green = {42/255, 88/255, 79/255},
       lightgreen = {116/255,163/255,63/255},
        red = {198/255, 80/255, 90/255},
        sniperred = {198/255, 80/255, 90/255, 0.3},
        white = {252/255, 1, 192/255},
        blue = {110/255, 184/255, 168/255},
        yellow = {238/255,156/255,93/255}
    }
    FONT = {
        f8 = love.graphics.newFont('assets/font.otf', 8), 
        f16 = love.graphics.newFont('assets/font.otf', 16),
        f24 =  love.graphics.newFont('assets/font.otf', 24),
    }
    mapWorld = bump.newWorld(64)  
    GUIWorld = bump.newWorld(64)
    LEVEL = 1
    MAP = {}
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
        godeeper = love.graphics.newImage("assets/godeeper.png"),
        gameover = love.graphics.newImage("assets/gameover.png")
    }
    CARDS = {}
    table.insert(CARDS, MaxHpUp(0,0))
    table.insert(CARDS, MaxSpUp(0,0))
    table.insert(CARDS, MaxSpeedUp(0,0))
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
    mapmaker:create(mapcreator) 
    createMapTransitionVariables()


    initPlayer()
    spawnStairs()
    spawnItems(MAP.maxitem[1],MAP.maxitem[2])
    spawnEnemies(MAP.maxenemy)
    INVENTORY = {}
    BULLETS = {}


    INVENTORY[1] = Pistol()
    MUSICS = {
        SOUNDS.menu, SOUNDS.game, SOUNDS.boss
    } 
    MUSICS[1]:play()
    player.progress = 0
    player.totalprogress = GLOBALS.numberofenemies + GLOBALS.numberofitems
    print(player.totalprogress)
end

function love.update(dt)

    if SCREENSHAKE.t < SCREENSHAKE.shakeDuration then
        SCREENSHAKE.t = SCREENSHAKE.t + dt
    end

    if gameState.state == gameState.states.levelup then
        MOUSEX, MOUSEY = love.mouse.getPosition()
    end

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

    if gameState.state == gameState.states.trans then
        for x = 1, maxX do
            for y = 1, maxY do
                local cell = MAP[x][y]
                cell.x = cell.x + cell.velocities.x * dt
                cell.y = cell.y + cell.velocities.y * dt
            end
        end

        Timer.after(0.2, function ()
            local gravity = 10 -- pixels per second squared
            for x = 1, maxX do
                for y = 1, maxY do
                    local tile = MAP[x][y]
                    tile.velocities.y = tile.velocities.y + gravity * dt
                end
            end
        end)

    end

    Timer.update(dt)

    if INVENTORY[1]:instanceOf(MachineGun) and love.mouse.isDown(1) and not player.mgbulletshot then
        player.mgbulletshot = true
        player:action(MOUSEX,MOUSEY)
        Timer.after(0.1, function ()
            player.mgbulletshot = false
        end)
    end


    if not player.countback and gameState.state == gameState.states.countback then
        player.countback = true
        Timer.every(1, function ()
            local instance = SOUNDS.blip:play()
            GLOBALS.howlongbeforestart = GLOBALS.howlongbeforestart - 1 
        end, 3)
        Timer.after(3, function ()
            GLOBALS.howlongbeforestart = 3
            player.countback = false
            gameState:changeState(gameState.states.game)
        end)
    end
   -- print(ENEMIES[1].x)

end

function love.draw() 
    if SCREENSHAKE.t < SCREENSHAKE.shakeDuration then
        local dx = love.math.random(-SCREENSHAKE.shakeMagnitude, SCREENSHAKE.shakeMagnitude)
        local dy = love.math.random(-SCREENSHAKE.shakeMagnitude, SCREENSHAKE.shakeMagnitude)
        love.graphics.translate(math.floor(dx), math.ceil(dy))
    end
 

    if gameState.state == gameState.states.starting then
        love.graphics.draw(IMAGES.titlescreen, 0,0)
    end

    if gameState.state == gameState.states.game or gameState.state == gameState.states.pause or gameState.state == gameState.states.countback or gameState.state == gameState.states.levelup then
        
 
    

        player.camera:attach()
     
  
        love.graphics.setCanvas(shadowCanvas)
        local px, py = player.camera:worldCoords(player.x, player.y)
        love.graphics.clear()
        love.graphics.setColor(1, 1, 1, 0.1)
        love.graphics.circle("fill", px, py, 900 / player.camera.scale)
        love.graphics.setCanvas()
       
        for x = 1, maxX do
            for y = 1, maxY do
                if MAP[x][y] ~= nil then
                    local cell = MAP[x][y] 
                    local distance =  math.sqrt((player.x - (cell.x * tileW + 8)) ^ 2 + (player.y - (cell.y * tileH + 8)) ^ 2) 
                  
                    local alpha = math.max(0, math.min(1, 1 - distance / 100))

        
                    if cell.type == 1 and cell.visible then          
                        love.graphics.setColor(1,1,1, alpha)
                        love.graphics.draw(TILES.wall.img, cell.x * tileW, cell.y * tileH)
                    end
                    if cell.type == 0 and cell.visible then
                        love.graphics.setColor(1,1,1, alpha)
                        love.graphics.draw(TILES.floor.img, cell.x * tileW, cell.y* tileH)
                    end
                end
            end
        end


   
        love.graphics.setColor(1,1,1,1)
        
        for i = 1, #ITEMS do
     
            ITEMS[i]:draw()
        end
           
        for i = 1, #BULLETS do
            BULLETS[i]:draw()
        end

        for i = 1, #ENEMIES do
            local distance =  math.sqrt((player.x - ENEMIES[i].x) ^ 2 + (player.y - ENEMIES[i].y) ^ 2)
           
             local alpha = math.max(0, math.min(1, 1.7 - distance / 100))
          
            love.graphics.setColor(1,1,1,alpha)
            ENEMIES[i]:draw()
        end


        
        love.graphics.draw(shadowCanvas, 0, 0)
        love.graphics.setColor(1,1,1,1)
        if INVENTORY ~= nil then
            INVENTORY[1]:draw()
        end
        
        player:draw()

        if gameState.state ~= gameState.states.levelup then
            love.graphics.draw(mouseReticleImage, MOUSEX, MOUSEY)
        end
        player.camera:detach()



  
        if player.standingonStairs then
           
            love.graphics.draw(IMAGES.godeeper, player.x + 80, player.y - 20)
        end

        drawGUI()

        for i = 1, #ITEMS do
            if ITEMS[i].name == "Ammo" then
                if ITEMS[i].drawValueOnMap then
                    local x,y = player.camera:cameraCoords(ITEMS[i].x, ITEMS[i].y)
                    love.graphics.setFont(FONT.f16)
                    love.graphics.print("+"..ITEMS[i].ammoup.."Ammo", x - 32,y)
                end
                   

            end

            if ITEMS[i].name == "Medpack" then
                if ITEMS[i].drawValueOnMap then
                    local x,y = player.camera:cameraCoords(ITEMS[i].x, ITEMS[i].y)
                    love.graphics.setFont(FONT.f16)
                    love.graphics.print("+"..ITEMS[i].hpup.."HP", x - 32,y)
                end
                   
            end
            if ITEMS[i].name == "MG" then
                if ITEMS[i].drawValueOnMap then
                    local x,y = player.camera:cameraCoords(ITEMS[i].x, ITEMS[i].y)
                    love.graphics.setFont(FONT.f16)
                    love.graphics.print("MACHINE GUN", x - 32,y)
                end
                   
            end
            if ITEMS[i].name == "Drill" then
                if ITEMS[i].drawValueOnMap then
                    local x,y = player.camera:cameraCoords(ITEMS[i].x, ITEMS[i].y)
                    love.graphics.setFont(FONT.f16)
                    love.graphics.print("DRILL", x - 32,y)
                end
                   
            end
            if ITEMS[i].name == "Shield" then
                if ITEMS[i].drawValueOnMap then
                    local x,y = player.camera:cameraCoords(ITEMS[i].x, ITEMS[i].y)
                    love.graphics.setFont(FONT.f16)
                    love.graphics.print("10s SHIELD", x - 32,y)
                end
                   
            end
            if ITEMS[i].name == "SpeedUp" then
                if ITEMS[i].drawValueOnMap then
                    local x,y = player.camera:cameraCoords(ITEMS[i].x, ITEMS[i].y)
                    love.graphics.setFont(FONT.f16)
                    love.graphics.print("10s SPEED", x - 32,y)
                end
                   
            end
            if ITEMS[i].name == "SG" then
                if ITEMS[i].drawValueOnMap then
                    local x,y = player.camera:cameraCoords(ITEMS[i].x, ITEMS[i].y)
                    love.graphics.setFont(FONT.f16)
                    love.graphics.print("SHOTGUN", x - 32,y)
                end
                   
            end
        end

        if gameState.state == gameState.states.pause then
            love.graphics.setColor(COLORS.red)
            love.graphics.rectangle("fill", 0, love.graphics.getHeight() / 2 - 125, 800,100 )
            love.graphics.setColor(COLORS.white)
            love.graphics.setFont(FONT.f24)

            love.graphics.print("PAUSED", love.graphics.getWidth() / 2 - 80, love.graphics.getHeight() / 2 - 123)
            love.graphics.print("press ESC or P to go back", love.graphics.getWidth() / 2 - 300, love.graphics.getHeight() / 2 - 83)
            love.graphics.setColor(0, 0, 0, 0.5)
            love.graphics.rectangle('fill', 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
        end


        if gameState.state == gameState.states.countback then
            love.graphics.setColor(COLORS.red)
            love.graphics.rectangle("fill", 0, love.graphics.getHeight() / 2 - 125, 800,100 )
            love.graphics.setColor(COLORS.white)
            love.graphics.setFont(FONT.f24)
            love.graphics.print("TIME TO START:  ", love.graphics.getWidth() / 2 - 150, love.graphics.getHeight() / 2 - 123)
            love.graphics.print(GLOBALS.howlongbeforestart, love.graphics.getWidth() / 2 - 10, love.graphics.getHeight() / 2 - 83)
        end

        if gameState.state == gameState.states.levelup then
            love.graphics.setColor(COLORS.red)
            love.graphics.rectangle("fill", 0, love.graphics.getHeight() / 2 - 125, 800,100 )
            love.graphics.setColor(COLORS.white)
            love.graphics.setFont(FONT.f24)
            love.graphics.print("LEVEL UP ", love.graphics.getWidth() / 2 - 130, love.graphics.getHeight() / 2 - 123)
            love.graphics.print("CHOOSE ONE: ", love.graphics.getWidth() / 2 - 160, love.graphics.getHeight() / 2 - 93)
            for i = 1, #player.cards do
                love.graphics.draw(player.cards[i].image, player.cards[i].x, player.cards[i].y)
            end
        end

        if gameState.state == gameState.states.levelup then
            love.graphics.draw(mouseReticleImage, MOUSEX, MOUSEY, nil, player.camera.scale, player.camera.scale)
        end

    end

    if gameState.state == gameState.states.map then
      
        for x = 1, maxX do
            for y = 1, maxY do
                if MAP[x][y] ~= nil then
                    local cell = MAP[x][y] 

                    if cell.type == 1 and cell.visible then          
                    
                        love.graphics.draw(TILES.wall.img, cell.x * tileW, cell.y * tileH)
                    end
                    if cell.type == 0 and cell.visible then
                        love.graphics.draw(TILES.floor.img, cell.x * tileW, cell.y * tileH)
                    end
                    for i = 1, #ITEMS do
                        --   print(ITEMS[i].x)
                        ITEMS[i]:draw()
                    end
                    love.graphics.setColor(COLORS.red)
                    love.graphics.circle("line", player.x + 4, player.y + 4, 16)
                    player:draw()
                end
            end
        end
    end

    if gameState.state == gameState.states.gameover then
        love.graphics.draw(IMAGES.gameover, 0,0)
    end

    if gameState.state == gameState.states.trans then
        player.camera:attach()
        for x = 1, maxX do
            for y = 1, maxY do
                if MAP[x][y] ~= nil then
                    local cell = MAP[x][y] 

                    if cell.type == 1 and cell.visible then          
             
                        love.graphics.draw(TILES.wall.img, cell.x * tileW, cell.y * tileH)
                    end
                    if cell.type == 0 and cell.visible then
                        love.graphics.draw(TILES.floor.img, cell.x * tileW, cell.y * tileH)
                    end
                    player:draw()
                end
            end
        end
        player.camera:detach()
    end




   

end


function love.mousepressed(x, y, button, istouch)

    if gameState.state == gameState.states.starting then
        MUSICS[1]:stop()
        MUSICS[2]:play()
        gameState:changeState(gameState.states.countback)
    end


    if gameState.state == gameState.states.game and INVENTORY[1]:instanceOf(MachineGun) ~= true then
        if button == 1 then
            player:action(MOUSEX,MOUSEY)
        end
      
    end
    if gameState.state == gameState.states.game and button == 2 then
        local instance = SOUNDS.special:play()
        player:special()
    end

    if gameState.state == gameState.states.levelup and button == 1 then
        local items, len = GUIWorld:queryPoint(MOUSEX,MOUSEY)
        if len == 1 then
            local instance = SOUNDS.blip:play()
            for i = 1, len do
                items[i].action()
            end
        end
    end

 end




 function love.keypressed(key)
 

    if gameState.state == gameState.states.map and player.onMap == true then
        if key == "tab" then
            MUSICS[1]:stop()
            MUSICS[2]:resume()
            Timer.after(0.5, function ()
                 player.onMap = false
            end)

            player.camera.scale = player.originalcamscale

            gameState:changeState(gameState.states.game)
        end
    
    end
    
    if gameState.state == gameState.states.game and player.onMap ~= true then
            if key == "tab" then
                MUSICS[2]:pause()
                MUSICS[1]:play()
           player.originalcamscale = player.camera.scale
                player.camera.scale = 1
            gameState:changeState(gameState.states.map)
            
            player.onMap = true

            end
            
    end
    if gameState.state == gameState.states.pause and player.onPause == true then
        if key == "p"  or key == "escape" then
            MUSICS[1]:stop()
            MUSICS[2]:resume()
            Timer.after(0.5, function ()
                 player.onPause = false
            end)

          

            gameState:changeState(gameState.states.game)
        end
    
    end
    
    if gameState.state == gameState.states.game and player.onPause ~= true then
            if key == "p" or key == "escape" then
                MUSICS[2]:pause()
                MUSICS[1]:play()
            gameState:changeState(gameState.states.pause)
            
            player.onPause = true

            end

    end




 end