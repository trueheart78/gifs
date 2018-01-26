FactoryBot.define do
  factory :shared_link, aliases: [:link], class: Gifs::Models::SharedLink do
    association :gif, factory: :existing_gif
    dropbox_id 'string'
    remote_path 's/1234567890abc/'
  end
end
