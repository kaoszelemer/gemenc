local DrillBullet = Class('DrillBullet')

function DrillBullet:init(x, y, targetx, targety, parent, w, h, speed, velx, vely, visible, type)
    self.x = x
    self.y = y
    self.targetx = targetx
    self.targety = targety
    self.parent = parent
    self.w = 4
    self.h = 4
    self.velx = 5
    self.vely = 5
    self.visible = true
    self.type = "DrillBullet"


    self.removed = false
    mapWorld:add(self, self.x, self.y, self.w, self.h)
    self.dpi = love.graphics.newImage("assets/dustparticle.png")
    self.dustparticles = love.graphics.newParticleSystem(self.dpi, 100)
    
    self.dustparticles:setParticleLifetime(1, 2) -- particles will live for 1 to 2 seconds
    self.dustparticles:setEmissionRate(50) -- 50 particles will be emitted per second
    self.dustparticles:setSpeed(50, 100) -- particles will move at a speed of 50 to 100 units per second
    self.dustparticles:setSpread(math.pi / 2) -- particles will spread out in a cone shape
    self.dustparticles:setSizes(0.5, 1) -- particles will start at half the size of the sprite and end at the full size
    self.dustparticles:setSizeVariation(0.5) -- size of particles can vary by up to 50%
    self.dustparticles:setRotation(0, math.pi) -- particles can rotate randomly
    self.dustparticles:setSpin(0, math.pi) -- particles can spin randomly
end

local function DrillBulletFilter(item, other)
   
    
    if other.type == 1 then
        return "touch"
    else return nil
    end
end


function DrillBullet:draw()

    if self.visible then

        love.graphics.circle("fill", self.x, self.y, self.w)
    end


    if self.isHit then
        love.graphics.draw(self.dustparticles, self.x, self.y)
    end

end


function DrillBullet:update(dt)

    if self.isHit then
        self.dustparticles:update(dt)
    end

    if self.removed ~= true then
        self.removed = false
        local angle = math.atan2(self.targety - self.y, self.targetx - self.x)
        self.velx = math.floor(20 * math.cos(angle))
        self.vely = math.floor(20 * math.sin(angle))
        self.x = self.x + self.velx * dt
        self.y = self.y + self.vely * dt

        local ax, ay, cols, len = mapWorld:move(self, self.x, self.y, DrillBulletFilter)
        self.x = ax
        self.y = ay
        for i = 1, #cols do
        
            if len == 1 and self.removed == false then
                self.velx, self.vely = 0,0
              
                self.visible = false
                self.removed = true
                player.bulletshot = false
                self.isHit = true

                self.dustparticles:start()
                Timer.after(0.4, function() 
                    self.dustparticles:stop() 
                    self.isHit = false
                end)

                mapWorld:remove(self)
                cols[i].other.type = 0
                print(self, "  removed cos hit")
                return
            end
            
            
            
            
            
        end

        if self.velx == 0 and self.vely == 0 and self.removed ~= true then
         
            self.visible = false
            self.removed = true
            Timer.after(0.3, function()    player.bulletshot = false end)
            print(self, "  removed cos stopped ")
            mapWorld:remove(self)
            return
        end
        
        local distance1 = math.sqrt((player.x - (self.targetx))^2 + (player.y - (self.targety))^2)
        local distance2 = math.sqrt((player.x - (self.x))^2 + (player.y - (self.y))^2)
      
      
         if (distance1 - distance2)*1 <= 2 and self.removed ~= true then
             self.visible = false
             self.removed = true
            
           
             Timer.after(0.3, function()    player.bulletshot = false end)
             print(self, "  removed cos distance ")
             mapWorld:remove(self)
         end




    end

end



return DrillBullet