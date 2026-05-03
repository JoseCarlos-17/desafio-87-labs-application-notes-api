require 'rails_helper'

RSpec.describe 'Notes', type: :request do
  describe 'GET#index' do
    context 'when the notes are listed' do
      let!(:notes) { create_list(:note, 20) }

      before do
        get '/notes', params: { limit: 10, page: 2 }
      end

      it 'must return 200 status code' do
        expect(response).to have_http_status(:ok)
      end

      it 'must return notes and pagination fields' do
        expect(json_body).to include(:notes, :total_pages, :current_page)
      end

      it 'must return pagination metadata for the request' do
        expect(json_body[:total_pages]).to eq(2)
        expect(json_body[:current_page]).to eq(2)
      end

      it 'must return the first note attributes on the requested page' do
        expect(json_body[:notes][0]).to include(:id, :title, :content, :created_at)
      end
    end
  end

  describe 'POST#create' do
    context 'when a new note is created' do
      let(:new_note) { attributes_for(:note, title: 'new note',
        content: 'new note content') }

      before do
        post '/notes', params: { note: new_note }
      end

      it 'must return 201 status code' do
        expect(response).to have_http_status(:created)
      end

      it 'must return the new note attributes' do
        expect(json_body).to include(:id, :title, :content, :created_at)
      end
    end

    context 'when a invalid data is sended' do
      let(:invalid_note) { attributes_for(:note, title: nil) }

      before do
        post '/notes', params: { note: invalid_note }
      end

      it 'must return 422 status code' do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'must return the error message' do
        expect(json_body).to include(:error)
      end
    end

    context 'when a user try to create a note with a long title' do
      let(:long_title_note) { attributes_for(:note,
        title: 'asdsdasdasdasdasdasdasdasdsdasdasdasdasdasdasdasdasdasdasd') }

      before do
        post '/notes', params: { note: long_title_note }
      end
      
      it 'must return 422 status code' do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'must return the error message' do
        expect(json_body).to include(:error)
      end
    end
  end
end
