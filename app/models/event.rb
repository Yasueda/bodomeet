class Event < ApplicationRecord
  belongs_to :user

  has_many :participants, dependent: :destroy
  has_many :participated_users, through: :participants

  has_many :comments, dependent: :destroy
  has_many :commented_users, through: :comments

  has_many :notifications, dependent: :destroy
  has_many :notified_users, through: :notifications

  has_one_attached :event_image

  validates :name, presence: true, length: {minimun: 2, maximum: 20}, uniqueness: true
  validates :introduction, length: {maximum: 200}
  validates :date, presence: true
  validates :end_time, presence: true
  validates :venue, presence: true
  validates :min_people, presence: true
  validates :max_people, presence: true
  validate  :check_people
  validate  :check_time

  def get_image
    unless event_image.attached?
      file_path = Rails.root.join('app/assets/images/no_event_image.png')
      event_image.attach(io: File.open(file_path), filename: 'default-event-image.png', content_type: 'image/png')
    end
    event_image
  end

  private

  def check_people
    return if min_people.nil? || max_people.nil?
    errors.add(:check_people, "を正しく入力してください") if min_people > max_people
  end

  def check_time
    return if date.nil? || end_time.nil?
    errors.add(:check_ago, "後以降の日時を入力してください") if date < Time.current.since(1.days)
    errors.add(:check_time, "を正しく入力してください") if date.strftime("%H:%M") > end_time.strftime("%H:%M")
  end

end
