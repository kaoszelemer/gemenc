local BossSpider = Character:extend('BossSpider')



function BossSpider:init(x, y)

    Character.init(
    self,
    x,
    y,
    64,
    64,
    {
        name = "bossspider",
        x = x,
        y = y,
        w = 64,
        h = 64
    },
    "bossspider",
    love.graphics.newImage("assets/spiderboss.png"),
    30,
    30,
    50, --speed
    1,
    "enemy" ,-- type
    0.5, --rof
    100 --hp
)



    mapWorld:add(self, self.x, self.y, self.colliders.w, self.colliders.h)
    self.visible = false
    self.hitinvi = false
    self.tx = math.floor(self.x / tileW)
    self.ty = math.floor(self.y / tileH)
    self.ox = self.x
    self.direction = 1
    self.walkdistance = 200
    self.angle = 0
    self.munition = 8
    self.maxhp = self.hp
    self.xp = 20

    self.particleImage = love.graphics.newImage("assets/exploparticle.png")
    self.particleSystem = love.graphics.newParticleSystem(self.particleImage, 32)
    self.particleSystem:setParticleLifetime(0.8, 1.8)
    self.particleSystem:setEmissionRate(64)
    self.particleSystem:setLinearAcceleration(-15, -15, 15, 15)
    self.particleSystem:setColors(255, 255, 255, 255, 255, 255, 255, 0)
    self.particleSystem:setSizes(2, 0)
    self.particleSystem:start()

    self.explocoordinates = {
        {x = love.math.random(10,40), y = love.math.random(0,40)},
        {x = love.math.random(0,20), y = love.math.random(0,20)},
        {x = love.math.random(-43, -54), y = love.math.random(-11, -17)},
        {x = love.math.random(-8, -17), y = love.math.random(-4, -30)},
        {x = love.math.random(0,60), y = love.math.random(40,80)},
        {x = love.math.random(0,52), y = love.math.random(0,64)},
        {x = love.math.random(0, 64), y = love.math.random(-40, -64)},
        {x = love.math.random(-40, -64), y = love.math.random(-16, -28)},
        {x = love.math.random(5,7), y = love.math.random(3,62)},
        {x = love.math.random(23,29), y = love.math.random(28,32)},
        {x = love.math.random(-64, -0), y = love.math.random(-64, -0)},
        {x = love.math.random(-48, 12), y = love.math.random(-48, -16)},
        {x = love.math.random(22,43), y = love.math.random(24,78)},
        {x = love.math.random(32,64), y = love.math.random(-32,32)},
        {x = love.math.random(-23, -28), y = love.math.random(-4, -8)},
        {x = love.math.random(-4, 60), y = love.math.random(45, 60)}
  
       }
  
       shuffleTable(self.explocoordinates)
       shuffleTableXY(self.explocoordinates)

       self.displayName = "L0VD3R"

end



local function enemyFilter(item, other)
 
    if other.type == 1 or other.type == 2 then
        return "bounce"
    else
        return nil   
    end
end



function BossSpider:update(dt)
    local distance = math.sqrt((player.x - self.x)^2 + (player.y - self.y)^2)

    self.tx = math.floor(self.x / tileW)
    self.ty = math.floor(self.y / tileH)

    if (self.tx > 0 and self.tx <= maxX) and (self.ty > 0 and self.ty <= maxY) then
        if MAP[self.tx][self.ty].visible and not self.isDead then
            self.visible = true
        else
            self.visible = false
        end
    end



    if self.hitinvi and not self.showhitinvi then
        self.showhitinvi = true
        Timer.every(0.01, function() 
            self.visible = true
        end, 14)
        Timer.every(0.02, function ()
            self.visible = false
        end, 8)
    end 

    if distance < 150 and not self.isDead then
        self.canMove = true
    else
        self.canMove = false
    end
 

    if self.isDead then
        self.particleSystem:update(dt)
    end
    if self.x < tileW +2 then
        self.direction = -self.direction
        self.x = tileW+2
      end
      if self.y < tileH+2 then
        self.direction = -self.direction
        self.y = tileH+2
      end
      if self.x > ((maxX) * tileW) +4 then
        self.direction = -self.direction
        self.x = ((maxX) * tileW)+4
      end
      if self.y > ((maxY) * tileH)+4 then
        self.direction = -self.direction
        self.y = ((maxY) * tileH)+4
      end 
end

function BossSpider:move(dt)


    if not self.isDead and self.canMove then

    

        local dx = player.x - self.x
        local dy = player.y - self.y

        local angle = math.atan2(dy, dx)

        local fx = self.x + (self.velx * dt) * math.cos(angle)
        local fy = self.y + (self.vely * dt) * math.sin(angle)
        
            
        local ax, ay, cols, len = mapWorld:move(self, fx , fy, enemyFilter)
        
        self.x = ax
        self.y = ay

      --[[   if len == 0 then
            self.speed = 20
        end ]]
        --  mapWorld:update(self, self.cx, self.cy)
        for i = 1, #cols do

          
                if cols[i].other.name == player.name and not player.hitinvi and not player.shielded then
                    cols[i].other.hp = cols[i].other.hp - 1
                    --    screenShake(0.1, 3)
                        
                        if cols[i].other.hp <= 0 then
                      
                                cols[i].other:kill("pl")
                                
                        else
                    
                            cols[i].other.hitinvi = true
                            cols[i].other.particleSystem:start()
                            Timer.after(0.4, function() 
                                cols[i].other.particleSystem:stop()
                                cols[i].other.hitinvi = false
                                cols[i].other.showhitinvi = false
                            end)
                        end
                end
        end
            
        
 


    end
end

function BossSpider:action(x,y)


            table.insert(ENEMIES, AlienSpider(self.x+8,self.y+8))
        --    GLOBALS.numberofenemies = GLOBALS.numberofenemies + 1
   

 
      
        

end


return BossSpider