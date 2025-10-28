require 'rails_helper'

describe 'ログインしている場合' do
  let!(:user) { create(:user) }
  let!(:other_user) { create(:user) }
  let!(:event) { create(:event, user: user) }
  let!(:other_event) { create(:event, user: other_user) }

  before do
    visit new_user_session_path
    fill_in 'user[name]', with: user.name
    fill_in 'user[password]', with: user.password
    click_button 'ログイン'
  end

  context 'ヘッダー表示内容の確認' do
    it 'ぼどみぃとリンクが表示される: 左上から1番目のリンクが「ぼどみぃと」である（サイトタイトル）' do
      home_link = find_all('a')[0].text
      expect(home_link).to match("ぼどみぃと")
    end
    it 'マイページリンクが表示される: 左上から2番目のリンクが「マイページ」である' do
      mypage_link = find_all('a')[1].text
      expect(mypage_link).to match("マイページ")
    end
    it 'ユーザーリンクが表示される: 左上から3番目のリンクが「ユーザー」である' do
      users_link = find_all('a')[2].text
      expect(users_link).to match("ユーザー")
    end
    it 'イベントリンクが表示される: 左上から4番目のリンクが「イベント」である' do
      events_link = find_all('a')[3].text
      expect(events_link).to match("イベント")
    end
    it 'ログアウトリンクが表示される: 左上から5番目のリンクが「ログアウト」である' do
      logout_link = find_all('a')[4].text
      expect(logout_link).to match("ログアウト")
    end

    context 'リンクの内容を確認' do
      subject { current_path }

      it 'マイページを押すと、自分のユーザ詳細画面に遷移する' do
        mypage_link = find_all('a')[1].text
        mypage_link = mypage_link.gsub(/\n/, '').gsub(/\A\s*/, '').gsub(/\s*\Z/, '')
        click_link mypage_link
        is_expected.to eq '/users/' + user.id.to_s
      end
      it 'ユーザーを押すと、ユーザ一覧画面に遷移する' do
        users_link = find_all('a')[2].text
        users_link = users_link.gsub(/\n/, '').gsub(/\A\s*/, '').gsub(/\s*\Z/, '')
        click_link users_link
        is_expected.to eq '/users'
      end
      it 'イベントを押すと、投稿一覧画面に遷移する' do
        events_link = find_all('a')[3].text
        events_link = events_link.gsub(/\n/, '').gsub(/\A\s*/, '').gsub(/\s*\Z/, '')
        click_link events_link
        is_expected.to eq '/events'
      end
    end
  end

  describe 'イベント一覧画面のテスト' do
    before do
      visit events_path
    end
    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/events'
      end
      it 'イベントの名前のリンク先が正しい' do
        expect(page).to have_link event.name, href: event_path(event)
        expect(page).to have_link other_event.name, href: event_path(other_event)
      end
    end
  end

  describe 'イベント投稿' do
    before do
      visit new_event_path
    end
    before do
      fill_in 'event[name]', with: Faker::Lorem.characters(number: 10)
      fill_in 'event[date]', with: Faker::Date.in_date_period(month: (Time.current.month + 1))
      fill_in 'event[introduction]', with: Faker::Lorem.characters(number: 20)
      fill_in 'event[start_time]', with: '13:00'
      fill_in 'event[end_time]', with: '18:00'
      fill_in 'event[venue]', with: 'XX県XX市XX町XX-XX-XX'
      select 4, from: 'event[min_people]'
      select 8, from: 'event[max_people]'
    end

    it '自分の新しい投稿が正しく保存される' do
      expect { click_button '決定' }.to change(user.events, :count).by(1)
    end
    it 'リダイレクト先が、保存できた投稿の詳細画面になっている' do
      click_button '決定'
      expect(current_path).to eq '/events/' + Event.last.id.to_s
    end
  end

  describe '自分が投稿したイベントの詳細画面' do
    before do
      visit event_path(event)
    end

    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/events/' + event.id.to_s
      end
      it 'イベントの名前が表示されている' do
        expect(page).to have_content event.name
      end
      it 'イベントの説明が表示されている' do
        expect(page).to have_content event.introduction
      end
      it 'イベントの日付が表示されている' do
        expect(page).to have_content event.date.strftime("%m月%d日")
      end
      it 'イベントの開始時間が表示されている' do
        expect(page).to have_content event.start_time.strftime("%H:%M")
      end
      it 'イベントの終了時間が表示されている' do
        expect(page).to have_content event.end_time.strftime("%H:%M")
      end
      it 'イベントの場所が表示されている' do
        expect(page).to have_content event.venue
      end
      it 'イベントの最小人数が表示されている' do
        expect(page).to have_content event.min_people
      end
      it 'イベントの最大人数が表示されている' do
        expect(page).to have_content event.max_people
      end
      it 'イベントの主催者名が表示されている' do
        expect(page).to have_content event.user.name
      end
      it 'イベントの主催者へのリンクが存在する' do
        expect(page).to have_link user.name, href: user_path(user)
      end
      it '編集リンクが存在する' do
        expect(page).to have_link '編集', href: edit_event_path(event)
      end
      it '編集画面に遷移する' do
        click_link '編集'
        expect(current_path).to eq edit_event_path(event)
      end
    end

    context '削除リンクのテスト' do
      before do
        click_link '削除'
      end
      it '正しく削除される' do
        expect(Event.where(id: event.id, is_active: true).count).to eq 0
      end
      it 'リダイレクト先が、イベント一覧になっている' do
        expect(current_path).to eq '/events'
      end
    end
  end

  describe '自分が投稿したイベントの編集画面のテスト' do
    before do
      visit edit_event_path(event)
    end

    context '表示の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/events/' + event.id.to_s + '/edit'
      end
      it 'name編集フォームが表示される' do
        expect(page).to have_field 'event[name]', with: event.name
      end
      it 'introduction編集フォームが表示される' do
        expect(page).to have_field 'event[introduction]', with: event.introduction
      end
      it 'date編集フォームが表示される' do
        expect(page).to have_field 'event[date]', with: event.date
      end
      it 'start_time編集フォームが表示される' do
        expect(page).to have_field 'event[start_time]', with: '13:00:00.000'
      end
      it 'end_time編集フォームが表示される' do
        expect(page).to have_field 'event[end_time]', with: '18:00:00.000'
      end
      it 'venue編集フォームが表示される' do
        expect(page).to have_field 'event[venue]', with: event.venue
      end
      it 'min_people編集フォームが表示される' do
        expect(page).to have_field 'event[min_people]', with: event.min_people
      end
      it 'max_people編集フォームが表示される' do
        expect(page).to have_field 'event[max_people]', with: event.max_people
      end
    end

    context '編集成功のテスト' do
      before do
        @event_old_name = event.name
        @evnet_old_introduction = event.introduction
        fill_in 'event[name]', with: Faker::Lorem.characters(number: 10)
        fill_in 'event[introduction]', with: Faker::Lorem.characters(number: 20)
        click_button '決定'
      end

      it 'nameが正しく更新される' do
        expect(event.reload.name).not_to eq @event_old_name
      end
      it 'introductionが正しく更新される' do
        expect(event.reload.introduction).not_to eq @evnet_old_introduction
      end
      it 'リダイレクト先が、更新したイベントの詳細画面になっている' do
        expect(current_path).to eq '/events/' + event.id.to_s
      end
    end
  end
end

describe 'ユーザーログアウトのテスト' do
  let(:user) { create(:user) }

  before do
    visit new_user_session_path
    fill_in 'user[name]', with: user.name
    fill_in 'user[password]', with: user.password
    click_button 'ログイン'
    logout_link = find_all('a')[4].text
    logout_link = logout_link.gsub(/\n/, '').gsub(/\A\s*/, '').gsub(/\s*\Z/, '')
    click_link logout_link
  end

  context 'ログアウト機能のテスト' do
    it '正しくログアウトできている: ログアウト後のリダイレクト先においてAbout画面へのリンクが存在する' do
      expect(page).to have_link '', href: '/about'
    end
    it 'ログアウト後のリダイレクト先が、トップになっている' do
      expect(current_path).to eq '/'
    end
  end
end