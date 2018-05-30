class MigrateAndDropPictures < ActiveRecord::Migration[5.2]
  def change
    Picture.find_each do |picture|
      sighting = picture.sighting
      next if sighting.nil? || sighting.picture.attached?

      extension = picture.content_type.split('/').last

      sighting.picture.attach io: StringIO.new(picture.data),
                              filename: "#{sighting.id}.#{extension}",
                              content_type: picture.content_type
    end

    drop_table :pictures
  end
end
