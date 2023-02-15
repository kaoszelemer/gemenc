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
    3,
    1,
    "enemy" ,-- type
    0.05, --rof
    30 --hp
)



    mapWorld:add(self, self.x, self.y, self.colliders.w, self.colliders.h)
    self.visible = false
    self.hitinvi = false
    self.tx = math.floor(self.x / 16)
    self.ty = math.floor(self.y / 16)
    self.ox = self.x
    self.direction = 1
    self.walkdistance = 20
    self.angle = 0
    self.munition = 8


    self.particleImage = love.graphics.newImage("assets/exploparticle.png")
    self.particleSystem = love.graphics.newParticleSystem(self.particleImage, 32)
    self.particleSystem:setParticleLifetime(0.8, 1.8)
    self.particleSystem:setEmissionRate(64)
    self.particleSystem:setLinearAcceleration(-15, -15, 15, 15)
    self.particleSystem:setColors(255, 255, 255, 255, 255, 255, 255, 0)
    self.particleSystem:setSizes(2, 0)
    self.particleSystem:start()
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
    self.tx = math.floor(self.x / 16)
    self.ty = math.floor(self.y / 16)

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


    if distance < 125 and not self.isDead then
        for i = 1, 8 do
   
            self:action(x, y)
        end
    end

    if self.isDead then
        self.particleSystem:update(dt)
    end

    if self.x < 18 then
        self.direction = -self.direction
        self.x = 18
    end
    if self.y < 18 then
        self.direction = -self.direction
        self.y = 18
    end
    if self.x > ((maxX) * 16) +4 then
        self.direction = -self.direction
        self.x = ((maxX) * 16)+4
    end
    if self.y > ((maxY) * 16)+4 then
        self.direction = -self.direction
        self.y = ((maxY) * 16)+4
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
        
      
        

end


return BossRobot