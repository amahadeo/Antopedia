require 'rails_helper'

describe "Sign up flow" do
  
  describe "successful" do
    it "redirects to root page and displays confirmation email message" do
      visit root_path
      click_link('Sign Up')
      expect(current_path).to eq(new_user_registration_path)
      
      fill_in 'Username', with: 'bdoodle'
      fill_in 'Password', with: '123456789'
      fill_in 'Password confirmation', with: '123456789'
      fill_in 'Email', with: 'bobbydoodle@bd.com'
      
      click_button('Sign up')
      expect(current_path).to eq(root_path)
      expect(page).to have_content('A message with a confirmation link has been sent to your email address. Please follow the link to activate your account.')
      
    end
  end
  
  describe "unsuccessful" do
    it "with duplicate email, leaves error message" do
      user = create(:user)
      
      visit new_user_registration_path
      
      fill_in 'Username', with: user.username
      fill_in 'Password', with: user.password
      fill_in 'Password confirmation', with: user.password
      fill_in 'Email', with: user.email
      
      click_button('Sign up')
      expect(current_path).to eq(user_registration_path)
      expect(page).to have_content('Email has already been taken')
    end
    
    it "with invalid email, leaves error message" do
      visit new_user_registration_path
      
      fill_in 'Username', with: 'bdoodle'
      fill_in 'Password', with: '123456789'
      fill_in 'Password confirmation', with: '123456789'
      fill_in 'Email', with: 'bobbydoodle'
      
      click_button('Sign up')
      expect(current_path).to eq(user_registration_path)
    end
      
  end
end