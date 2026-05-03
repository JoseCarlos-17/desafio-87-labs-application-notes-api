class Notes::Index::NotesSerializer < ActiveModel::Serializer
  attributes :id, :title, :content, :created_at
end
