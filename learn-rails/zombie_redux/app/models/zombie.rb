class Zombie < ApplicationRecord

  attr_accessor :status, :email

  has_many :tweets , dependent: :destroy
  has_many :weapons, dependent: :destroy
  # has_one :weapon, dependent: :destroy

  validates :name, 
    presence: true,
    uniqueness: true, 
    length: { minimum: 3 }

  validates :graveyard, 
    presence: true,
    length: { minimum: 3 }

  # validates_associated :tweets, :weapons

  validate do |zombie|
    errors[:base].clear
    zombie.tweets.each do |tweet|
      next if tweet.valid?
      puts tweet.errors.inspect
      puts tweet.errors[:messages]
      errors[:base] << tweet.errors.full_messages[0]
    end
  end

  def weapon
    Weapon.new
  end

  def decapitate
    @status = 'dead again'
  end

end
