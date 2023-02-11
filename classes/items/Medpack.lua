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
    self.tiley = math.floor(self.x / self.h)

end


function Medpack:updateVisibility()

            print(MAP[self.tilex][self.tilex].type)
         --[[    if MAP[self.tilex][self.tilex].type == 2 then
                self.visible = true
            end ]]

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

    if self.visible ~= false then
        self.visible = false
        self.pickedup = true
        print(self.tilex, self.tiley)
    end

end

return Medpack