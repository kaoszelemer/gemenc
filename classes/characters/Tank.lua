local Tank = Character:extend('Tank')



function Tank:init(x, y)

    Character.init(
    self,
    x,
    y,
    8,
    8,
    {
        name = "abi",
        x = x,
        y = y,
        w = 8,
        h = 8
    },
    "Tank",
    love.graphics.newImage("assets/tank.png"),
    0,
    0,
    3,
    1,
    "enemy" ,-- type
    3, --rof
    3 --hp
)



    mapWorld:add(self, self.x, self.y, self.colliders.w, self.colliders.h)
    self.visible = false
    self.hitinvi = false
    self.tx = math.floor(self.x / tileW)
    self.ty = math.floor(self.y / tileH)
    self.ox = self.x
    self.direction = 1
    self.walkdistance = love.math.random(1,15)
    self.angle = 0
    self.xp = 1

    self.particleImage = love.graphics.newImage("assets/exploparticle.png")
    self.particleSystem = love.graphics.newParticleSystem(self.particleImage, 32)
    self.particleSystem:setParticleLifetime(0.8, 1.8)
    self.particleSystem:setEmissionRate(64)
    self.particleSystem:setLinearAcceleration(-15, -15, 15, 15)
    self.particleSystem:setColors(255, 255, 255, 255, 255, 255, 255, 0)
    self.particleSystem:setSizes(2, 0)
    self.particleSystem:start()

    self.explocoordinates = {
        {x = love.math.random(4,8), y = love.math.random(0,8)},
        {x = love.math.random(0,12), y = love.math.random(0,12)},
        {x = love.math.random(4, 8), y = love.math.random(4, 8)},
        {x = love.math.random(4, 4), y = love.math.random(4, 4)}
  
       }
  
       shuffleTable(self.explocoordinates)
       shuffleTableXY(self.explocoordinates)
end



local function enemyFilter(item, other)
 
    if other.type == 1 or other.type == 2 then
        return "bounce"
    else
        return nil   
    end
end



function Tank:update(dt)
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
        Timer.every(0.03, function() 
            self.visible = true
        end, 14)
        Timer.every(0.05, function ()
            self.visible = false
        end, 8)
    end 


    if distance < 60 and not self.isDead then
        self:action(x, y)
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

function Tank:move(dt)



  if not self.isDead then


        if (self.direction == 1 and self.x >= (self.ox + self.walkdistance)) or (self.direction == -1 and self.x <= (self.ox - self.walkdistance)) then
            self.direction = -self.direction
        end
        
        self.x = self.x + (self.speed * self.direction * dt)

            
        local ax, ay, cols, len = mapWorld:move(self, self.x , self.y, enemyFilter)
        
        self.x = ax
        self.y = ay

        for i = 1, #cols do

            
        
            if len >= 1 and cols[i].other.type ~= "TankBullet" and cols[i].other.type ~= "enemy" and cols[i].other.type ~= "enemy" then
            
                self.direction = -self.direction
            end
            

        end


    end
end

function Tank:action(x,y)

   
        if self.EnemyBulletshot ~= true then
        
            table.insert(BULLETS, TankBullet(self.x + self.colliders.w / 2,self.y + self.colliders.h / 2, player.x, player.y, self, 1))
            self.EnemyBulletshot = true
        end
        
      
        

end


return Tank