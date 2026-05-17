require 'rails_helper'

RSpec.describe '新規登録フロー', type: :system do
  before do
    driven_by(:rack_test)
  end

  it 'ユーザーが新規登録するとホーム画面に到達できる' do
    visit new_user_registration_path

    fill_in 'メールアドレス', with: 'newuser@example.com'
    fill_in 'パスワード', with: 'password123'
    fill_in 'パスワード確認', with: 'password123'
    click_button '登録する'

    expect(page).to have_current_path(home_path)
  end
end