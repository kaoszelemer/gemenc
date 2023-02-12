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
    print(self, " added")
    mapWorld:add(self, self.x, self.y, self.w, self.h)

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

--debug purposes
--[[     if self.removed then
        love.graphics.setColor(1,0,0)
        love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)
    end ]]

end


function DrillBullet:update(dt)


    if self.removed ~= true then
        self.removed = false
        local angle = math.atan2(self.targety - self.y, self.targetx - self.x)
        self.velx = math.floor(20 * math.cos(angle))
        self.vely = math.floor(20 * math.sin(angle))
        self.x = self.x + self.velx * dt
        self.y = self.y + self.vely * dt

        local _, _, cols, len = mapWorld:move(self, self.x, self.y, DrillBulletFilter)
        for i = 1, #cols do
       --    print("type: "..cols[i].other.type)
      --[[       if cols[i].other.type == "enemy" then
                cols[i].other:kill()
                self.visible = false
                self.removed = true
                INVENTORY[1].DrillBulletshot = false
                print(self, "  removed cos kill")
                mapWorld:remove(self)
            end ]]
                
           

            
            if len == 1 and cols[i].other.type == 1 and self.removed == false then
                
                self.visible = false
                self.removed = true
                player.bulletshot = false
            --[[     for k, v in pairs(cols[i].touch.x) do
                    print(k)
                end ]]
                print(cols[i].other)
                --[[ local mapx = math.floor(cols[i].touch.x / 16)
                local mapy = math.floor(cols[i].touch.y / 16) ]]

        --[[         print(mapx, mapy)
                print(MAP[mapx][mapy].type) ]]
                cols[i].other.type = 0
                print(self, "  removed cos hit")
                mapWorld:remove(self)
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
      --  local distance = math.sqrt((MOUSEX - self.x)^2 + (MOUSEY - self.y)^2)
        
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

    
  

    -- print(self.removed)

      --  print(self.x, self.targetx, self.x == self.targetx)

end



return DrillBullet