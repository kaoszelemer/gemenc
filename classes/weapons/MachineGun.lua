local MachineGun = Weapon:extend('MachineGun')

function MachineGun:init()

    Weapon.init(
    self,
    player.x + 4,
    player.y,
    love.graphics.newImage("assets/machinegun.png"),
    3
  
)


end



function MachineGun:shoot(x, y)
        local instance = SOUNDS.bullet:play()
        player.munition = player.munition - 1
        table.insert(BULLETS, Bullet(self.x +4,self.y+4, x, y, player))

end




return MachineGun