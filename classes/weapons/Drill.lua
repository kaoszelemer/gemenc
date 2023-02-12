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

    
    if player.drillbulletshot ~= true then
        player.drillbulletshot = true
        table.insert(BULLETS, DrillBullet(self.x,self.y, x, y, player))
        print("inserting bullet")
    end 
    print("drilling")

end




return Drill