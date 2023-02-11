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



    self.particleImage = love.graphics.newImage("assets/blood.png")
    self.particleSystem = love.graphics.newParticleSystem(self.particleImage, 32)
    self.particleSystem:setParticleLifetime(1, 1)
    self.particleSystem:setEmissionRate(32)
    self.particleSystem:setSizeVariation(1)
    self.particleSystem:setLinearAcceleration(-20, -20, 20, 20)
    self.particleSystem:setColors(255, 0, 0, 255, 255, 0, 0, 0)
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

    if distance < 50 and not self.isDead then
        self.visible = true
    else
        self.visible = false
    end

    if distance < 35 and not self.isDead then
        self:action(x, y)
    end

    if self.isDead then
        self.particleSystem:update(dt)
    end
end

function Enemy:move(dt)



  if not self.isDead then


        if (self.direction == 1 and self.x >= (self.ox + self.walkdistance)) or (self.direction == -1 and self.x <= (self.ox - self.walkdistance)) then
            self.direction = -self.direction
        end
        
        self.x = self.x + (self.speed * self.direction * dt)

            
        local ax, ay, cols, len = mapWorld:move(self, self.x , self.y)
        
        self.x = ax
        self.y = ay

        if len == 0 then
            self.speed = 20
        end
        --  mapWorld:update(self, self.cx, self.cy)
        for i = 1, #cols do

            
        
            if len >= 1 and cols[i].other.type ~= "EnemyBullet" then
            
                self.direction = -self.direction
            end
            

          --[[   if len >=1 and cols[i].other.type == 2 then
                self.speed = 0
            end ]]

        end


    end
end

function Enemy:action(x,y)

   
        if self.EnemyBulletshot ~= true then
            local parent = self
            table.insert(BULLETS, EnemyBullet(self.x,self.y, player.x, player.y, parent))
            self.EnemyBulletshot = true
        end
   
        

end


return Enemy