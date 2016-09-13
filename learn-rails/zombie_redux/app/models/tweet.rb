class Tweet < ApplicationRecord

  belongs_to :zombie

  validates :status, 
    presence: true,
    length: { minimum: 5 }

end
