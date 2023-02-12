local Bullet = Class('Bullet')

function Bullet:init(x, y, targetx, targety, parent, w, h, speed, velx, vely, visible, type)
    self.x = x
    self.y = y
    self.targetx = targetx
    self.targety = targety
    self.parent = parent
    self.w = 1
    self.h = 1
    self.velx = 50
    self.vely = 50
    self.visible = true
    self.type = "Bullet"

    self.removed = false
    print(self, " added")
    mapWorld:add(self, self.x, self.y, self.w, self.h)

end

local function bulletFilter(item, other)
    if other.type == 2 or other.type == 3 then
        
        return nil
    
    elseif other.type == 1 or other.type == "enemy" then

        return "touch"
    else return nil
    end
end


function Bullet:draw()

    if self.visible then

        love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)
    end

--debug purposes
--[[     if self.removed then
        love.graphics.setColor(1,0,0)
        love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)
    end ]]

end


function Bullet:update(dt)


    if self.removed ~= true then
        self.removed = false
        local angle = math.atan2(self.targety - self.y, self.targetx - self.x)
        self.velx = math.floor(200 * math.cos(angle))
        self.vely = math.floor(200 * math.sin(angle))
        self.x = self.x + self.velx * dt
        self.y = self.y + self.vely * dt

        local _, _, cols, len = mapWorld:move(self, self.x, self.y, bulletFilter)
        for i = 1, #cols do
       --    print("type: "..cols[i].other.type)
            if cols[i].other.type == "enemy" then
                cols[i].other:kill()
                self.visible = false
                self.removed = true
                INVENTORY[1].bulletshot = false
                print(self, "  removed cos kill")
                mapWorld:remove(self)
            end
                
           

            
            if len == 1 and cols[i].other.type == 1 and self.removed == false then
                
                self.visible = false
                self.removed = true
                INVENTORY[1].bulletshot = false
                print(self, "  removed cos hit")
                mapWorld:remove(self)
                return
            end
            
            
            
            
            
        end
        
        local distance = math.sqrt((MOUSEX - self.x)^2 + (MOUSEY - self.y)^2)
        
        if distance <= 5 and self.removed ==false then
            self.visible = false
            self.removed = true
            INVENTORY[1].bulletshot = false
            print(self, "  removed cos distance")
            mapWorld:remove(self)
            return
        end




    end

    
  

    -- print(self.removed)

      --  print(self.x, self.targetx, self.x == self.targetx)

end



return Bullet