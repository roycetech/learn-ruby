class Tweet < ApplicationRecord

  attr_accessor :message

  belongs_to :zombie

  validates :status, 
    presence: true,
    length: { minimum: 5 }

end
