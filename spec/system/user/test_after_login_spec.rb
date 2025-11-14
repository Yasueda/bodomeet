require 'rails_helper'

describe 'ログインしている場合' do
  let!(:user) { create(:user) }
  let!(:other_user) { create(:user) }
  let!(:event) { create(:event, user: user) }
  let!(:other_event) { create(:event, user: other_user) }
  let!(:comment) { create(:comment, user: user, event: event)}
  let!(:other_comment) { create(:comment, user: other_user, event: event)}

  before do
    visit new_user_session_path
    fill_in 'user[name]', with: user.name
    fill_in 'user[password]', with: user.password
    click_button 'ログイン'
  end

  describe '自分が投稿したイベントの詳細画面' do
    before do
      visit event_path(event)
    end

    context 'コメントのテスト' do
      it 'コメント入力フォームが表示される' do
        expect(page).to have_field 'comment[content]'
      end
      it '正しく表示される' do
        expect(page).to have_content comment.content
        expect(page).to have_content other_comment.content
      end
      it 'コメントボタンが存在する' do
        expect(page).to have_css '#comment-button'
      end

      context 'コメント操作' do
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

        context 'コメント削除' do
          before do
            @comment_id = Comment.last.id.to_s
            @event_id = Comment.last.event.id.to_s
            find('#del-comment' + @comment_id).click
          end
          it '正しく削除される' do
            expect(Comment.where(id: @comment_id, is_active: true).count).to eq 0
          end
          it 'リダイレクト先が、コメントを削除した投稿の詳細画面になっている' do
            expect(current_path).to eq '/events/' + @event_id
          end
        end
        
  
      end

    end
  end
end