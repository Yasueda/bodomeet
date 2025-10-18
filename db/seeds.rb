# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

puts "seed 登録開始"

require 'faker'

puts "Admin 登録中..."

Admin.find_or_create_by!(email: "admin@example.com") do |admin|
  admin.password = ENV['ADMIN_KEY']
end

puts "User 登録中..."

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
    name:         "コハル",
    email:        "koharu@example.com",
    introduction: "人狼専門ガチ勢。\r\nネットでもやってます。\r\n1000回以上やってます。",
    password:     ENV['KOHARU_KEY'],
    user_image:   ActiveStorage::Blob.create_and_upload!(io: File.open(Rails.root.join("app/assets/images/users/cherryblossom_icon.jpeg")),filename: 'icon-image.jpeg',content_type: 'image/jpeg')
  },
  {
    name:         "つむぎ",
    email:        "tumugi@example.com",
    introduction: "カードゲーム系が好きです。\r\nハトクラとかふるよにをよくやります。\r\n布教したいのでイベントでは初心者大歓迎です!!",
    password:     ENV['TUMUGI_KEY'],
    user_image:   ActiveStorage::Blob.create_and_upload!(io: File.open(Rails.root.join("app/assets/images/users/palm_icon.jpeg")),filename: 'icon-image.jpeg',content_type: 'image/jpeg')
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
  },
  {
    name:         "日葵",
    email:        "himari@example.com",
    introduction: "ひまりでええええっす！\r\nなんでもやりまーーーーす。",
    password:     ENV['HIMARI_KEY'],
    user_image:   ActiveStorage::Blob.create_and_upload!(io: File.open(Rails.root.join("app/assets/images/users/pollen_icon.jpeg")),filename: 'icon-image.jpeg',content_type: 'image/jpeg')
  },
  {
    name:         "NAGISA",
    email:        "nagisa@example.com",
    introduction: "人狼とかをよくやるかも。でも色々。",
    password:     ENV['NAGISA_KEY'],
    user_image:   ActiveStorage::Blob.create_and_upload!(io: File.open(Rails.root.join("app/assets/images/users/sunfish_icon.jpeg")),filename: 'icon-image.jpeg',content_type: 'image/jpeg')
  }
]

users.each do |user|
  unless User.find_by(name: user[:name], email: user[:email])
    User.create!(user)
  end
end

# is_active:falseユーザー
5.times do
  password = Faker::Alphanumeric.alphanumeric(number: 6)
  user = {
    name:         Faker::Name.unique.first_name,
    email:        Faker::Internet.unique.email,
    introduction: Faker::Lorem.paragraph(sentence_count: 5),
    password:     password
  }
  unless User.find_by(name: user[:name], email: user[:email])
    user = User.new(user)
    user.is_active = :false
    user.save
  end
end

# is_active:falseイベント用ダミーユーザー
user = {
  name:         "dummy_user",
  email:        "dummy_user@example.email",
  introduction: Faker::Lorem.paragraph(sentence_count: 5),
  password:     "dummy_user"
}
unless User.find_by(name: user[:name], email: user[:email])
  user = User.new(user)
  user.is_active = :false
  user.save
end

puts "Event 登録中..."

events = [
  {
    user:         User.find_by(name: "つむぎ"),
    name:         "【初心者歓迎】第１回 ハトクラ＆ふるよにメインTCG会",
    introduction: "初心者歓迎!! 場代は主催者持ち!!\r\n「ハートオブクラウン」と「桜散る代に決闘を」をメインでやります!!\r\n初心者にも１から教えますので気軽にご参加下さい!!\r\n途中抜けOKです!!",
    date:         "2025-9-13",
    start_time:   "13:00",
    end_time:     "18:00",
    venue:        "東京都小金井市本町XX-XX-XX",
    min_people:   "4",
    max_people:   "12",
    event_image:  ActiveStorage::Blob.create_and_upload!(io: File.open(Rails.root.join("app/assets/images/events/tcg.jpg")),filename: 'event-image.jpg',content_type: 'image/jpg')
  },
  {
    user:         User.find_by(name: "つむぎ"),
    name:         "【初心者歓迎】第２回 ハトクラ＆ふるよにメインTCG会",
    introduction: "初心者歓迎!! 場代は主催者持ち!!\r\n「ハートオブクラウン」と「桜散る代に決闘を」をメインでやります!!\r\n初心者にも１から教えますので気軽にご参加下さい!!\r\n途中抜けOKです!!",
    date:         "2025-10-11",
    start_time:   "13:00",
    end_time:     "18:00",
    venue:        "東京都小金井市本町XX-XX-XX",
    min_people:   "4",
    max_people:   "12",
    event_image:  ActiveStorage::Blob.create_and_upload!(io: File.open(Rails.root.join("app/assets/images/events/tcg.jpg")),filename: 'event-image.jpg',content_type: 'image/jpg')
  },
  {
    user:         User.find_by(name: "つむぎ"),
    name:         "【初心者歓迎】第３回 ハトクラ＆ふるよにメインTCG会",
    introduction: "初心者歓迎!! 場代は主催者持ち!!\r\n「ハートオブクラウン」と「桜散る代に決闘を」をメインでやります!!\r\n初心者にも１から教えますので気軽にご参加下さい!!\r\n途中抜けOKです!!",
    date:         "2025-11-15",
    start_time:   "13:00",
    end_time:     "18:00",
    venue:        "東京都小金井市本町XX-XX-XX",
    min_people:   "4",
    max_people:   "12",
    event_image:  ActiveStorage::Blob.create_and_upload!(io: File.open(Rails.root.join("app/assets/images/events/tcg.jpg")),filename: 'event-image.jpg',content_type: 'image/jpg')
  },
  {
    user:         User.find_by(name: "コハル"),
    name:         "人狼やる？やる！ 第１村",
    introduction: "初心者お断り。経験者でも100村以上経験推奨。\r\n結構ガチでやりたいので申し訳ありませんが初心者はお断りします。\r\n場代も割り勘でお願いします。（場代払ってでもガチでやりたい人向け）\r\n朝から夕方まで、昼はごちそうします。",
    date:         "2025-9-7",
    start_time:   "10:00",
    end_time:     "18:00",
    venue:        "東京都渋谷区桜丘町XX-XX",
    min_people:   "8",
    max_people:   "20",
    event_image:  ActiveStorage::Blob.create_and_upload!(io: File.open(Rails.root.join("app/assets/images/events/werewolf.jpg")),filename: 'event-image.jpg',content_type: 'image/jpg')
  },
  {
    user:         User.find_by(name: "コハル"),
    name:         "人狼やる？やる！ 第２村",
    introduction: "初心者お断り。経験者でも100村以上経験推奨。\r\n結構ガチでやりたいので申し訳ありませんが初心者はお断りします。\r\n場代も割り勘でお願いします。（場代払ってでもガチでやりたい人向け）\r\n朝から夕方まで、昼はごちそうします。",
    date:         "2025-10-19",
    start_time:   "10:00",
    end_time:     "18:00",
    venue:        "東京都渋谷区桜丘町XX-XX",
    min_people:   "8",
    max_people:   "20",
    event_image:  ActiveStorage::Blob.create_and_upload!(io: File.open(Rails.root.join("app/assets/images/events/werewolf.jpg")),filename: 'event-image.jpg',content_type: 'image/jpg')
  },
  {
    user:         User.find_by(name: "コハル"),
    name:         "人狼やる？やる！ 第３村",
    introduction: "初心者お断り。経験者でも100村以上経験推奨。\r\n結構ガチでやりたいので申し訳ありませんが初心者はお断りします。\r\n場代も割り勘でお願いします。（場代払ってでもガチでやりたい人向け）\r\n朝から夕方まで、昼はごちそうします。",
    date:         "2025-11-30",
    start_time:   "10:00",
    end_time:     "18:00",
    venue:        "東京都渋谷区桜丘町XX-XX",
    min_people:   "8",
    max_people:   "20",
    event_image:  ActiveStorage::Blob.create_and_upload!(io: File.open(Rails.root.join("app/assets/images/events/werewolf.jpg")),filename: 'event-image.jpg',content_type: 'image/jpg')
  },
  {
    user:         User.find_by(name: "ハルト"),
    name:         "幸福な市民の皆様、第１会議室までお集まり下さい",
    introduction: "エンジョイ勢なので楽しくやりましょう！\r\n主催がGMするつもりですがGMしたい人も歓迎します！",
    date:         "2025-10-26",
    start_time:   "13:00",
    end_time:     "18:00",
    venue:        "東京都台東区東上野XX丁目XX−XX",
    min_people:   "3",
    max_people:   "6",
    event_image:  ActiveStorage::Blob.create_and_upload!(io: File.open(Rails.root.join("app/assets/images/events/paranoia.jpg")),filename: 'event-image.jpg',content_type: 'image/jpg')
  },
  {
    user:         User.find_by(name: "ハルト"),
    name:         "幸福な市民の皆様、第２会議室までお集まり下さい",
    introduction: "エンジョイ勢なので楽しくやりましょう！\r\n主催がGMするつもりですがGMしたい人も歓迎します！",
    date:         "2025-11-30",
    start_time:   "13:00",
    end_time:     "18:00",
    venue:        "東京都台東区東上野XX丁目XX−XX",
    min_people:   "3",
    max_people:   "6",
    event_image:  ActiveStorage::Blob.create_and_upload!(io: File.open(Rails.root.join("app/assets/images/events/paranoia.jpg")),filename: 'event-image.jpg',content_type: 'image/jpg')
  },
  {
    user:         User.find_by(name: "陽詩"),
    name:         "【初心者歓迎】第一回マダミスの集い",
    introduction: "初心者歓迎\r\n持ち込んでもOK!\r\n多数のマダミスを用意しているので人数に合わせてその場で決めます!!",
    date:         "2025-9-15",
    start_time:   "13:00",
    end_time:     "18:00",
    venue:        "東京都中央区銀座XX丁目XX−XX",
    min_people:   "4",
    max_people:   "8",
    event_image:  ActiveStorage::Blob.create_and_upload!(io: File.open(Rails.root.join("app/assets/images/events/murder_mystery.jpg")),filename: 'event-image.jpg',content_type: 'image/jpg')
  },
  {
    user:         User.find_by(name: "陽詩"),
    name:         "【初心者歓迎】第二回マダミスの集い",
    introduction: "初心者歓迎\r\n持ち込んでもOK!\r\n多数のマダミスを用意しているので人数に合わせてその場で決めます!!",
    date:         "2025-9-23",
    start_time:   "13:00",
    end_time:     "18:00",
    venue:        "東京都中央区銀座XX丁目XX−XX",
    min_people:   "4",
    max_people:   "8",
    event_image:  ActiveStorage::Blob.create_and_upload!(io: File.open(Rails.root.join("app/assets/images/events/murder_mystery.jpg")),filename: 'event-image.jpg',content_type: 'image/jpg')
  },
  {
    user:         User.find_by(name: "陽詩"),
    name:         "【初心者歓迎】第三回マダミスの集い",
    introduction: "初心者歓迎\r\n持ち込んでもOK!\r\n多数のマダミスを用意しているので人数に合わせてその場で決めます!!",
    date:         "2025-10-13",
    start_time:   "13:00",
    end_time:     "18:00",
    venue:        "東京都中央区銀座XX丁目XX−XX",
    min_people:   "4",
    max_people:   "8",
    event_image:  ActiveStorage::Blob.create_and_upload!(io: File.open(Rails.root.join("app/assets/images/events/murder_mystery.jpg")),filename: 'event-image.jpg',content_type: 'image/jpg')
  },
  {
    user:         User.find_by(name: "Yoshida"),
    name:         "邪神降臨 １柱目",
    introduction: "オリジナルシナリオをやります。\r\nルールは６版に準じますのでよろしくお願いします。",
    date:         "2025-9-6",
    start_time:   "13:00",
    end_time:     "18:00",
    venue:        "東京都新宿区西早稲田XX-XX-XX",
    min_people:   "4",
    max_people:   "6",
    event_image:  ActiveStorage::Blob.create_and_upload!(io: File.open(Rails.root.join("app/assets/images/events/cthulhu.jpg")),filename: 'event-image.jpg',content_type: 'image/jpg')
  },
  {
    user:         User.find_by(name: "Yoshida"),
    name:         "邪神降臨 ２柱目",
    introduction: "オリジナルシナリオをやります。\r\nルールは６版に準じますのでよろしくお願いします。",
    date:         "2025-10-11",
    start_time:   "13:00",
    end_time:     "18:00",
    venue:        "東京都新宿区西早稲田XX-XX-XX",
    min_people:   "4",
    max_people:   "6",
    event_image:  ActiveStorage::Blob.create_and_upload!(io: File.open(Rails.root.join("app/assets/images/events/cthulhu.jpg")),filename: 'event-image.jpg',content_type: 'image/jpg')
  },
  {
    user:         User.find_by(name: "Yoshida"),
    name:         "邪神降臨 ３柱目",
    introduction: "オリジナルシナリオをやります。\r\nルールは６版に準じますのでよろしくお願いします。",
    date:         "2025-11-22",
    start_time:   "13:00",
    end_time:     "18:00",
    venue:        "東京都新宿区西早稲田XX-XX-XX",
    min_people:   "4",
    max_people:   "6",
    event_image:  ActiveStorage::Blob.create_and_upload!(io: File.open(Rails.root.join("app/assets/images/events/cthulhu.jpg")),filename: 'event-image.jpg',content_type: 'image/jpg')
  }
]

events.each do |event|
  unless Event.find_by(name: event[:name], is_active: true)
    event = Event.new(event)
    # 過去のイベントも保存するためにバリデーション回避
    event.save(validate: false)
  end
end

# is_active:falseイベント
5.times do
  event = {
    user:         User.find_by(name: "dummy_user"),
    name:         Faker::Game.title,
    introduction: Faker::Lorem.paragraph(sentence_count: 5),
    date:         Faker::Date.in_date_period,
    start_time:   "13:00",
    end_time:     "18:00",
    venue:        "XX県XX市XX町XX-XX-XX",
    min_people:   "4",
    max_people:   "8"
  }
  unless Event.find_by(name: event[:name])
    event = Event.new(event)
    event.is_active = :false
    event.save(validate: false)
  end
end

puts "Participant 登録中..."

event_01 = "【初心者歓迎】第１回 ハトクラ＆ふるよにメインTCG会"
event_02 = "【初心者歓迎】第２回 ハトクラ＆ふるよにメインTCG会"
event_03 = "【初心者歓迎】第３回 ハトクラ＆ふるよにメインTCG会"
event_11 = "人狼やる？やる！ 第１村"
event_12 = "人狼やる？やる！ 第２村"
event_13 = "人狼やる？やる！ 第３村"
event_21 = "幸福な市民の皆様、第１会議室までお集まり下さい"
event_22 = "幸福な市民の皆様、第２会議室までお集まり下さい"

participants = [
  {
    user_id:   User.find_by(name: "Suzuki").id,
    event_id:  Event.find_by(name: event_01).id
  },
  {
    user_id:   User.find_by(name: "Tanaka").id,
    event_id:  Event.find_by(name: event_01).id
  },
  {
    user_id:   User.find_by(name: "ハルト").id,
    event_id:  Event.find_by(name: event_01).id
  },
  {
    user_id:   User.find_by(name: "Tanaka").id,
    event_id:  Event.find_by(name: event_02).id
  },
  {
    user_id:   User.find_by(name: "Suzuki").id,
    event_id:  Event.find_by(name: event_02).id
  },
  {
    user_id:   User.find_by(name: "ハルト").id,
    event_id:  Event.find_by(name: event_02).id
  },
  {
    user_id:   User.find_by(name: "木木").id,
    event_id:  Event.find_by(name: event_02).id
  },
  {
    user_id:   User.find_by(name: "Suzuki").id,
    event_id:  Event.find_by(name: event_03).id
  },
  {
    user_id:   User.find_by(name: "Tanaka").id,
    event_id:  Event.find_by(name: event_03).id
  },
  {
    user_id:   User.find_by(name: "ハルト").id,
    event_id:  Event.find_by(name: event_03).id
  },
  {
    user_id:   User.find_by(name: "Tanaka").id,
    event_id:  Event.find_by(name: event_03).id
  },
  {
    user_id:   User.find_by(name: "日葵").id,
    event_id:  Event.find_by(name: event_03).id
  },
  {
    user_id:   User.find_by(name: "NAGISA").id,
    event_id:  Event.find_by(name: event_03).id
  },
  {
    user_id:   User.find_by(name: "NAGISA").id,
    event_id:  Event.find_by(name: event_11).id
  },
  {
    user_id:   User.find_by(name: "木木").id,
    event_id:  Event.find_by(name: event_11).id
  },
  {
    user_id:   User.find_by(name: "ハルト").id,
    event_id:  Event.find_by(name: event_11).id
  },
  {
    user_id:   User.find_by(name: "つむぎ").id,
    event_id:  Event.find_by(name: event_11).id
  },
  {
    user_id:   User.find_by(name: "ハルト").id,
    event_id:  Event.find_by(name: event_12).id
  },
  {
    user_id:   User.find_by(name: "NAGISA").id,
    event_id:  Event.find_by(name: event_12).id
  },
  {
    user_id:   User.find_by(name: "木木").id,
    event_id:  Event.find_by(name: event_12).id
  },
  {
    user_id:   User.find_by(name: "つむぎ").id,
    event_id:  Event.find_by(name: event_12).id
  },
  {
    user_id:   User.find_by(name: "日葵").id,
    event_id:  Event.find_by(name: event_12).id
  },
  {
    user_id:   User.find_by(name: "陽詩").id,
    event_id:  Event.find_by(name: event_12).id
  },
  {
    user_id:   User.find_by(name: "Yoshida").id,
    event_id:  Event.find_by(name: event_21).id
  },
  {
    user_id:   User.find_by(name: "日葵").id,
    event_id:  Event.find_by(name: event_21).id
  },
  {
    user_id:   User.find_by(name: "NAGISA").id,
    event_id:  Event.find_by(name: event_21).id
  }
]

participants.each do |participant|
  unless Participant.find_by(user_id: participant[:user_id], event_id: participant[:event_id])
    Participant.create!(participant)
  end
end

puts "Comment 登録中..."

comments = [
  {
    user_id:    User.find_by(name: "Suzuki").id,
    event_id:   Event.find_by(name: event_01).id,
    content:    "初プレイですが参加できますか？",
    created_at: "2025-8-2 16:28:16 +0900".to_datetime,
  },
  {
    user_id:    User.find_by(name: "つむぎ").id,
    event_id:   Event.find_by(name: event_01).id,
    content:    "大丈夫です！是非とも参加して下さい！",
    created_at: "2025-8-4 01:12:48 +0900".to_datetime
  },
  {
    user_id:   User.find_by(name: "Suzuki").id,
    event_id:  Event.find_by(name: event_01).id,
    content:   "ありがとうございます。よろしくお願いします。",
    created_at: "2025-8-15 12:32:11 +0900".to_datetime
  },
  {
    user_id:    User.find_by(name: "Tanaka").id,
    event_id:   Event.find_by(name: event_02).id,
    content:    "自分でふるよに持ち込んでいい？",
    created_at: "2025-9-15 17:21:02 +0900".to_datetime

  },
  {
    user_id:    User.find_by(name: "つむぎ").id,
    event_id:   Event.find_by(name: event_02).id,
    content:    "現行シリーズは全て１セットありますので自分のデッキを持ち込みたいのであればお持ち下さい",
    created_at: "2025-9-18 00:27:17 +0900".to_datetime
  },
  {
    user_id:    User.find_by(name: "Tanaka").id,
    event_id:   Event.find_by(name: event_02).id,
    content:    "マイデッキ持っていきます",
    created_at: "2025-9-20 10:42:57 +0900".to_datetime
  },
  {
    user_id:    User.find_by(name: "ハルト").id,
    event_id:   Event.find_by(name: event_02).id,
    content:    "参加よろしくおねがいしますー",
    created_at: "2025-9-21 23:08:19 +0900".to_datetime
  },
  {
    user_id:    User.find_by(name: "NAGISA").id,
    event_id:   Event.find_by(name: event_11).id,
    content:    "これって役職はどうなってます？",
    created_at: "2025-8-3 16:20:36 +0900".to_datetime
  },
  {
    user_id:    User.find_by(name: "コハル").id,
    event_id:   Event.find_by(name: event_11).id,
    content:    "参加人数によりけりですが、最初に狼２占１狂１あたりでプレイして、その後様子見つつ変えていくつもりです",
    created_at: "2025-8-3 23:21:06 +0900".to_datetime
  },
  {
    user_id:    User.find_by(name: "NAGISA").id,
    event_id:   Event.find_by(name: event_11).id,
    content:    "狐は考えてますか？",
    created_at: "2025-8-6 13:01:12 +0900".to_datetime
  },
  {
    user_id:    User.find_by(name: "コハル").id,
    event_id:   Event.find_by(name: event_11).id,
    content:    "個人的には狐もウェルカムです",
    created_at: "2025-8-7 12:51:10 +0900".to_datetime
  },
  {
    user_id:    User.find_by(name: "NAGISA").id,
    event_id:   Event.find_by(name: event_11).id,
    content:    "ありがとうございます。当日はよろしく。",
    created_at: "2025-8-16 17:41:14 +0900".to_datetime
  },
  {
    user_id:    User.find_by(name: "Yoshida").id,
    event_id:   Event.find_by(name: event_21).id,
    content:    "近くに黒いパソコンはありますか？そこで第１会議室の場所を調べることはできますか？",
    created_at: "2025-9-10 11:28:16 +0900".to_datetime
  },
  {
    user_id:    User.find_by(name: "ハルト").id,
    event_id:   Event.find_by(name: event_21).id,
    content:    "既に開示されている情報ですが改めて調べますか？",
    created_at: "2025-9-11 10:24:40 +0900".to_datetime
  },
  {
    user_id:    User.find_by(name: "NAGISA").id,
    event_id:   Event.find_by(name: event_21).id,
    content:    "これは間違いなく幸福な市民ですね",
    created_at: "2025-9-20 18:35:36 +0900".to_datetime
  },
  {
    user_id:    User.find_by(name: "木木").id,
    event_id:   Event.find_by(name: event_21).id,
    content:    "死",
    created_at: "2025-9-20 20:40:32 +0900".to_datetime
  },
]

comments.each do |comment|
  unless Comment.find_by(user_id: comment[:user_id], event_id: comment[:event_id], content: comment[:content])
    comment = Comment.new(comment)
    comment.score = Language.get_data(comment.content)
    comment.save(touch: false)
  end
end

puts "Group 登録中..."

groups = [
  {
    user_id:      User.find_by(name: "コハル").id,
    name:         "おおかみ組合",
    introduction: "狼側が好きな人のグループ\r\nですけど人狼好きならどなたでもどうぞ"
  },
  {
    user_id:      User.find_by(name: "ハルト").id,
    name:         "エンジョイ！T・R・P・G！",
    introduction: "エンジョイ勢TRPG好き\r\nゲーマスメインでもプレイヤーメインでも\r\nとりあえずグループ入ってみてもどうぞ"
  }
]

groups.each do |group|
  Group.find_or_create_by(user_id: group[:user_id], name: group[:name], introduction: group[:introduction])
end

puts "Member 登録中..."

group_01 = "おおかみ組合"
group_02 = "エンジョイ！T・R・P・G！"

members = [
  {
    user_id:  User.find_by(name: "NAGISA").id,
    group_id: Group.find_by(name: group_01).id
  },
  {
    user_id:  User.find_by(name: "Yoshida").id,
    group_id: Group.find_by(name: group_02).id
  },
  {
    user_id:  User.find_by(name: "陽詩").id,
    group_id: Group.find_by(name: group_02).id
  },
  {
    user_id:  User.find_by(name: "日葵").id,
    group_id: Group.find_by(name: group_02).id
  },
  {
    user_id:  User.find_by(name: "NAGISA").id,
    group_id: Group.find_by(name: group_02).id
  }
]

members.each do |member|
  Member.find_or_create_by(user_id: member[:user_id], group_id: member[:group_id])
end

puts "seed 登録完了"