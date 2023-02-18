local Ammo = FieldItem:extend('Ammo')

function Ammo:init(x, y)

    FieldItem.init(
    self,
    x,
    y,
    16,
    16,
    love.graphics.newImage("assets/ammo.png"),
    4
  
)

    mapWorld:add(self, self.x, self.y, self.w, self.h)
    self.visible = false

    self.tilex = math.floor(self.x / tileW)
    self.tiley = math.floor(self.y / tileH)

end


function Ammo:updateVisibility()

      --      print(MAP[self.tilex][self.tilex].type)
         --[[    if MAP[self.tilex][self.tilex].type == 2 then
                self.visible = true
            end ]]

            if MAP[self.tilex][self.tiley].visible and not self.pickedup then
                self.visible = true
            end

   
end


function Ammo:draw()

    if self.visible then
        love.graphics.draw(self.image, self.x, self.y)
    end


end

function Ammo:action()

    if not self.pickedup then
        self.visible = false
        self.pickedup = true
        player.munition = player.munition + 19
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

return Ammo