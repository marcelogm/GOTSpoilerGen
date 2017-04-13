class Person < ActiveRecord::Base
  validates :name, presence: true
  validates :image, presence: true

  has_attached_file :image,:styles => { medium: "400>x400", thumb: "50x50>" },
  :path => 'gsgen_images/:class/:attachment/:id/:style/:hash',
  :hash_secret => ":basename"

  validates_attachment :image,
    content_type: { content_type: ["image/jpeg", "image/gif", "image/png"] }

  def self.search(query)
  	where("name LIKE ?", "%#{query}%")
  end
end
