require_relative 'acceptance_helper'

feature 'User authentication', %q(
  In order to be able to ask question
  As an user
  I want to be able to sign in, sign_out,
  registrations.
) do
  given(:user) { create(:user) } # FactoryGirl.create

  scenario 'Registered user try to sign in' do
    sign_in(user)
    # save_and_open_page

    expect(page).to have_content 'Signed in successfully.'
    expect(current_path).to eq root_path
  end

  scenario 'Non-registered user try to sign in' do
    visit new_user_session_path
    fill_in 'Email', with: 'bad-mail@mail.com'
    fill_in 'Password', with: 'bad-password'

    click_on 'Log in'
    # save_and_open_page

    expect(page).to have_content 'Invalid email or password.'
    expect(current_path).to eq new_user_session_path
  end

  scenario 'Registered user try logout' do
    sign_in(user)

    click_on 'Log out'

    expect(page).to have_content 'Signed out successfully.'
  end

  scenario 'User try to register' do
    visit root_path
    click_on 'Register'

    fill_in 'Email', with: 'test-mail@mail.com'
    fill_in 'Password', with: '12345678', match: :prefer_exact
    fill_in 'Password confirmation', with: '12345678'
    # fill_in 'user_password_confirmation', with: '12345678'

    click_on 'Sign up'

    expect(page).to have_content 'You have signed up successfully.'
  end
end
