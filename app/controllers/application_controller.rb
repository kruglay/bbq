class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # настройка для работы девайза при правке профиля юзера
  before_action :configure_permitted_parameters, if: :devise_controller?

  # хелпер метод, доступный во вьюхах
  helper_method :current_user_can_edit?

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(
      :account_update,
      keys: [:password, :password_confirmation, :current_password]
    )
  end

  # показывает может ли текущий залогиненный юзер править эту модель
  # обновили метод - теперь на вход принимаем event, или "дочерние" объекты
  def current_user_can_edit?(model)
    user_signed_in? &&
      (model.user == current_user || # если у модели есть юзер и он залогиненный
        # пробуем у модели взять .event и если он есть, проверяем его юзера
        (model.try(:event).present? && model.event.user == current_user))
  end

  def reject_user
    redirect_to user_path(current_user), I18n.t('controllers.users.reject_message')
  end

  def notify_subscribers(event, notification)
    # собираем всех подписчиков и автора события в массив мэйлов, исключаем повторяющиеся
    all_emails = (event.subscriptions.map{|s| s.user_name if notification.user.nil? || s.user != notification.user} + [event.user.email]).compact

    # XXX: Этот метод может выполняться долго из-за большого числа подписчиков
    # поэтому в реальных приложениях такие вещи надо выносить в background задачи!
    all_emails.each do |mail|
      method_name = notification.class.name.downcase
      EventMailer.public_send(method_name, event, notification, mail).deliver_now
    end
  end
end
