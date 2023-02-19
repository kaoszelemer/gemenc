local Shield = FieldItem:extend('Shield')

function Shield:init(x, y)

    FieldItem.init(
    self,
    x,
    y,
    16,
    16,
    love.graphics.newImage("assets/shielditem.png"),
    4
  
)

    mapWorld:add(self, self.x, self.y, self.w, self.h)
    self.visible = false
    self.tilex = math.floor(self.x / tileW)
    self.tiley = math.floor(self.y / tileH)
   self.name = "Shield"
end


function Shield:updateVisibility()
          if MAP[self.tilex][self.tiley].visible and not self.pickedup then
              self.visible = true
          end

end


function Shield:draw()

  if self.visible then
      love.graphics.draw(self.image, self.x, self.y)
  end


end

function Shield:action()

    if not self.pickedup then
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
      player.shielded = true
      Timer.after(10, function ()
        player.shielded = false
     end)
 

  
end

end

return Shield