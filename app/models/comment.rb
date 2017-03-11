# == Schema Information
#
# Table name: comments
#
#  id         :integer          not null, primary key
#  body       :text
#  user_name  :string
#  event_id   :integer
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_comments_on_event_id  (event_id)
#  index_comments_on_user_id   (user_id)
#

# (с) goodprogrammer.ru
#
# Модель Коммента
class Comment < ActiveRecord::Base
  belongs_to :event
  belongs_to :user

  validates  :event, presence: true
  validates :body, presence: true

  # поле должно быть, только если не выполняется user.present? (у объекта на задан юзер)
  validates :user_name, presence: true, unless: 'user.present?'


  # переопределяем метод, если есть юзер, выдаем его имя,
  # если нет -- дергаем исходный переопределенный метод
  def user_name
    if user.present?
      user.name
    else
      super
    end
  end
end
