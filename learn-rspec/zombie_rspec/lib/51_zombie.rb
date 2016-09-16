class Zombie

  has_one :weapon
  
  def decapitate
    weapon.slice(self, :head)
    self.status = 'dead again'
  end

end