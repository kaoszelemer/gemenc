local Player = Character:extend('Player')

function Player:init(x, y)

    Character.init(
    self,
    x,
    y,
    8,
    8,
    {
        name = "gemenc",
        x = x,
        y = y,
        w = 8,
        h = 8
    },
    "gemenc",
    love.graphics.newImage("assets/player.png"),
    0,
    0,
    500,
    10,
    2, -- type
    0 -- rof aint used
)
self.tx = math.floor(self.x / 16)
self.ty = math.floor(self.y / 16)

  mapWorld:add(self, self.x, self.y, self.colliders.w, self.colliders.h)
  self.visible = true

  self.hp = 10

  self.angle = 0

  self.trail = {}
  self.maxTrailLength = 32
  self.trailDuration = 0.05
  self.trailTimer = 0

  self.smokeparticleimage = love.graphics.newImage('assets/smokeparticle.png') 

  
  self.particleImage = love.graphics.newImage("assets/blood.png")
  self.particleSystem = love.graphics.newParticleSystem(self.particleImage, 32)
  self.particleSystem:setParticleLifetime(1, 1)
  self.particleSystem:setEmissionRate(32)
  self.particleSystem:setSizeVariation(1)
  self.particleSystem:setLinearAcceleration(-20, -20, 20, 20)
  self.particleSystem:setColors(145, 0, 0, 255, 145, 0, 0, 0)
  self.particleSystem:start()

  self.smokeparticle = love.graphics.newParticleSystem(self.smokeparticleimage, 8)
  self.smokeparticle:setParticleLifetime(0.1, 1) -- particles live between 2 and 5 seconds
  self.smokeparticle:setEmissionRate(10) -- emit 5 particles per second
  self.smokeparticle:setSizeVariation(1) -- vary particle size by up to 100%
  self.smokeparticle:setLinearAcceleration(-10, -10, 10, 10) -- random acceleration in any direction
  self.smokeparticle:setColors(255, 255, 255, 255, 255, 255, 255, 0) 

  self.hitinvi = false
  
end

local function playerFilter(item, other)
   
    if other.type == 1 then
        return "slide"
    elseif other.type == "enemy" then
        return "bounce"
    elseif other.type == 4 then
        return "cross"
    else
        return nil   
    end
end


function Player:update(dt)
    self.tx = math.floor(self.x / 16)
    self.ty = math.floor(self.y / 16)
    if self.x < 18 then
        self.x = 18
    end
    if self.y < 18 then
        self.y = 18
    end
    if self.x > ((maxX) * 16) +4 then
        self.x = ((maxX) * 16)+4
    end
    if self.y > ((maxY) * 16)+4 then
        self.y = ((maxY) * 16)+4
    end

    if self.hitinvi and not self.showhitinvi then
        self.showhitinvi = true
        Timer.every(0.03, function() 
            player.visible = true
        end, 14)
        Timer.every(0.05, function ()
            player.visible = false
        end, 8)
    end 

    

    if #INVENTORY > 1 then
        if love.keyboard.isDown("q") and not self.changingweapon then
            self.changingweapon = true
            local oldi = INVENTORY[1]
            INVENTORY[1] = INVENTORY[2]
            INVENTORY[2] = oldi
            print(INVENTORY[1], INVENTORY[2])
            Timer.after(0.3, function() self.changingweapon = nil end)
        end
    end

    if self.isHit then
        self.particleSystem:update(dt)
    end

    --self.smokeparticle:update(dt)
    

       
end


function Player:physics(dt)
    self.x = self.x + self.velx * dt
	self.y = self.y + self.vely * dt

	self.velx = self.velx * (1 - math.min(dt*self.friction, 1))
	self.vely = self.vely * (1 - math.min(dt*self.friction, 1))

end



function Player:move(dt)
    
   -- local anglechange = 0
    self.prevx = self.x
    self.prevy = self.y
    if love.keyboard.isDown("d") and
	self.velx < self.speed then
		self.velx = self.velx + self.speed * dt
        self.anglechange = -math.pi / 2
        self.smokeparticle:start()
	end
    
	if love.keyboard.isDown("a") and
	self.velx > -self.speed then
		self.velx = self.velx - self.speed * dt
        self.anglechange = math.pi / 2
	end
    
	if love.keyboard.isDown("s") and
	self.vely < self.speed then
		self.vely = self.vely + self.speed * dt
        self.anglechange = 0
	end
    
	if love.keyboard.isDown("w") and
	self.vely > -self.speed then
		self.vely = self.vely - self.speed * dt
        self.anglechange = math.pi
	end

    self.angle = self.anglechange
    --self.angle = self.angle % (2 * math.pi)
    
    local ax, ay, cols, len = mapWorld:move(self, self.x , self.y, playerFilter)
 
    self.x = ax
    self.y = ay
  --  mapWorld:update(self, self.cx, self.cy)
    for i = 1, #cols do


        if len == 1 and cols[i].other.type ~= 4 then
           -- print(cols[i].other)
            self.velx, self.vely = 0,0
        end
        
        if cols[i].other.type == 4 then
            cols[i].other:action()
        end
   

    end

    --self.x, self.y = newx, newy
    
   

    
   player.fov:compute(math.floor((self.x - 4) / 16), math.floor((self.y -4) / 16), 4, computeCalbak)


 --[[   player.prevx = self.x
   player.prevy = self.y ]]


end


function Player:action(x,y)

    if self.munition > 0 then
        self.munition = self.munition - 1
        self.bulletshot = true
        INVENTORY[1]:shoot(x,y)
    end


        if INVENTORY[1]:instanceOf(Drill) then
            self.bulletshot = true
            INVENTORY[1]:shoot(x,y)
        end

    

end



return Player