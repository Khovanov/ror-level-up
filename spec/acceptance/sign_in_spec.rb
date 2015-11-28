require 'rails_helper'

feature 'User sign in' , %q{
  In order to be able to ask question
  As an user
  I want to be able to sign in
} do

  given(:user) { create(:user) } #FactoryGirl.create

  scenario 'Registered user try to sign in'  do
    sign_in(user)
    # save_and_open_page

    expect(page).to have_content 'Signed in successfully.'
    expect(current_path).to eq root_path
  end

  scenario 'Non-registered user try to sign in'  do
    visit new_user_session_path
    fill_in 'Email', with: 'bad-mail@mail.com'
    fill_in 'Password', with: 'bad-password'

    click_on 'Log in' 
    # save_and_open_page

    expect(page).to have_content 'Invalid email or password.'
    expect(current_path).to eq new_user_session_path
  end
end