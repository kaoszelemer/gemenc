local SpeedUp = FieldItem:extend('SpeedUp')

function SpeedUp:init(x, y)

    FieldItem.init(
    self,
    x,
    y,
    16,
    16,
    love.graphics.newImage("assets/speedupitem.png"),
    4
  
)

    mapWorld:add(self, self.x, self.y, self.w, self.h)
    self.visible = false
    self.tilex = math.floor(self.x / tileW)
    self.tiley = math.floor(self.y / tileH)
   self.name = "SpeedUp"
end


function SpeedUp:updateVisibility()
          if MAP[self.tilex][self.tiley].visible and not self.pickedup then
              self.visible = true
          end

end


function SpeedUp:draw()

  if self.visible then
      love.graphics.draw(self.image, self.x, self.y)
  end


end

function SpeedUp:action()

    if not self.pickedup then
        self.visible = false
        self.pickedup = true
        self.drawValueOnMap = true
        GLOBALS.numberofitems = GLOBALS.numberofitems - 1
        player:updateProgress()
        local instance = SOUNDS.pickup:play()
        Timer.after(1, function ()
            self.drawValueOnMap = false
            for i = 1, #ITEMS do
                if ITEMS[i] == self then
                    table.remove(ITEMS, i)
                end
            end
        end)
      player.speedup = true
      Timer.after(10, function ()
        player.speedup = false
        player.speedupeffect = false
        player.speed = player.originalspeed
     end)
 

  
end

end

return SpeedUp