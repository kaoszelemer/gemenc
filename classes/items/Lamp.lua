local Lamp = FieldItem:extend('Lamp')

function Lamp:init(x, y)

    FieldItem.init(
    self,
    x,
    y,
    16,
    16,
    love.graphics.newImage("assets/lampitem.png"),
    4
  
)

    mapWorld:add(self, self.x, self.y, self.w, self.h)
    self.visible = false

    self.tilex = math.floor(self.x / tileW)
    self.tiley = math.floor(self.y / tileH)
    self.hpup = love.math.random(1,3)
    self.name = "Lamp"

end


function Lamp:updateVisibility()
          if MAP[self.tilex][self.tiley].visible and not self.pickedup then
              self.visible = true
          end

end


function Lamp:draw()

  if self.visible then
      love.graphics.draw(self.image, self.x, self.y)
  end


end

function Lamp:action()

    if not self.pickedup then
     
         local instance = SOUNDS.pickup:play()
        self.visible = false
        self.pickedup = true
        self.drawValueOnMap = true
        Timer.after(1, function ()
            self.drawValueOnMap = false
            for i = 1, #ITEMS do
                if ITEMS[i] == self then
                    table.remove(ITEMS, i)
                end
            end
        end)
      for x = 1, maxX do
        for y = 1, maxY do
            MAP[x][y].visible = true
        end 
      end
      --  print(self.tilex, self.tiley)
        MAP[self.tilex][self.tiley].type = 0
        -- print("itt")
        
        
       
  
    end

end

return Lamp