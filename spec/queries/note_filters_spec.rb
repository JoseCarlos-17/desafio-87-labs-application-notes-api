require 'rails_helper'

RSpec.describe 'NoteFilters' do
  describe '#call' do
    context 'when title filter have params blank' do
      let!(:note1) { create(:note, title: 'first title') }
      let!(:note2) { create(:note, title: 'second title') }
      let(:params) { { title: '' } }
      let(:service) { NoteFilters.new(params).call }

      before do
        service
      end

      it 'must return all notes' do
        expect(service[0]).to eq(note2)
        expect(service[1]).to eq(note1)
      end
    end

    context 'when title filter does not match any note' do
      let!(:note) { create(:note, title: 'visible title') }
      let(:params) { { title: 'nomatch' } }

      let(:service) { NoteFilters.new(params).call }

      before do
        service
      end

      it 'must return no one note' do
        expect(service.count).to eq(0)
      end
    end

    context 'when the params is all lowercase' do
      let!(:note1) { create(:note, title: 'MyString1') }
      let!(:note2) { create(:note, title: 'MyString2') }
      let(:params) { { title: 'mystring1' } }

      let(:service) { NoteFilters.new(params).call }

      before do
        service
      end

      it 'must return the filtered notes' do
        expect(service[0][:title]).to eq('MyString1')
      end
    end

    context 'when the params is all uppercase' do
      let!(:note1) { create(:note, title: 'MyString1') }
      let!(:note2) { create(:note, title: 'MyString2') }
      let(:params) { { title: 'MYSTRING1' } }

      let(:service) { NoteFilters.new(params).call }

      before do
        service
      end

      it 'must return the filtered notes' do
        expect(service[0][:title]).to eq('MyString1')
      end
    end
  end
end
