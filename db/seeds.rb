# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Admin.find_or_create_by!(email: "admin@example.com") do |admin|
  admin.password = ENV['ADMIN_KEY']
end

# Seed用ユーザー
users = [
  {
    name:         "Suzuki",
    email:        "suzuki@example.com",
    introduction: "Suzukiと申します。\r\n頭を使わないボドゲが好きです。\r\nでも色んなボドゲをやってみたいです。\r\nよろしくお願いします。",
    password:     ENV['SUZUKI_KEY'],
    user_image:   ActiveStorage::Blob.create_and_upload!(io: File.open(Rails.root.join("app/assets/images/users/battery_icon.jpeg")),filename: 'icon-image.jpeg',content_type: 'image/jpeg')
  },
  {
    name:         "Tanaka",
    email:        "tanaka@example.com",
    introduction: "Tanakaです。\r\n初心者です。\r\nとにかくボドゲに興味があります。",
    password:     ENV['TANAKA_KEY'],
    user_image:   ActiveStorage::Blob.create_and_upload!(io: File.open(Rails.root.join("app/assets/images/users/car_icon.jpeg")),filename: 'icon-image.jpeg',content_type: 'image/jpeg')
  },
  {
    name:         "Yoshida",
    email:        "yoshida@example.com",
    introduction: "TRPG大好きマン。\r\nクトゥルフとパラノイアがメイン。\r\nプレイヤーメイン。",
    password:     ENV['YOSHIDA_KEY'],
    user_image:   ActiveStorage::Blob.create_and_upload!(io: File.open(Rails.root.join("app/assets/images/users/angling_icon.jpeg")),filename: 'icon-image.jpeg',content_type: 'image/jpg')
  },
  {
    name:         "ハルト",
    email:        "haruto@example.com",
    introduction: "なんでもやります。\r\n普通のボドゲでもTRPGでもなんでもござれ。\r\nエンジョイ勢。",
    password:     ENV['HARUTO_KEY'],
    user_image:   ActiveStorage::Blob.create_and_upload!(io: File.open(Rails.root.join("app/assets/images/users/toilet_icon.jpeg")),filename: 'icon-image.jpeg',content_type: 'image/jpeg')
  },
  {
    name:         "つむぎ",
    email:        "tumugi@example.com",
    introduction: "カードゲーム系が好きです。\r\nハトクラとかふるよにをよくやります。\r\n布教したいのでイベントでは初心者大歓迎です!!",
    password:     ENV['TUMUGI_KEY'],
    user_image:   ActiveStorage::Blob.create_and_upload!(io: File.open(Rails.root.join("app/assets/images/users/palm_icon.jpeg")),filename: 'icon-image.jpeg',content_type: 'image/jpeg')
  },
  {
    name:         "コハル",
    email:        "koharu@example.com",
    introduction: "人狼専門ガチ勢。\r\nネットでもやってます。\r\n1000回以上やってます。",
    password:     ENV['KOHARU_KEY'],
    user_image:   ActiveStorage::Blob.create_and_upload!(io: File.open(Rails.root.join("app/assets/images/users/cherryblossom_icon.jpeg")),filename: 'icon-image.jpeg',content_type: 'image/jpeg')
  },
  {
    name:         "陽詩",
    email:        "hinata@example.com",
    introduction: "ひなたと読みます。\r\nマダミスが好きです。\r\nイベントに参加していただいた方には私がプレイ済みのマダミス差し上げます。",
    password:     ENV['HINATA_KEY'],
    user_image:   ActiveStorage::Blob.create_and_upload!(io: File.open(Rails.root.join("app/assets/images/users/sunrise_icon.jpeg")),filename: 'icon-image.jpeg',content_type: 'image/jpeg')
  },
  {
    name:         "木木",
    email:        "hayashi@example.com",
    introduction: "ハヤシです...\r\nとりあえず登録してみたとです...\r\nハヤシです...",
    password:     ENV['HAYASHI_KEY'],
    user_image:   ActiveStorage::Blob.create_and_upload!(io: File.open(Rails.root.join("app/assets/images/users/trees_icon.jpeg")),filename: 'icon-image.jpeg',content_type: 'image/jpeg')
  }
]

users.each do |user|
  unless User.find_by(name: user[:name], email: user[:email])
    User.create!(user)
  end
end

#Seed用イベント
events = [
  {
    user:         User.find_by(name: "つむぎ"),
    name:         "【初心者歓迎】第１回 ハトクラ＆ふるよにメインTCG会",
    introduction: "初心者歓迎!! 場代は主催者持ち!!\r\n「ハートオブクラウン」と「桜散る代に決闘を」をメインでやります!!\r\n初心者にも一から教えますので気軽にご参加下さい!!\r\n途中抜けOKです!!",
    date:         "2025-10-15",
    start_time:   "13:00",
    end_time:     "18:00",
    venue:        "東京都小金井市本町XX-XX-XX",
    min_people:   "6",
    max_people:   "12",
    event_image:  ActiveStorage::Blob.create_and_upload!(io: File.open(Rails.root.join("app/assets/images/events/tcg.png")),filename: 'event-image.png',content_type: 'image/png')
  },
  {
    user:         User.find_by(name: "コハル"),
    name:         "人狼やる？やる！ 第１村",
    introduction: "初心者お断り。経験者でも100村以上経験推奨。\r\n結構ガチでやりたいので申し訳ありませんが初心者はお断りします。\r\n場代も割り勘でお願いします。（場代払ってでもガチでやりたい人向け）\r\n朝から夕方まで、昼はごちそうします。",
    date:         "2025-9-30",
    start_time:   "10:00",
    end_time:     "18:00",
    venue:        "東京都渋谷区桜丘町XX-XX",
    min_people:   "12",
    max_people:   "20",
    event_image:  ActiveStorage::Blob.create_and_upload!(io: File.open(Rails.root.join("app/assets/images/events/werewolf.png")),filename: 'event-image.png',content_type: 'image/png')
  }
]

events.each do |event|
  Event.create!(event)
end