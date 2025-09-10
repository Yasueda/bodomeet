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



User.find_or_create_by!(name: "Suzuki", email: "suzuki@example.com") do |user|
  user.name = "Suzuki"
  user.introduction = "Suzukiと申します。\r\n頭を使わないボドゲが好きです。\r\nでも色んなボドゲをやってみたいです。\r\nよろしくお願いします。"
  user.password = ENV['SUZUKI_KEY']
end

User.find_or_create_by!(name: "Tanaka", email: "tanaka@example.com") do |user|
  user.name = "Tanaka"
  user.introduction = "Tanakaです。\r\n初心者です。\r\nとにかく興味があります。"
  user.password = ENV['TANAKA_KEY']
end

User.find_or_create_by!(name: "Yoshida", email: "yoshida@example.com") do |user|
  user.name = "Yoshida"
  user.introduction = "TRPG大好きマン。\r\nクトゥルフとパラノイアがメイン。\r\nプレイヤーメイン。"
  user.password = ENV['YOSHIDA_KEY']
end

User.find_or_create_by!(name: "ハルト", email: "haruto@example.com") do |user|
  user.name = "ハルト"
  user.introduction = "なんでもやります。\r\n普通のボドゲでもTRPGでもなんでもござれ。\r\nエンジョイ勢。"
  user.password = ENV['HARUTO_KEY']
end

User.find_or_create_by!(name: "つむぎ", email: "tumigi@example.com") do |user|
  user.name = "つむぎ"
  user.introduction = "カードゲーム系が好きです。\r\nハトクラとかふるよにをよくやります。\r\n布教したいのでイベントでは初心者大歓迎です！"
  user.password = ENV['TUMUGI_KEY']
end

User.find_or_create_by!(name: "コハル", email: "koharu@example.com") do |user|
  user.name = "コハル"
  user.introduction = "人狼専門ガチ勢。\r\nネットでもやってます。\r\n1000回以上やってます。"
  user.password = ENV['KOHARU_KEY']
end

User.find_or_create_by!(name: "陽詩", email: "hinata@example.com") do |user|
  user.name = "陽詩"
  user.introduction = "ひなたと読みます。\r\nマダミスが好きです。\r\nイベントに参加していただいた方には私がプレイ済みのマダミス差し上げます。"
  user.password = ENV['HINATA_KEY']
end

User.find_or_create_by!(name: "木木", email: "hayashi@example.com") do |user|
  user.name = "木木"
  user.introduction = "ハヤシです...\r\nとりあえず登録してみたとです...\r\nハヤシです..."
  user.password = ENV['HAYASHI_KEY']
end