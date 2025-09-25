class Event < ApplicationRecord
  belongs_to :user

  has_many :participants, dependent: :destroy
  has_many :participated_users, through: :participants, source: :user

  has_many :comments, dependent: :destroy
  has_many :commented_users, through: :comments, source: :user

  has_many :notifications, dependent: :destroy
  has_many :notified_users, through: :notifications, source: :user

  has_one_attached :event_image
  validates :event_image, content_type: {in:[:jpg, :jpeg], message: "はjpg, jpegいずれかの形式にして下さい"},
  size: { between: 1.kilobyte..4.megabytes , message: '画像容量が大きすぎます、4MB以下にして下さい' }

  validates :name, presence: true, length: {maximum: 30}, uniqueness: { scope: :is_active }
  validates :introduction, length: {maximum: 200}
  validates :date, presence: true
  validates :start_time, presence: true
  validates :end_time, presence: true
  validates :venue, presence: true
  validates :min_people, presence: true
  validates :max_people, presence: true
  validate  :check_people
  validate  :check_date
  validate  :check_time

  scope :asc_date_order, -> { order(date: :asc)}
  scope :desc_date_order, -> { order(date: :desc) }

  scope :asc_datetime_order, -> { sort{ |a, b| a.get_datetime <=> b.get_datetime } }
  scope :desc_datetime_order, -> { sort{ |a, b| b.get_datetime <=> a.get_datetime } }

  scope :get_ago, -> { where("date < ?", Time.zone.today) }
  scope :get_since, -> { where("date >= ?", Time.zone.today) }


  def get_event_image
    unless event_image.attached?
      file_path = Rails.root.join('app/assets/images/events/no_event_image.jpg')
      event_image.attach(io: File.open(file_path), filename: 'event-image.jpeg', content_type: 'image/jpeg')
    end
    event_image
  end

  # 画像をデータベースではなくHTMLを用いて表示する場合
  # def get_event_image
  #   if event_image.attached?
  #     event_image
  #   else
  #     'events/no_event_image.jpg'
  #   end
  # end

  def get_datetime
    date +  start_time.seconds_since_midnight.seconds
  end

  def since_event?
    get_datetime > Time.current.since(1.days)
  end

  private

  def check_people
    return if min_people.nil? || max_people.nil?
    errors.add(:check_people, "を正しく入力してください") if min_people > max_people
  end

  def check_date
    return if date.nil?
    errors.add(:check_since, "の日時を入力してください") if date < Time.current.since(1.days)
  end

  def check_time
    return if start_time.nil? || end_time.nil?
    errors.add(:check_time, "を正しく入力してください") if start_time.seconds_since_midnight > end_time.seconds_since_midnight
  end
end
