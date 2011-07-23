require 'carrierwave/orm/mongoid'       

class Kindeditor::Asset
  include Mongoid::Document
  include Mongoid::Timestamps

  validates_presence_of :asset
  before_save :update_asset_attributes
  
  field :asset, :type => String
  field :file_size, :type => Integer
  field :file_type, :type => String

  private

  def update_asset_attributes
    self.file_size = asset.file.size
    self.file_type = asset.file.content_type
  end
end               


