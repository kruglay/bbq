# == Schema Information
#
# Table name: subscriptions
#
#  id         :integer          not null, primary key
#  user_name  :string
#  user_email :string
#  event_id   :integer
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_subscriptions_on_event_id  (event_id)
#  index_subscriptions_on_user_id   (user_id)
#

# (с) goodprogrammer.ru
#
# Модель Подписки
class Subscription < ActiveRecord::Base
  belongs_to :event
  belongs_to :user

  validates :event, presence: true

  # проверки выполняются только если user не задан (незареганные приглашенные)
  validates :user_name, presence: true, unless: 'user.present?'
  validates :user_email, presence: true, format: /\A[a-zA-Z0-9\-_.]+@[a-zA-Z0-9\-_.]+\z/, unless: 'user.present?'
  validate :user_email_exist, unless: 'user.present?'
  # для данного event_id один юзер может подписаться только один раз (если юзер задан)
  validates :user, uniqueness: {scope: :event_id}, if: 'user.present?'

  # для данного event_id один email может использоваться только один раз (если нет юзера, анонимная подписка)
  validates :user_email, uniqueness: {scope: :event_id}, unless: 'user.present?'

  validate :event_belong_to_current_user
  # переопределяем метод, если есть юзер, выдаем его имя,
  # если нет -- дергаем исходный переопределенный метод
  def user_name
    if user.present?
      user.name
    else
      super
    end
  end

  # переопределяем метод, если есть юзер, выдаем его email,
  # если нет -- дергаем исходный переопределенный метод
  def user_email
    if user.present?
      user.email
    else
      super
    end
  end

  private

  def user_email_exist
    errors.add(:user_email, :taken) if User.exists?(email: user_email)
  end

  def event_belong_to_current_user
    if event.user == user
      errors.add(:empty, :owner)
    end
  end
end
