require 'rails_helper'

include Warden::Test::Helpers
Warden.test_mode!

describe "Sign In/Out Flow" do
  
  before do
    @user = create(:user)
  end
  
  context "sign in" do  
  
    describe "successfully" do
      it "creates user session and recognizes user" do
        visit root_path
        click_link('Sign In')
        expect(current_path).to eq(new_user_session_path)
        
        fill_in 'Email', with: @user.email
        fill_in 'Password', with: @user.password
        
        click_button('Log in')
        
        expect(page).to have_content("Hello #{@user.username}")
        expect(page).to have_content("Signed in successfully.")
      end
    end
    
    describe "unsuccessfully" do
      it "displays error" do
        visit new_user_session_path
        
        fill_in 'Email', with: @user.email
        fill_in 'Password', with: "22222222"
        
        click_button('Log in')
        
        expect(current_path).to eq(user_session_path)
        expect(page).to have_content("Invalid email or password.")
      end
    end
    
  end
  
  context "sign out" do
    
    describe "successfully" do
      it "destroys session and returns user to root path" do
        login_as(@user, scope: :user)      
        visit root_path
        
        click_link("Sign Out")
        
        expect(page).to have_content("Signed out successfully.")
        expect(page).to have_no_content("Hello #{@user.username}")
        expect(current_path).to eq(root_path)
      end
    end
 
  end
  
  
  describe "password change" do
    it "changes password and displays success notice" do
      login_as(@user, scope: :user) 
      visit root_path
     
      click_link(@user.username)
      expect(current_path).to eq(edit_user_registration_path)
     
      fill_in 'Email', with: @user.email
      fill_in 'Password', with: "987654321"
      fill_in 'Password confirmation', with: "987654321"
      fill_in 'Current password', with: @user.password
     
      click_button('Update')
     
      expect(page).to have_content("Your account has been updated successfully.")
     
      # Second part of spec checks that new password works in re-login
      click_link('Sign Out')
      click_link('Sign In')
     
      fill_in 'Email', with: @user.email
      fill_in 'Password', with: "987654321"
     
      click_button('Log in')
     
      expect(page).to have_content("Hello #{@user.username}")
      expect(page).to have_content("Signed in successfully.")
    end
  end
  
      
end
Warden.test_reset!