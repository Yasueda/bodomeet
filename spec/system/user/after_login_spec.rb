require 'rails_helper'

describe 'ログインしている場合' do
  let!(:user) { create(:user) }
  let!(:other_user) { create(:user) }
  let!(:event) { create(:event, user: user) }
  let!(:other_event) { create(:event, user: other_user) }
  let!(:comment) { create(:comment, user: user, event: event) }
  let!(:other_comment) { create(:comment, user: other_user, event: event) }
  let!(:group) { create(:group, user: user)}
  let!(:other_group) { create(:group, user: other_user) }

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
      it 'イベントを押すと、イベント一覧画面に遷移する' do
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
      it 'イベントの画像が表示される: 2つの画像が表示される' do
        expect(all('img').size).to eq(2)
      end
      it 'イベントの名前がそれぞれ表示される' do
        expect(page).to have_content event.name
        expect(page).to have_content other_event.name
      end
      it 'イベントの詳細リンク先がそれぞれ表示される' do
        expect(page).to have_link event.name, href: event_path(event)
        expect(page).to have_link other_event.name, href: event_path(other_event)
      end
    end
  end

  describe 'イベント投稿' do
    before do
      visit new_event_path
      fill_in 'event[name]', with: Faker::Lorem.characters(number: 10)
      fill_in 'event[date]', with: Faker::Date.in_date_period(year: (Time.current.year + 1))
      fill_in 'event[introduction]', with: Faker::Lorem.characters(number: 20)
      fill_in 'event[start_time]', with: '13:00'
      fill_in 'event[end_time]', with: '18:00'
      fill_in 'event[venue]', with: 'XX県XX市XX町XX-XX-XX'
      select 4, from: 'event[min_people]'
      select 8, from: 'event[max_people]'
    end

    it 'URLが正しい' do
      expect(current_path).to eq '/events/new'
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
        find('#del-event' + event.id.to_s).click
      end
      it '正しく削除される（論理削除）' do
        expect(Event.where(id: event.id, is_active: true).count).to eq 0
      end
      it 'リダイレクト先が、イベント一覧になっている' do
        expect(current_path).to eq '/events'
      end
    end

    context 'コメントのテスト' do
      it '正しく表示される' do
        expect(page).to have_content comment.content
        expect(page).to have_content other_comment.content
      end
      it 'コメント入力フォームが表示される' do
        expect(page).to have_field 'comment[content]'
      end
      it 'コメントボタンが存在する' do
        expect(page).to have_css '#comment-button'
      end

      context 'コメント追加' do
        before do
          @old_comments = event.comments.count
          fill_in 'comment[content]', with: Faker::Lorem.characters(number: 10)
          find('#comment-button').click
        end

        it '新しいコメントが正しく保存される' do
          expect(event.comments.count).not_to eq @old_comments
        end
        it 'リダイレクト先が、コメントした投稿の詳細画面になっている' do
          expect(current_path).to eq '/events/' + Comment.last.event.id.to_s
        end
        it '新しいコメントが正しく表示されている' do
          expect(page).to have_content Comment.last.content
        end
        it 'コメント削除ボタンが存在する' do
          expect(page).to have_css '#del-comment' + Comment.last.id.to_s
        end
      end

      context 'コメント削除' do
        before do
          @comment_id = comment.id.to_s
          @event_id = comment.event.id.to_s
          find('#del-comment' + @comment_id).click
        end
        it '正しく削除される（論理削除）' do
          expect(Comment.where(id: @comment_id, is_active: true).count).to eq 0
        end
        it 'リダイレクト先が、コメントを削除した投稿の詳細画面になっている' do
          expect(current_path).to eq '/events/' + @event_id
        end
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
    end

    context '編集成功のテスト' do
      before do
        @event_old_name = event.name
        @evnet_old_introduction = event.introduction
        @event_old_date = event.date
        @event_old_start_time = event.start_time
        @event_old_end_time = event.end_time
        @event_old_venue = event.venue
        @event_old_min_people = event.min_people
        @event_old_max_people = event.max_people
        fill_in 'event[name]', with: Faker::Lorem.characters(number: 10)
        fill_in 'event[introduction]', with: Faker::Lorem.characters(number: 20)
        fill_in 'event[date]', with: Faker::Date.in_date_period(year: (Time.current.year + 1))
        fill_in 'event[start_time]', with: '12:00'
        fill_in 'event[end_time]', with: '17:00'
        fill_in 'event[venue]', with: 'YY県YY市YY町YY-YY-YY'
        select 2, from: 'event[min_people]'
        select 6, from: 'event[max_people]'
        click_button '決定'
      end

      it 'nameが正しく更新される' do
        expect(event.reload.name).not_to eq @event_old_name
      end
      it 'introductionが正しく更新される' do
        expect(event.reload.introduction).not_to eq @evnet_old_introduction
      end
      it 'dateが正しく更新される' do
        expect(event.reload.date).not_to eq @event_old_date
      end
      it 'start_timeが正しく更新される' do
        expect(event.reload.start_time).not_to eq @event_old_start_time
      end
      it 'end_timeが正しく更新される' do
        expect(event.reload.end_time).not_to eq @event_old_end_time
      end
      it 'venueが正しく更新される' do
        expect(event.reload.venue).not_to eq @event_old_venue
      end
      it 'min_peopleが正しく更新される' do
        expect(event.reload.min_people).not_to eq @event_old_min_people
      end
      it 'max_peopleが正しく更新される' do
        expect(event.reload.max_people).not_to eq @event_old_max_people
      end
      it 'リダイレクト先が、更新したイベントの詳細画面になっている' do
        expect(current_path).to eq '/events/' + event.id.to_s
      end
    end
  end

  describe 'ユーザー一覧画面のテスト' do
    before do
      visit users_path
    end

    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/users'
      end
      it '自分と他人の画像が表示される: 2つの画像が表示される' do
        expect(all('img').size).to eq(2)
      end
      it '自分と他人の名前がそれぞれ表示される' do
        expect(page).to have_content user.name
        expect(page).to have_content other_user.name
      end
      it '自分と他人の詳細リンクがそれぞれ表示される' do
        expect(page).to have_link user.name, href: user_path(user)
        expect(page).to have_link other_user.name, href: user_path(other_user)
      end
    end
  end

  describe '自分のユーザー詳細画面のテスト' do
    before do
      visit user_path(user)
    end

    context '表示の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/users/' + user.id.to_s
      end
    end

    context '自分のユーザー情報の確認' do
      it '自分の名前と紹介文が表示される' do
        expect(page).to have_content user.name
        expect(page).to have_content user.introduction
      end
      it '自分のユーザー編集画面へのリンクが存在する' do
        expect(page).to have_link '編集', href: edit_users_path
      end
      it '自分の退会画面へのリンクが存在する' do
        expect(page).to have_link '退会', href: unsubscribe_users_path
      end
      it '自分のフォローへのリンクが存在する' do
        expect(page).to have_link 'フォロー', href: followeds_user_path(user)
      end
      it '自分のフォロワーへのリンクが存在する' do
        expect(page).to have_link 'フォロワー', href: followers_user_path(user)
      end
      it '自分の参加グループへのリンクが存在する' do
        expect(page).to have_link '参加グループ', href: groups_user_path(user)
      end
      it '自分のお気に入りイベントへのリンクが存在する' do
        expect(page).to have_link 'お気に入りイベント', href: favorite_events_path
      end
    end

    context 'イベント表示の確認' do
      it '新規イベント作成へのリンクが存在する' do
        expect(page).to have_link '新規作成', href: new_event_path
      end
      it '自分の投稿イベントのnameが表示され、リンクが正しい' do
        expect(page).to have_link event.name, href: event_path(event)
      end
    end
  end

  describe '自分のユーザー情報編集画面のテスト' do
    before do
      visit edit_users_path
    end

    context '表示の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/users/information/edit'
      end
      it '画像編集フォームが表示される' do
        expect(page).to have_field 'user[user_image]'
      end
      it '名前編集フォームに自分の名前が表示される' do
        expect(page).to have_field 'user[name]', with: user.name
      end
      it 'メールアドレス編集フォームに自分のメールアドレスが表示される' do
        expect(page).to have_field 'user[email]', with: user.email
      end
      it '自己紹介編集フォームに自分の自己紹介が表示される' do
        expect(page).to have_field 'user[introduction]', with: user.introduction
      end
      it '更新ボタンが存在する' do
        expect(page).to have_button '更新'
      end
    end

    context '更新成功のテスト' do
      before do
        @user_old_name = user.name
        @user_old_email = user.email
        @user_old_introduction = user.introduction
        fill_in 'user[name]', with: Faker::Lorem.characters(number: 10)
        fill_in 'user[email]', with: Faker::Internet.email
        fill_in 'user[introduction]', with: Faker::Lorem.characters(number: 20)
        expect(user.user_image).to be_attached
        click_button '更新'
        save_page
      end

      it 'nameが正しく更新される' do
        expect(user.reload.name).not_to eq @user_old_name
      end
      it 'emailが正しく更新される' do
        expect(user.reload.email).not_to eq @user_old_email
      end
      it 'introductionが正しく更新される' do
        expect(user.reload.introduction).not_to eq @user_old_introduction
      end
      it 'リダイレクト先が、自分のユーザー詳細画面になっている' do
        expect(current_path).to eq '/users/' + user.id.to_s
      end
    end
  end

  describe 'グループ一覧画面のテスト' do
    before do
      visit groups_path
    end
    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/groups'
      end
      it 'グループの名前がそれぞれ表示される' do
        expect(page).to have_content group.name
        expect(page).to have_content other_group.name
      end
      it 'グループの詳細リンク先がそれぞれ表示される' do
        expect(page).to have_link group.name, href: group_path(group)
        expect(page).to have_link other_group.name, href: group_path(other_group)
      end
    end
  end

  describe 'グループ作成' do
    before do
      visit new_group_path
      fill_in 'group[name]', with: Faker::Lorem.characters(number: 10)
      fill_in 'group[introduction]', with: Faker::Lorem.characters(number: 20)
    end

    it 'URLが正しい' do
      expect(current_path).to eq '/groups/new'
    end
    it 'グループの名前入力フォームが表示される' do
      expect(page).to have_field 'group[name]'
    end
    it 'グループの説明入力フォームが表示される' do
      expect(page).to have_field 'group[introduction]'
    end
    it '自分の新しいグループが正しく保存される' do
      expect { click_button '登録する' }.to change(user.groups, :count).by(1)
    end
    it 'リダイレクト先が、保存できたグループの詳細画面になっている' do
      click_button '登録する'
      expect(current_path).to eq '/groups/' + Group.last.id.to_s
    end
  end

  describe '自身が作成したグループの詳細画面' do
    before do
      visit group_path(group)
    end

    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/groups/' + group.id.to_s
      end
      it 'グループの名前が表示されている' do
        expect(page).to have_content group.name
      end
      it 'グループの説明が表示されている' do
        expect(page).to have_content group.introduction
      end
      it 'グループ作成者の名前が表示されている' do
        expect(page).to have_content group.user.name
      end
      it '編集リンクが存在する' do
        expect(page).to have_link '編集', href: edit_group_path(group)
      end
      it '編集画面に遷移する' do
        click_link '編集'
        expect(current_path).to eq edit_group_path(group)
      end
    end

    describe '自身が作成したグループの編集画面のテスト' do
      before do
        visit edit_group_path(group)
      end

      context '表示の確認' do
        it 'URLが正しい' do
          expect(current_path).to eq '/groups/' + group.id.to_s + '/edit'
        end
        it 'name編集フォームが表示される' do
          expect(page).to have_field 'group[name]'
        end
        it 'introduction編集フォームが表示される' do
          expect(page).to have_field 'group[introduction]'
        end
      end

      context '編集成功のテスト' do
        before do
          @group_old_name = group.name
          @group_old_introduction = group.introduction
          fill_in 'group[name]', with: Faker::Lorem.characters(number: 10)
          fill_in 'group[introduction]', with: Faker::Lorem.characters(number: 20)
          click_button '更新する'
        end

        it 'nameが正しく更新される' do
          expect(group.reload.name).not_to eq @group_old_name
        end
        it 'introductionが正しく更新される' do
          expect(group.reload.introduction).not_to eq @group_old_introduction
        end
      end
    end

    context '削除リンクのテスト' do
      before do
        find('#del-group' + group.id.to_s).click
      end
      it '正しく削除される（論理削除）' do
        expect(Group.where(id: group.id, is_active: true).count).to eq 0
      end
      it 'リダイレクト先が、グループ一覧になっている' do
        expect(current_path).to eq '/groups'
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