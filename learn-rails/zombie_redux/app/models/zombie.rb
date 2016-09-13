class Zombie < ApplicationRecord

  has_many :tweets , dependent: :destroy
  has_many :weapons, dependent: :destroy

  validates :name, 
    presence: true,
    uniqueness: true, 
    length: { minimum: 3 }

  validates :graveyard, 
    presence: true,
    length: { minimum: 3 }

  validates_associated :tweets, :weapons


end
