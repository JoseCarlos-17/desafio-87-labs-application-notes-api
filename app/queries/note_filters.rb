class NoteFilters
  def initialize(params)
    @params = params
  end

  def call
    notes = Note.all.order(created_at: :desc)

    notes = by_title(notes) if @params[:title].present?

    notes
  end

  private

  def by_title(notes)
    notes.where("LOWER(title) = LOWER(?)", @params[:title])
  end
end