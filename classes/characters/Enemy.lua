local Enemy = Character:extend('Enemy')



function Enemy:init(x, y)

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
    "soldier",
    love.graphics.newImage("assets/enemy.png"),
    0,
    0,
    20,
    1,
    "enemy" -- type

)

  mapWorld:add(self, self.x, self.y, self.colliders.w, self.colliders.h)
  self.visible = false
    self.tx = math.floor(self.x / 16)
    self.ty = math.floor(self.y / 16)
    self.ox = self.x
    self.direction = 1
    self.walkdistance = love.math.random(1,15)
    self.angle = 0


    self.particleImage = love.graphics.newImage("assets/blood.png")
    self.particleSystem = love.graphics.newParticleSystem(self.particleImage, 32)
    self.particleSystem:setParticleLifetime(1, 1)
    self.particleSystem:setEmissionRate(32)
    self.particleSystem:setSizeVariation(1)
    self.particleSystem:setLinearAcceleration(-20, -20, 20, 20)
    self.particleSystem:setColors(145, 0, 0, 255, 145, 0, 0, 0)
    self.particleSystem:start()

end



local function enemyFilter(item, other)
 
    if other.type == 1 or other.type == 2 then
        return "bounce"
    else
        return nil   
    end
end



function Enemy:update(dt)
    local distance = math.sqrt((player.x - self.x)^2 + (player.y - self.y)^2)

    if distance < 60 and not self.isDead then
        self.visible = true
  --[[   elseif distance < 50 and not self.isDead  then
        self.visible = true
 ]]
    else
        self.visible = false
    end

    if distance < 35 and not self.isDead then
        self:action(x, y)
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

function Enemy:move(dt)



  if not self.isDead then


        if (self.direction == 1 and self.x >= (self.ox + self.walkdistance)) or (self.direction == -1 and self.x <= (self.ox - self.walkdistance)) then
            self.direction = -self.direction
        end
        
        self.x = self.x + (self.speed * self.direction * dt)

            
        local ax, ay, cols, len = mapWorld:move(self, self.x , self.y, enemyFilter)
        
        self.x = ax
        self.y = ay

      --[[   if len == 0 then
            self.speed = 20
        end ]]
        --  mapWorld:update(self, self.cx, self.cy)
        for i = 1, #cols do

            
        
            if len >= 1 and cols[i].other.type ~= "EnemyBullet" and cols[i].other.type ~= "enemy" and cols[i].other.type ~= "enemy" then
            
                self.direction = -self.direction
            end
            

        end


    end
end

function Enemy:action(x,y)

   
        if self.EnemyBulletshot ~= true then
        
            table.insert(BULLETS, EnemyBullet(self.x,self.y, player.x, player.y, self))
            self.EnemyBulletshot = true
        end
        
      
        

end


return Enemy