local Medpack = FieldItem:extend('Medpack')

function Medpack:init(x, y)

    FieldItem.init(
    self,
    x,
    y,
    16,
    16,
    love.graphics.newImage("assets/medpack.png"),
    4
  
)

    mapWorld:add(self, self.x, self.y, self.w, self.h)
    self.visible = false

    self.tilex = math.floor(self.x / self.w)
    self.tiley = math.floor(self.y / self.h)

end


function Medpack:updateVisibility()
          if MAP[self.tilex][self.tiley].visible and not self.pickedup then
              self.visible = true
          end

end


function Medpack:draw()

  if self.visible then
      love.graphics.draw(self.image, self.x, self.y)
  end


end

function Medpack:action()

    if not self.pickedup then
        self.visible = false
        self.pickedup = true
        player.hp = player.hp + 1
      --  print(self.tilex, self.tiley)
        MAP[self.tilex][self.tiley].type = 0
       -- print("itt")
 

    for i = 1, #ITEMS do
        if ITEMS[i] == self then
            table.remove(ITEMS, i)
        end
    end
end

end

return Medpack