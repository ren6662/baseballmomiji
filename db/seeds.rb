# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Admin.create!(
  email: 'admin@admin',
  password: 'aaaaaa'
)


=begin
# 26-36は動くが、下記のmeshiterroのカリキュラムに従った記述では動かない
users = User.create!(
  [
    {email: 'ichiro@test.com', name: '一郎', password: 'password', image:  ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/sample-user1.png"), filename:"sample-user1.png")},
    {email: 'taro@test.com', name: '太郎', password: 'password', image:  ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/sample-user2.png"), filename:"sample-user2.png")}, 
    {email: 'musashi@test.com', name: '武蔵', password: 'password', image: ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/sample-user3.png"), filename:"sample-user3.png")}
  ]
)
=end


sample_user1_image = ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/sample-user1.png"), filename:"sample-user1.png")
sample_user2_image = ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/sample-user2.png"), filename:"sample-user2.png")
sample_user3_image = ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/sample-user3.png"), filename:"sample-user3.png")

users = []
users << User.create!(email: 'ichiro@test.com', name: '一郎', password: 'password')
users[0].image.attach(sample_user1_image.signed_id)
users << User.create!(email: 'taro@test.com', name: '太郎', password: 'password')
users[1].image.attach(sample_user2_image.signed_id)
users << User.create!(email: 'musashi@test.com', name: '武蔵', password: 'password')
users[2].image.attach(sample_user3_image.signed_id)


Post.create!(
  [
   {title: '野球', image: ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/sample-post1.png"), filename:"sample-post1.png"), body: '今日はみんなと野球をしました。', user_id: users[0].id },
   {title: 'キャッチボール', image: ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/sample-post2.png"), filename:"sample-post2.png"), body: '公園でキャッチボールをしました！', user_id: users[1].id },
   {title: 'バッティングセンター', image: ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/sample-post3.png"), filename:"sample-post3.png"), body: 'バッティングセンターで気分転換！', user_id: users[2].id }
  ]
)