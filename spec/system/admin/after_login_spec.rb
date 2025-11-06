require 'rails_helper'

describe '管理者ログインしている場合' do
  let!(:admin) { create(:admin) }
  let!(:user) { create(:user) }
  let!(:other_user) { create(:user) }
  let!(:event) { create(:event, user: user) }
  let!(:other_event) { create(:event, user: other_user) }

  before do
    visit new_admin_session_path
    fill_in 'admin[email]', with: admin.email
    fill_in 'admin[password]', with: admin.password
    click_button 'ログイン'
  end
    
  context 'ヘッダー表示内容の確認' do
    it 'ぼどみぃとリンクが表示される: 左上から1番目のリンクが「ぼどみぃと」である（サイトタイトル）' do
      home_link = find_all('a')[0].text
      expect(home_link).to match("ぼどみぃと")
    end
    it 'ユーザー管理リンクが表示される: 左上から2番目のリンクが「ユーザー管理」である' do
      mypage_link = find_all('a')[1].text
      expect(mypage_link).to match("ユーザー管理")
    end
    it 'イベント管理リンクが表示される: 左上から3番目のリンクが「イベント管理」である' do
      users_link = find_all('a')[2].text
      expect(users_link).to match("イベント管理")
    end
    it 'コメント管理リンクが表示される: 左上から4番目のリンクが「コメント管理」である' do
      events_link = find_all('a')[3].text
      expect(events_link).to match("コメント管理")
    end
    it 'グループ管理リンクが表示される: 左上から5番目のリンクが「グループ管理」である' do
      logout_link = find_all('a')[4].text
      expect(logout_link).to match("グループ管理")
    end
    it 'ログアウトリンクが表示される: 左上から6番目のリンクが「ログアウト」である' do
      logout_link = find_all('a')[5].text
      expect(logout_link).to match("ログアウト")
    end

    context 'リンク内容を確認' do
      subject { current_path }

      it 'ユーザー管理を押すと、ユーザー一覧画面に遷移する' do
        admin_users_link = find_all('a')[1].text
        admin_users_link = admin_users_link.gsub(/\n/, '').gsub(/\A\s*/, '').gsub(/\s*\Z/, '')
        click_link admin_users_link
        is_expected.to eq '/admin/users'
      end
      it 'イベント管理を押すと、イベント一覧画面に遷移する' do
        admin_events_link = find_all('a')[2].text
        admin_events_link = admin_events_link.gsub(/\n/, '').gsub(/\A\s*/, '').gsub(/\s*\Z/, '')
        click_link admin_events_link
        is_expected.to eq '/admin/events'
      end
      it 'コメント管理を押すと、コメント一覧画面に遷移する' do
        admin_comments_link = find_all('a')[3].text
        admin_comments_link = admin_comments_link.gsub(/\n/, '').gsub(/\A\s*/, '').gsub(/\s*\Z/, '')
        click_link admin_comments_link
        is_expected.to eq '/admin/comments'
      end
      it 'グループ管理を押すと、グループ一覧画面に遷移する' do
        admin_groups_link = find_all('a')[4].text
        admin_groups_link = admin_groups_link.gsub(/\n/, '').gsub(/\A\s*/, '').gsub(/\s*\Z/, '')
        click_link admin_groups_link
        is_expected.to eq '/admin/groups'
      end
    end
  end

  describe 'イベント一覧画面のテスト' do
    before do
      visit admin_events_path
    end
    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/admin/events'
      end
      it 'イベントの名前のリンク先が正しい' do
        expect(page).to have_link event.name, href: admin_event_path(event)
        expect(page).to have_link other_event.name, href: admin_event_path(other_event)
      end
    end
  end

  describe 'イベントの詳細画面' do
    before do
      visit admin_event_path(event)
    end

    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/admin/events/' + event.id.to_s
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
        expect(page).to have_link user.name, href: admin_user_path(user)
      end
      it '編集リンクが存在する' do
        expect(page).to have_link '編集', href: edit_admin_event_path(event)
      end
      it '有効/無効リンクが存在する' do
        expect(page).to have_link '', href: active_switch_admin_event_path(event)
      end
      it '編集画面に遷移する' do
        click_link '編集'
        expect(current_path).to eq edit_admin_event_path(event)
      end
    end

    context '削除リンクのテスト' do
      before do
        click_link '削除'
      end
      it '正しく削除される' do
        expect(Event.where(id: event.id).count).to eq 0
      end
      it 'リダイレクト先が、イベント一覧になっている' do
        expect(current_path).to eq '/admin/events'
      end
    end
  end

  describe 'イベントの編集画面のテスト' do
    before do
      visit edit_admin_event_path(event)
    end

    context '表示の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/admin/events/' + event.id.to_s + '/edit'
      end
      it '画像編集フォームが表示される' do
        expect(page).to have_field 'event[event_image]'
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
      context '有効/無効ラジオボタンが表示される' do
        it '有効ボタンがセレクトされている（デフォルト）' do
          expect(page).to have_checked_field '有効'
        end
        it '無効ボタンがセレクトされていない（デフォルト）' do
          expect(page).to have_unchecked_field '無効'
        end
      end
    end

    context '編集成功のテスト' do
      before do
        @event_old_name = event.name
        @event_old_introduction = event.introduction
        fill_in 'event[name]', with: Faker::Lorem.characters(number: 10)
        fill_in 'event[introduction]', with: Faker::Lorem.characters(number: 20)
        click_button '決定'
      end

      it 'nameが正しく更新される' do
        expect(event.reload.name).not_to eq @event_old_name
      end
      it 'introductionが正しく更新される' do
        expect(event.reload.introduction).not_to eq @event_old_introduction
      end
      it 'リダイレクト先が、更新したイベントの詳細画面になっている' do
        expect(current_path).to eq '/admin/events/' + event.id.to_s
      end
    end

    context 'イベント無効化のテスト' do
      before do
        choose '無効'
        click_button '決定'
      end

      it '有効なイベントは存在しない' do
        expect(Event.where(id: event.id, is_active: true).count).to eq 0
      end
      it '無効なイベントは存在する' do
        expect(Event.where(id: event.id, is_active: false).count).to eq 1
      end
    end

    context 'イベント有効化のテスト' do
      before do
        choose '無効'
        click_button '決定'
        visit edit_admin_event_path(event)
        choose '有効'
        click_button '決定'
      end

      it '有効なイベントは存在する' do
        expect(Event.where(id: event.id, is_active: true).count).to eq 1
      end
      it '無効なイベントは存在しない' do
        expect(Event.where(id: event.id, is_active: false).count).to eq 0
      end
    end

  end
end

describe '管理者ログアウトのテスト' do
  let(:admin) { create(:admin) }

  before do
    visit new_admin_session_path
    fill_in 'admin[email]', with: admin.email
    fill_in 'admin[password]', with: admin.password
    click_button 'ログイン'
    logout_link = find_all('a')[5].text
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