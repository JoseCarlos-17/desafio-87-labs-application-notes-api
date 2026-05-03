require 'rails_helper'

RSpec.describe Note, type: :model do
  context 'columns' do
    it { should have_db_column(:title).of_type(:string) }
    it { should have_db_column(:content).of_type(:string) }
  end

  context 'validations' do
    it { should validate_presence_of(:title) }
    it { should validate_length_of(:title).is_at_least(5).is_at_most(50) }
  end
end
