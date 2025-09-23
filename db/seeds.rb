# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
puts "seed の登録を開始します"

require 'faker'

puts "Admin を登録します"
Admin.find_or_create_by!(email: "admin@example.com") do |admin|
  admin.password = ENV['ADMIN_KEY']
end
puts "Admin を登録しました"

puts "User を登録をします"
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

5.times do
  password = Faker::Alphanumeric.alphanumeric(number: 6)
  user = {
    name:         Faker::Name.unique.first_name,
    email:        Faker::Internet.unique.email,
    introduction: Faker::Lorem.paragraph(sentence_count: 5),
    password:     password,
    is_active:    :fale
  }
  unless User.find_by(name: user[:name], email: user[:email])
    user = User.new(user)
    user.is_active = :false
    user.save
  end
end
puts "User を登録しました"

puts "Event を登録します"
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
    venue:        "東京都台東区東上野２丁目XX−XX",
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
    venue:        "東京都台東区東上野２丁目XX−XX",
    min_people:   "3",
    max_people:   "6",
    event_image:  ActiveStorage::Blob.create_and_upload!(io: File.open(Rails.root.join("app/assets/images/events/paranoia.jpg")),filename: 'event-image.jpg',content_type: 'image/jpg')
  }
]

events.each do |event|
  unless Event.find_by(name: event[:name], is_active: true)
    event = Event.new(event)
    # 過去のイベントも保存するためにバリデーション回避
    event.save(validate: false)
  end
end
puts "Enent を登録しました"

puts "Participant を登録します"
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
  },
]

participants.each do |participant|
  unless Participant.find_by(user_id: participant[:user_id], event_id: participant[:event_id])
    Participant.create!(participant)
  end
end
puts "Participant を登録しました"

puts "Comment を登録します"
comments = [
  {
    user_id:   User.find_by(name: "Suzuki").id,
    event_id:  Event.find_by(name: event_01).id,
    content:   "初プレイですが参加できますか？"
  },
  {
    user_id:   User.find_by(name: "つむぎ").id,
    event_id:  Event.find_by(name: event_01).id,
    content:   "大丈夫です！是非とも参加して下さい！"
  },
  {
    user_id:   User.find_by(name: "Suzuki").id,
    event_id:  Event.find_by(name: event_01).id,
    content:   "ありがとうございます。よろしくお願いします。"
  },
  {
    user_id:   User.find_by(name: "Tanaka").id,
    event_id:  Event.find_by(name: event_02).id,
    content:   "自分でふるよに持ち込んでいい？"
  },
  {
    user_id:   User.find_by(name: "つむぎ").id,
    event_id:  Event.find_by(name: event_02).id,
    content:   "現行シリーズは全て１セットありますので自分のデッキを持ち込みたいのであればお持ち下さい"
  },
  {
    user_id:   User.find_by(name: "Tanaka").id,
    event_id:  Event.find_by(name: event_02).id,
    content:   "マイデッキ持っていきます"
  },
  {
    user_id:   User.find_by(name: "ハルト").id,
    event_id:  Event.find_by(name: event_01).id,
    content:   "参加よろしくおねがいしますー"
  },
  {
    user_id:   User.find_by(name: "NAGISA").id,
    event_id:  Event.find_by(name: event_11).id,
    content:   "これって役職はどうなってます？"
  },
  {
    user_id:  User.find_by(name: "コハル").id,
    event_id:  Event.find_by(name: event_11).id,
    content:   "参加人数によりけりですが、最初に狼２占１狂１あたりでプレイして、その後様子見つつ変えていくつもりです"
  },
  {
    user_id:  User.find_by(name: "NAGISA").id,
    event_id:  Event.find_by(name: event_11).id,
    content:   "狐は考えてますか？"
  },
  {
    user_id:  User.find_by(name: "コハル").id,
    event_id:  Event.find_by(name: event_11).id,
    content:   "個人的には狐もウェルカムです"
  },
  {
    user_id:  User.find_by(name: "NAGISA").id,
    event_id:  Event.find_by(name: event_11).id,
    content:   "ありがとうございます。当日はよろしく。"
  },
  {
    user_id:  User.find_by(name: "Yoshida").id,
    event_id:  Event.find_by(name: event_21).id,
    content:   "近くに黒いパソコンはありますか？そこで第１会議室の場所を調べることはできますか？"
  },
  {
    user_id:  User.find_by(name: "ハルト").id,
    event_id:  Event.find_by(name: event_21).id,
    content:   "既に開示されている情報ですが改めて調べますか？"
  },
  {
    user_id:  User.find_by(name: "NAGISA").id,
    event_id:  Event.find_by(name: event_21).id,
    content:   "草"
  },
]

comments.each do |comment|
  Comment.find_or_create_by(user_id: comment[:user_id], event_id: comment[:event_id], content: comment[:content])
end
puts "Comment を登録しました"

puts "Group を登録します"
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
puts "Group を登録しました"

puts "Member を登録します"
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
puts "Member を登録しました"

puts "正常にseedが全て登録されました"