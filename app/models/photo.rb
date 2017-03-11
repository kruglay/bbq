# == Schema Information
#
# Table name: photos
#
#  id         :integer          not null, primary key
#  photo      :string
#  event_id   :integer
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_photos_on_event_id  (event_id)
#  index_photos_on_user_id   (user_id)
#

class Photo < ActiveRecord::Base
  # Фотография оставлена к какому-то события
  belongs_to :event

  # Фотографию добавил какой-то пользователь
  belongs_to :user

  # У фотографии всегда есть событие и пользователь
  validates :event, presence: true
  validates :user, presence: true
  validates :photo, presence: true

  # Добавляем аплоадер фотографий, чтобы заработал carrierwave
  mount_uploader :photo, PhotoUploader

  # Этот scope нужен нам, чтобы отделить реальные фотки от болваной
  # см. events_controller
  scope :persisted, -> { where "id IS NOT NULL" }
end
