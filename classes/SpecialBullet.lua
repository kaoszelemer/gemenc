local SpecialBullet = Class('SpecialBullet')

function SpecialBullet:init(x, y, targetx, targety, parent, num, w, h, velx, vely, speed, visible, type)
    self.x = x
    self.y = y
    self.targetx = targetx
    self.targety = targety
    self.parent = parent
    self.num = num
    self.w = 2
    self.h = 2
    self.velx = 0
    self.vely = 0
    self.speed = 40
    self.visible = true
    self.type = "SpecialBullet"


    self.removed = false
   -- print(self, " added")
    mapWorld:add(self, self.x, self.y, self.w, self.h)
 --   self.maxbulletdistance = 25
    self.ox = x
    self.oy = y
    self.rotationspeed = math.rad(360)
    self.directionx = 1
    self.directiony = 1
    self.maxbounce = 2
    self.bounces = 0
  
    self.angle = (math.pi / 8 * self.num) 
  
  
end

local function SpecialBulletFilter(item, other)
  --  if item.parent:instanceOf(Enemy) then return nil end
    
    if other.type == "enemy"  or other.type == "egg" then
       -- print("tacs")
        return "touch"
    elseif other.type == 1 then
        return "bounce"
    end

    return nil
end


function SpecialBullet:draw()

    if self.visible then
        love.graphics.setColor(COLORS.blue)
        love.graphics.circle("fill", self.x, self.y, self.w)
        love.graphics.setColor(1,1,1)
    end


end


function SpecialBullet:update(dt)

 

 --   self.removed = false

     --   self.angle = self.angle * dt
   
      
        self.velx = 50
        self.vely = 50

--  if self.velx > 0 or self.vely > 0 then

        self.velx = self.velx * math.cos(self.angle) * self.directionx
        self.vely = self.vely * math.sin(self.angle) * self.directiony
  

        self.x = self.x + (self.velx) * dt
        self.y = self.y + (self.vely) * dt
       
   
   
    
  --  end

    
    
    
    if self.removed ~= true then
        local ax, ay, cols, len = mapWorld:move(self, self.x, self.y, SpecialBulletFilter)
        
       -- print(len)
      

        for i = 1, #cols do
           
            --   print(    cols[i].other.EnemyBulletshot)
            if cols[i].other.type == 1 then
                if self.bounces < self.maxbounce then
                    self.bounces = self.bounces + 1
                    self.directionx = self.directionx * cols[i].normal.x
                    self.directiony = self.directiony * cols[i].normal.y
                
                else
                    self.visible = false
                    self.removed = true
                    Timer.after(self.parent.rof, function()    
                        self.parent.specialshoot = false 
                    end)
                
             --   print(self, "  removed cos playerhit")
                    mapWorld:remove(self)
                end
               return
           end
            
         --   print(cols[i].other.type)
          --  print(cols[i].other.type, self.removed)
          if cols[i].other.type == "enemy" or cols[i].other.type == "egg" and not cols[i].other.hitinvi then
            cols[i].other.hp = cols[i].other.hp - 3
        --   
            
            if cols[i].other.hp <= 0 then
                if cols[i].other.name == "bossrobot" or cols[i].other.name == "bossspider" or cols[i].other.name == "bossrefrig" then
                    screenShake(0.75, 3)
                    cols[i].other:kill("boss")
                else
                    cols[i].other:kill()
                end 
            self.visible = false
            self.removed = true
            player.bulletshot = false
            print(self, "  removed cos kill")
            mapWorld:remove(self)
            else
                self.visible = false
                self.removed = true
                player.bulletshot = false
                print(self, "  removed cos hit")
                mapWorld:remove(self)
                cols[i].other.hitinvi = true
                cols[i].other.particleSystem:start()
                Timer.after(0.03, function() 
                    cols[i].other.hitinvi = false
                    cols[i].other.showhitinvi = false
                end)
            end
         
        end
         
            
        --[[     if len >= 1 then
                self.visible = false
                self.removed = true
                Timer.after(1, function()    self.parent.EnemyBulletshot = false end)
                print(self, "  removed cos hit ")
                mapWorld:remove(self)
            end
             ]]
            
            
            
        end

        if self.velx == 0 and self.vely == 0 and self.removed ~= true then
         
            self.visible = false
            self.removed = true
            Timer.after(self.parent.rof, function()    
                self.parent.EnemyBulletshot = false end)
            print(self, "  removed cos stopped ")
            mapWorld:remove(self)
            return
        end

       

    
       
   
 

    end

    
  

  --   print(self.removed)

      --  print(self.x, self.targetx, self.x == self.targetx)

end



return SpecialBullet