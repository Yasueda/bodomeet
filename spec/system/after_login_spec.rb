describe 'ログインしている場合' do
  let(:user) { create(:user) }

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