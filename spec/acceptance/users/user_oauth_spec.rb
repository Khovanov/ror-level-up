require_relative '../acceptance_helper'

feature 'OAuth sign in' do

  before do 
    visit root_path
    click_on 'Log in'
  end

  describe 'User sign in with Facebook' do
    scenario 'with valid credentials' do
      # OmniAuth.config.add_mock(:facebook, {uid: '123456',  info: { email: 'new@user.com' }})
      mock_auth_hash :facebook, 'new@user.com'
      click_on 'Sign in with Facebook'
      expect(page).to have_content 'Successfully authenticated from Facebook account.'
    end

    scenario 'with invalid credentials' do
      # OmniAuth.config.mock_auth[provider] = :invalid_credentials
      mock_auth_invalid :facebook
      click_on 'Sign in with Facebook'
      expect(page).to have_content 'invalid credentials'
      expect(current_path).to eq new_user_session_path
    end
  end

  describe 'User sign in with Twitter' do
    scenario 'with valid credentials' do
      mock_auth_hash :twitter
      click_on 'Sign in with Twitter'
      expect(page).to have_content 'Enter you email for confirmation'
      fill_in 'auth_info_email', with: 'new@user.com'
      # fill_in 'auth[info][email]', with: 'new@user.com'
      click_on 'Submit'
      expect(page).to have_content 'Successfully authenticated from Twitter account.'
    end

    scenario 'with invalid credentials' do
      mock_auth_invalid :twitter
      click_on 'Sign in with Twitter'
      expect(page).to have_content 'invalid credentials'
      expect(current_path).to eq new_user_session_path
    end
  end
end
