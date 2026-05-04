class NotesController < ApplicationController
  def index
    notes = NoteFilters.new(params).call

    @pagy, notes = pagy(notes, limit: params[:limit], page: params[:page])

    render json: {
        notes: notes,
        total_pages: @pagy.pages,
        current_page: @pagy.page,
      },
    each_serializer: Notes::Index::NotesSerializer,
    status: :ok
  end

  def create
    new_note = Note.create!(note_params)

    render json: new_note,
           serializer: Notes::Create::NoteSerializer,
           status: :created
  end

  private

  def note_params
    params.require(:note).permit(:title, :content)
  end
end
