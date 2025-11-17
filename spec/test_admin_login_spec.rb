# RSpec単体動作テスト用（管理者側）

require 'rails_helper'

describe 'ログインしている場合' do
  let!(:admin) { create(:admin) }
  let!(:user) { create(:user) }
  let!(:other_user) { create(:user) }
  let!(:event) { create(:event, user: user) }
  let!(:other_event) { create(:event, user: other_user) }
  let!(:comment) { create(:comment, user: user, event: event)}
  let!(:other_comment) { create(:comment, user: other_user, event: event)}

  before do
    visit new_admin_session_path
    fill_in 'admin[email]', with: admin.email
    fill_in 'admin[password]', with: admin.password
    click_button 'ログイン'
  end

end