class Notes::Create::NoteSerializer < ActiveModel::Serializer
  attributes :id, :title, :content, :created_at
end
