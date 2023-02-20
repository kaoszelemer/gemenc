local SGitem = FieldItem:extend('SGitem')

function SGitem:init(x, y)

    FieldItem.init(
    self,
    x,
    y,
    16,
    16,
    love.graphics.newImage("assets/sgitem.png"),
    4
  
)

    mapWorld:add(self, self.x, self.y, self.w, self.h)
    self.visible = false
    self.tilex = math.floor(self.x / tileW)
    self.tiley = math.floor(self.y / tileH)
    self.name = "SG"

end


function SGitem:updateVisibility()

      --      print(MAP[self.tilex][self.tilex].type)
         --[[    if MAP[self.tilex][self.tilex].type == 2 then
                self.visible = true
            end ]]

            if MAP[self.tilex][self.tiley].visible and not self.pickedup then
                self.visible = true
            end

   
end


function SGitem:draw()

    if self.visible then
        love.graphics.draw(self.image, self.x, self.y)
    end


end

function SGitem:action()

    if not self.pickedup then
        self.visible = false
        self.pickedup = true
        self.drawValueOnMap = true
        local instance = SOUNDS.pickup:play()
        Timer.after(1, function ()
            self.drawValueOnMap = false
            for i = 1, #ITEMS do
                if ITEMS[i] == self then
                    table.remove(ITEMS, i)
                end
            end
        end)
      --  print(self.tilex, self.tiley)
     
       -- print("itt")
        
        table.insert(INVENTORY, ShotGun())
        print(#INVENTORY)


end

end

return SGitem