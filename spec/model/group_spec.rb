require 'rails_helper'

RSpec.describe 'Groupモデルのテスト', type: :model do
  describe 'バリデーションのテスト' do
    subject { group.valid? }

    let(:group) { build(:group) }

    context 'nameカラム' do
      it '空欄でないこと' do
        group.name = ''
        is_expected.to eq false
      end
      it '2文字以上であること: 1文字は×' do
        group.name = Faker::Lorem.characters(number: 1)
        is_expected.to eq false
      end
      it '2文字以下であること: 2文字は〇' do
        group.name = Faker::Lorem.characters(number: 2)
        is_expected.to eq true
      end
    end

    context 'introductionカラム' do
      it '200文字以内であること: 200文字は〇' do
        group.introduction = Faker::Lorem.characters(number: 200)
        is_expected.to eq true
      end
      it '200文字以内であること: 201文字は×' do
        group.introduction = Faker::Lorem.characters(number: 201)
        is_expected.to eq false
      end
    end
  end
end
