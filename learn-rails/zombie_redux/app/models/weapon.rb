class Weapon < ApplicationRecord
  belongs_to :zombie

  validates :name, 
    presence: true,
    uniqueness: true, 
    length: { minimum: 3 }

  validates :damage, 
    presence: true,
    length: {minimum: 1, maximum: 10}

end
