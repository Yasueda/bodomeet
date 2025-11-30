require 'rails_helper'

RSpec.describe 'Commentモデルのテスト', type: :model do
  describe 'バリデーションのテスト' do
    subject { comment.valid? }

    let(:comment) { build(:comment) }

    context 'contentカラム' do
      it '空欄でないこと' do
        comment.content = ''
        is_expected.to eq false
      end
      it '100文字以下であること: 100文字は〇' do
        comment.content = Faker::Lorem.characters(number: 100)
        is_expected.to eq true
      end
      it '101文字以下であること: 101文字は×' do
        comment.content = Faker::Lorem.characters(number: 101)
        is_expected.to eq false
      end
    end
  end
end
