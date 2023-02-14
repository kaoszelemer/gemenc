local Drill = Weapon:extend('Drill')

function Drill:init()

    Weapon.init(
    self,
    player.x + 4,
    player.y,
    love.graphics.newImage("assets/drillitem.png"),
    3
  
)



end



function Drill:shoot(x, y)


        table.insert(BULLETS, DrillBullet(self.x,self.y, x, y, player))
   
  
end




return Drill