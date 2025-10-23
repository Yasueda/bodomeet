describe 'ログインしていない場合' do
  before do
    visit root_path
  end

  context '表示内容の確認' do
    it 'ぼどみぃとリンクが表示される: 左上から1番目のリンクが「ぼどみぃと」である（サイトタイトル）' do
      home_link = find_all('a')[0].text
      expect(home_link).to match("ぼどみぃと")
    end
    it 'ほぉむリンクが表示される: 左上から2番目のリンクが「ほぉむ」である' do
      home_link = find_all('a')[1].text
      expect(home_link).to match("ほぉむ")
    end
    it 'あばうとリンクが表示される: 左上から3番目のリンクが「あばうと」である' do
      about_link = find_all('a')[2].text
      expect(about_link).to match("あばうと")
    end
    it '新規登録リンクが表示される: 左上から4番目のリンクが「新規登録」である' do
      signup_link = find_all('a')[3].text
      expect(signup_link).to match("新規登録")
    end
    it 'ログインリンクが表示される: 左上から5番目のリンクが「ログイン」である' do
      login_link = find_all('a')[4].text
      expect(login_link).to match("ログイン")
    end
  end

  context 'リンクの内容を確認' do
    subject { current_path }
    
    it 'ぼどみぃとを押すと、トップ画面に遷移する' do
      home_link = find_all('a')[0].text
      home_link = home_link.delete(' ')
      home_link.gsub!(/\n/, '')
      click_link home_link
      is_expected.to eq '/'
    end
    it 'ほぉむを押すと、トップ画面に遷移する' do
      home_link = find_all('a')[1].text
      home_link = home_link.delete(' ')
      home_link.gsub!(/\n/, '')
      click_link home_link
      is_expected.to eq '/'
    end
    it 'あばうとを押すと、あばうと画面に遷移する' do
      about_link = find_all('a')[2].text
      about_link = about_link.gsub(/\n/, '').gsub(/\A\s*/, '').gsub(/\s*\Z/, '')
      click_link about_link
      is_expected.to eq '/about'
    end
    it '新規登録を押すと、新規登録画面に遷移する' do
      signup_link = find_all('a')[3].text
      signup_link = signup_link.gsub(/\n/, '').gsub(/\A\s*/, '').gsub(/\s*\Z/, '')
      click_link signup_link, match: :first
      is_expected.to eq '/users/sign_up'
    end
    it 'ログインを押すと、ログイン画面に遷移する', spec_category: "ルーティング・URL設定の理解(ログイン状況に合わせた応用)" do
      login_link = find_all('a')[4].text
      login_link = login_link.gsub(/\n/, '').gsub(/\A\s*/, '').gsub(/\s*\Z/, '')
      click_link login_link, match: :first
      is_expected.to eq '/users/sign_in'
    end
  end

  describe 'ユーザ新規登録のテスト' do
    before do
      visit new_user_registration_path
    end

    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/users/sign_up'
      end
      it '「新規登録」と表示される' do
        expect(page).to have_content '新規登録'
      end
      it 'nameフォームが表示される' do
        expect(page).to have_field 'user[name]'
      end
      it 'emailフォームが表示される' do
        expect(page).to have_field 'user[email]'
      end
      it 'passwordフォームが表示される' do
        expect(page).to have_field 'user[password]'
      end
      it 'password_confirmationフォームが表示される' do
        expect(page).to have_field 'user[password_confirmation]'
      end
      it '新規登録ボタンが表示される' do
        expect(page).to have_button '新規登録'
      end
    end

    context '新規登録成功のテスト' do
      before do
        fill_in 'user[name]', with: Faker::Lorem.characters(number: 10)
        fill_in 'user[email]', with: Faker::Internet.email
        fill_in 'user[password]', with: 'password'
        fill_in 'user[password_confirmation]', with: 'password'
      end
  
      it '正しく新規登録される' do
        expect { click_button '新規登録' }.to change(User.all, :count).by(1)
      end
      it '新規登録後のリダイレクト先が、新規登録できたユーザの詳細画面になっている' do
        click_button '新規登録'
        expect(current_path).to eq '/users/' + User.last.id.to_s
      end
    end
  end

  describe 'ユーザログイン' do
    let(:user) { create(:user) }

    before do
      visit new_user_session_path
    end

    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/users/sign_in'
      end
      it '「ログイン」と表示される' do
        expect(page).to have_content 'ログイン'
      end
      it 'nameフォームが表示される' do
        expect(page).to have_field 'user[name]'
      end
      it 'passwordフォームが表示される' do
        expect(page).to have_field 'user[password]'
      end
      it 'ログインボタンが表示される' do
        expect(page).to have_button 'ログイン'
      end
      it 'emailフォームは表示されない' do
        expect(page).not_to have_field 'user[email]'
      end
    end

    context 'ログイン成功のテスト' do
      before do
        fill_in 'user[name]', with: user.name
        fill_in 'user[password]', with: user.password
        click_button 'ログイン'
      end

      it 'ログイン後のリダイレクト先が、ログインしたユーザの詳細画面になっている' do
        expect(current_path).to eq '/users/' + user.id.to_s
      end
    end

    context 'ログイン失敗のテスト' do
      before do
        fill_in 'user[name]', with: ''
        fill_in 'user[password]', with: ''
        click_button 'ログイン'
      end

      it 'ログインに失敗し、ログイン画面にリダイレクトされる' do
        expect(current_path).to eq '/users/sign_in'
      end
    end
  end

end