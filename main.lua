ROT=require('rotLove.src.rot')
lurker = require('lib.lurker')
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

FieldItem = require('classes.items.FieldItem')
Medpack = require('classes.items.Medpack')
Ammo = require('classes.items.Ammo')

Stairs = require('classes.items.Stairs')

Bullet = require('classes.Bullet')
EnemyBullet = require('classes.EnemyBullet')


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
        
        print(i)
        MAP[x][y].k = i
        table.insert(MAP.emptytiles, MAP[x][y])
    end

    
  

    
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

local function initPlayer()
    local playerx = (MAP.emptytiles[1].x * 16) + 4
    local playery = (MAP.emptytiles[1].y * 16) + 4
  
    player = Player(playerx, playery)
    
    player.camera = Camera(player.x, player.y, 6)
    player.fov=ROT.FOV.Precise:new(lightCalbak)
    player.fov:compute(math.floor((player.x - 4) / 16), math.floor((player.y -4) / 16), 2, computeCalbak)

    player.munition = 5
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
            if MAP[x][y].occupied ~= true and MAP[x][y].type == 0 and not MAP.stairsinserted then
                MAP[x][y].occupied = true
                table.insert(ITEMS, Stairs(x * 16, y * 16))
                MAP.stairsinserted = true
            end
        end
    end

end


function changeLevel()

   ENEMIES = {}
   ITEMS = {}
 
   print("changing level")
   local case = love.math.random(1,4)
   local mapmaker
      if case == 1 then
   mapmaker = ROT.Map.EllerMaze:new(maxX, maxY)
   print("ellermaze")
   elseif case == 2 then
    mapmaker = ROT.Map.Cellular:new(maxX, maxY)
   -- mapmaker = ROT.Map.Uniform:new(maxX, maxY)
    print("dungeon")
   elseif case == 3 then
    mapmaker = ROT.Map.Cellular:new(maxX, maxY)
    print("cellular")
   elseif case == 4 then
    print("IceyMaze")
    mapmaker = ROT.Map.IceyMaze:new(maxX, maxY)
   end

   for x = 1, maxX do
    MAP[x] = {}
    for y = 1, maxY do
        MAP[x][y] = 0
    end
  end
  
  mapWorld = bump.newWorld(64)
    mapmaker:create(mapcreator) 
    initPlayer()
    player.fov=ROT.FOV.Precise:new(lightCalbak)
    print("cssc")
    spawnStairs()
    spawnItems(5,12)
    spawnEnemies(10)

    
end




function love.load()
  love.graphics.setDefaultFilter("nearest", "nearest") 
  love.mouse.setVisible(false)
  mouseReticleImage = love.graphics.newImage("assets/reticle.png")

  local case = love.math.random(1,4)
    local mapmaker
    
    
    
    mapWorld = bump.newWorld(64)
    
    MAP = {}
    MAP.emptytiles = {}
    MAP.walltiles = {}
    MAP.itemtiles = {}
    ITEMS = {}
    ENEMIES = {}
    TILES = {
        floor = {img = love.graphics.newImage("assets/floortile.png")},
        wall = {img = love.graphics.newImage("assets/walltile.png")},
    }
    
    
    
    for x = 1, maxX do
        MAP[x] = {}
        for y = 1, maxY do
            MAP[x][y] = 0
        end
    end
    if case == 1 then
      mapmaker = ROT.Map.EllerMaze:new(maxX, maxY)
      print("ellermaze")
      --[[ elseif case == 2 then
       mapmaker = ROT.Map.Cellular:new(maxX, maxY)
      -- mapmaker = ROT.Map.Uniform:new(maxX, maxY)
       print("dungeon") ]]
      elseif case == 3 then
       mapmaker = ROT.Map.Cellular:new(maxX, maxY)
       MAP.type = "Cellular"
       print("cellular")
      elseif case == 2 then
       mapmaker = ROT.Map.Cellular:new(maxX, maxY)
       MAP.type = "Cellular"
       print("cellular")
      elseif case == 4 then
       print("IceyMaze")
       mapmaker = ROT.Map.IceyMaze:new(maxX, maxY)
      end
    if MAP.type == "Cellular" then
        mapmaker:randomize(0.5)

    end

    mapmaker:create(mapcreator) 

    if MAP.type == "Cellular" then

        for i = 0, maxX - 1 do
            local a = MAP[1 + i][1]
            local b = MAP[1][1 + i]
            local c = MAP[maxX - i][1]
            local d = MAP[1][maxY - i]
           
            for f = 1, #MAP.emptytiles do
                
                local g = MAP.emptytiles[f]
                if g ~= nil then
                    if (g.x == a.x and g.y == a.y) or (g.x == b.x and g.y == b.y) or (g.x == c.x and g.y == c.y) or (g.x == d.x and g.y == d.y) then
                        print(a.x)
                        table.remove(MAP.emptytiles, f)
                    end
                end
    
            end

            if a.type ~= 1 then
           
                a.type = 1
                table.insert(MAP.walltiles, a)
                mapWorld:add(a, a.x,a.y,a.w,a.h)
            end
            if b.type ~= 1 then
                b.type = 1
                table.insert(MAP.walltiles,  b)
                mapWorld:add(b, b.x,b.y,b.w,b.h)
            end
            if c.type ~= 1 then
                c.type = 1
                table.insert(MAP.walltiles, c)
                mapWorld:add(c, c.x,c.y,c.w,c.h)
             end
            if d.type ~= 1 then
                d.type = 1
                table.insert(MAP.walltiles, d)
                mapWorld:add(d, d.x,d.y,d.w,d.h)
            end

         
        end


        

    end

    initPlayer()

  spawnStairs()
    spawnItems(5,12)
    spawnEnemies(10)



  INVENTORY = {}

  BULLETS = {}

  --debug purposes
  INVENTORY[1] = Pistol()


    
end

function love.update(dt)
    MOUSEX, MOUSEY = player.camera:worldCoords(love.mouse.getPosition())
    lurker.update()
    player:move(dt)
    player:update(dt)
    player:physics(dt)
    Timer.update(dt)

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

   -- print(ENEMIES[1].x)
   
end

function love.draw() 
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
        
        for i = 1, #ENEMIES do
            ENEMIES[i]:draw()
        end
        
        player:draw()
        love.graphics.draw(mouseReticleImage, MOUSEX, MOUSEY)

   player.camera:detach()

   love.graphics.print("AMMO: "..player.munition, 0,0)
   love.graphics.print("HP: "..player.hp, 0,16)
   if player.standingonStairs then
    love.graphics.print("press space to change level", player.x, player.y)
  end
end


function love.mousepressed(x, y, button, istouch)
    if button == 1 then 
        player:action(MOUSEX,MOUSEY)
    end
 end