# frozen_string_literal: true

require 'rails_helper'

describe 'トップ画面(root_path)のテスト' do
  before do
    visit root_path
  end

  context '表示の確認' do
    it 'root_pathが"/"であるか' do
      expect(current_path).to eq '/'
    end
    it 'rootのリンクが存在するか' do
      expect(page).to have_link "", href: root_path
    end
    it 'aboutのリンクが表示されているか' do
      expect(page).to have_link "あばうと", href: about_path
    end
    it 'ゲストログインのリンクが表示されているか' do
      expect(page).to have_link "ゲストログイン", href: users_guest_sign_in_path
    end
    it 'ログインのリンクが表示されているか' do
      expect(page).to have_link "ログイン", href: new_user_session_path
    end
    it '新規登録のリンクが表示されているか' do
      expect(page).to have_link "新規登録", href: new_user_registration_path
    end
  end

  describe 'about画面のテスト' do
    before do
      visit about_path
    end

    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/about'
      end
    end
  end
end