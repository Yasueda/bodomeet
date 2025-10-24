RSpec.describe 'Eventモデルのテスト', type: :model do
  describe 'バリデーションのテスト' do
    subject { event.valid? }

    let!(:other_event) { create(:event) }
    let(:event) { build(:event) }

    context 'nameカラム' do
      it '空欄でないこと' do
        event.name = ''
        is_expected.to eq false
      end
      it '30文字以下であること: 30文字は〇' do
        event.name = Faker::Lorem.characters(number: 30)
        is_expected.to eq true
      end
      it '30文字以下であること: 31文字は×' do
        event.name = Faker::Lorem.characters(number: 31)
        is_expected.to eq false
      end
      it '一意性があること' do
        event.name = other_event.name
        is_expected.to eq false
      end
    end

    context 'introductionカラム' do
      it '200文字以下であること: 200文字は〇' do
        event.introduction = Faker::Lorem.characters(number: 200)
        is_expected.to eq true
      end
      it '200文字以下であること: 201文字は×' do
        event.introduction = Faker::Lorem.characters(number: 201)
        is_expected.to eq false
      end
    end

    context 'dateカラム' do
      it '空欄でないこと' do
        event.date = ''
        is_expected.to eq false
      end
    end

    context 'check_since_date' do
      it 'date < Time.current.since(1.days): ×' do
        event.date = Time.current
        is_expected.to eq false
      end
      it 'date == Time.current.since(1.days): 〇' do
        event.date = Time.current.since(1.days)
        is_expected.to eq true
      end
      it 'date > Time.current.since(1.days): 〇' do
        event.date = Time.current.since(2.days)
        is_expected.to eq true
      end
    end

    context 'start_timeカラム' do
      it '空欄でないこと' do
        event.start_time = ''
        is_expected.to eq false
      end
    end

    context 'end_timeカラム' do
      it '空欄でないこと' do
        event.end_time = ''
        is_expected.to eq false
      end
    end

    context 'check_time' do
      it 'start_time < end_time: 〇' do
        event.start_time = "10:00"
        event.end_time = "12:00"
        is_expected.to eq true
      end
      it 'start_time == end_time: ×' do
        event.start_time = "10:00"
        event.end_time = "10:00"
        is_expected.to eq false
      end
      it 'start_time > end_time: ×' do
        event.start_time = "12:00"
        event.end_time = "10:00"
        is_expected.to eq false
      end
    end

    context 'venueカラム' do
      it '空欄でないこと' do
        event.venue = ''
        is_expected.to eq false
      end
    end

    context 'min_peopleカラム' do
      it '空欄でないこと' do
        event.min_people = ''
        is_expected.to eq false
      end
    end

    context 'max_peopleカラム' do
      it '空欄でないこと' do
        event.max_people = ''
        is_expected.to eq false
      end
    end

    context 'check_people' do
      it 'min_people < max_people: 〇' do
        event.min_people = 4
        event.max_people = 5
        is_expected.to eq true
      end
      it 'min_people == max_people: 〇' do
        event.min_people = 4
        event.max_people = 4
        is_expected.to eq true
      end
      it 'min_people > max_people: ×' do
        event.min_people = 5
        event.max_people = 4
        is_expected.to eq false
      end
    end
  end

  describe 'アソシエーションのテスト' do
    context 'Participantモデルとの関係' do
      it '1:Nとなっている' do
        expect(Event.reflect_on_association(:participants).macro).to eq :has_many
      end
    end

    context 'Favoriteモデルとの関係' do
      it '1:Nとなっている' do
        expect(Event.reflect_on_association(:favorites).macro).to eq :has_many
      end
    end

    context 'Commentモデルとの関係' do
      it '1:Nとなっている' do
        expect(Event.reflect_on_association(:comments).macro).to eq :has_many
      end
    end
  end
end
