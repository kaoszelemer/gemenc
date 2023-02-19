local BossRobot = Character:extend('BossRobot')



function BossRobot:init(x, y)

    Character.init(
    self,
    x,
    y,
    64,
    64,
    {
        name = "bossrobot",
        x = x,
        y = y,
        w = 64,
        h = 64
    },
    "bossrobot",
    love.graphics.newImage("assets/bossrobot.png"),
    0,
    0,
    50, --speed
    1,
    "enemy" ,-- type
    0.4, --rof
    70 --hp
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
    self.simplemun = 5
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
end



local function enemyFilter(item, other)
 
    if other.type == 1 or other.type == 2 then
        return "bounce"
    else
        return nil   
    end
end



function BossRobot:update(dt)
    local distance = math.sqrt((player.x - (self.x + self.colliders.w / 2))^2 + (player.y - (self.y + self.colliders.h /2))^2)
    --print(distance)
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


    if distance < 150 and not self.isDead then
        for i = 1, 8 do
   
            self:action(x, y)
        end
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

function BossRobot:move(dt)


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

function BossRobot:action(x,y)


      
        if self.EnemyBulletshot ~= true and self.munition > 0 then
            for i = 1, 8 do
                self.munition = self.munition - 1
                table.insert(BULLETS, TankBullet(self.x + self.colliders.w / 2,self.y + self.colliders.h / 2, player.x, player.y, self, i))
            end
            self.EnemyBulletshot = true
       

        end

        if self.SimpleEnemyBulletshot ~= true and self.hp < self.maxhp / 2 then
            Timer.every(0.3, function ()
                self.simplemun = self.simplemun - 1
                table.insert(BULLETS, EnemyBullet(self.x + self.colliders.w / 2,self.y + self.colliders.h / 2, player.x, player.y, self, i))
            end, 5)
            self.SimpleEnemyBulletshot = true
        end
        
      
        

end


return BossRobot