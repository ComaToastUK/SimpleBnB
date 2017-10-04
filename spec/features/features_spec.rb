# 1 As a property owner
# So I can rent out my property
# I want to be able to list it on FakersBnB

feature 'list property' do
  scenario 'a property owner wants to list their property' do
    sign_up
    visit '/properties/new'
    fill_in   :title,    with: 'One bedroom flat'
    fill_in   :location, with: 'London'
    fill_in   :price,    with:  150
    fill_in   :imageurl,  with:  'https://i.imgur.com/jFoufpl.jpg'
    click_button 'Submit'
    visit '/properties';
    expect(page).to have_content 'One bedroom flat'
    expect(page).to have_content 'https://i.imgur.com/jFoufpl.jpg'
  end
end

# 2 As a traveler
# So I can find a place to stay
# I want to see a list of properties

feature 'list of properties' do
  scenario 'a traveler wants to view a list of properties' do
    sign_up
    visit '/properties/new'
    fill_in   :title,       with: 'One bedroom flat'
    fill_in   :location,    with: 'London'
    fill_in   :price,       with:  150
    click_button 'Submit'
    visit '/properties/new'
    fill_in   :title,       with: 'Two bedroom townhouse'
    fill_in   :location,    with: 'Sheffield'
    fill_in   :price,       with:  60
    click_button 'Submit'
    visit '/properties';
    expect(page).to have_content 'One bedroom flat' && 'Two bedroom townhouse'
  end
end

feature 'a user can sign up' do
  scenario 'new user signs up and account is created' do
    expect { sign_up }.to change(User, :count).by(1)
    expect(page).to have_content('Welcome James')
    expect(User.first.email).to eq('test@test.com')
  end

  scenario 'requires a matching confirmation password' do
    expect { sign_up(password_confirmation: 'wrong') }.not_to change(User, :count)
    expect(current_path).to eq('/users')
    expect(page).to have_content 'Password does not match the confirmation'
  end
end
  feature 'A user can sign in on FakersBnB' do
  let!(:user) do
    User.create(username:              'Testaccount',
                email:                 'test@test.com',
                first_name:            'James',
                surname:               'Testy',
                password:              'password!',
                password_confirmation: 'password!')
  end

  scenario 'with correct credentials' do
    sign_in(email: user.email,   password: 'password!')
    expect(page).to have_content "Welcome #{user.first_name}"
  end
end

feature 'User signs out' do
  before(:each) do
    User.create(username:              'Testaccount',
                email:                 'test@test.com',
                first_name:            'James',
                surname:               'Testy',
                password:              'password!',
                password_confirmation: 'password!')
  end

  scenario 'while being signed in' do
    sign_in(email: 'test@test.com', password: 'password!')
    click_button 'Log out'
    expect(page).to have_content('You have been logged out')
    expect(page).not_to have_content('Welcome James')
  end
end


# 3 As a holiday faker
# So that I can only see properties in the location i'm going to
# I want to be able to filter properties by location

feature 'filter properties by location' do
  scenario 'a holiday maker wants to filter properties to their location "London"' do

  end
end

#4 As a holiday faker
# So that I can only see available properties in the location i'm going to
#I want to be able to filter properties by dates of travel

feature 'filter properties by date of travel' do
  scenario 'a holiday maker wants to only see properties available on their travel dates' do

  end
end


  def sign_up(username:              'Testaccount',
              email:                 'test@test.com',
              first_name:            'James',
              surname:               'Testy',
              password:              'password!',
              password_confirmation: 'password!')
    visit '/users/new'
    fill_in :username,              with: username
    fill_in :email,                 with: email
    fill_in :first_name,            with: first_name
    fill_in :surname,               with: surname
    fill_in :password,              with: password
    fill_in :password_confirmation, with: password_confirmation
    click_button 'Create account'
  end


  def sign_in(email:, password:)
    visit '/sessions/new'
    fill_in :email,    with: email
    fill_in :password, with: password
    click_button 'Sign in'
  end
