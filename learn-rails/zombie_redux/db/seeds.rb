# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

zombies = [
  { name: 'Ash', graveyard: 'Glen Haven Memorial' },
  { name: 'Bob', graveyard: 'Chapel Hill Cemetery' },
  { name: 'Jim', graveyard: "My Father's Basement" },
]

zombie_records = Zombie.create(zombies)

tweets = [
  { status: 'Where can I get a good bite to eat?', zombie: zombie_records[0] },
  { status: "My left arm is missing, but I don't care.", zombie: zombie_records[1] },
  { status: 'I just ate some delicious brains.', zombie: zombie_records[2] },
  { status: 'OMG, my fingers turned green.', zombie: zombie_records[0] },
]

tweet_records = Tweet.create(tweets)
