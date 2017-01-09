class EventMailerPreview < ActionMailer::Preview
  def photo
    event = Event.first
    photo = Photo.first
    EventMailer.photo(event, photo, event.user.email)
  end
end