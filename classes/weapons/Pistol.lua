local Pistol = Weapon:extend('Pistol')

function Pistol:init()

    Weapon.init(
    self,
    player.x + 4,
    player.y,
    love.graphics.newImage("assets/pistol.png")
  
)


end



function  Shoot()


    
    
end




return Pistol