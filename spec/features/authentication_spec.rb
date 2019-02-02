require 'rails_helper'

feature 'the signup process' do

  scenario 'has a new user page'
  feature 'signing up a user' do

      scenario 'shows username on the homepage after signup' do
        
        visit new_user_path
        expect(page).to have_content("Sign Up")
      end
    end
end