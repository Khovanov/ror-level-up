class AttachmentSerializer < ActiveModel::Serializer
  attributes :id, :url, :created_at, :updated_at

  def url
    object.file.url
  end
end