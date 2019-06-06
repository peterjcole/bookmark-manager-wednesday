feature 'bookmark_manager' do
  before(:each) do
    truncates
    add_bookmarks
  end

  feature 'view all bookmarks' do
    Capybara.default_driver = :selenium
    Capybara.server = :webrick

    scenario 'user can see bookmark URLs' do
      visit('/')
      expect(page).to have_content "http://www.makersacademy.com"
      expect(page).to have_content "http://www.google.com"
      expect(page).to have_content "http://www.destroyallsoftware.com"
    end

    scenario 'bookmark URLs are links' do
      visit('/')
      expect(page).to have_link "http://www.makersacademy.com"
      expect(page).to have_link "http://www.google.com"
      expect(page).to have_link "http://www.destroyallsoftware.com"
    end
  end

  feature 'adding bookmarks' do
    scenario 'user can add a bookmark with a url' do
      visit '/add'
      fill_in('url', with: 'http://nomnoml.com')
      click_button('Add')
      expect(page).to have_content "http://nomnoml.com"
    end

    scenario 'user can add a bookmark with a url and a title' do
      visit '/add'
      fill_in('url', with: 'http://nomnoml.com')
      fill_in('title', with: 'Here is the nomnoml title')
      click_button('Add')
      expect(page).to have_content "http://nomnoml.com"
      expect(page).to have_content "Here is the nomnoml title"
    end

    scenario 'error received when user adds a bookmark with an invalid URL' do
      visit '/add'
      fill_in('url', with: 'bloop')
      fill_in('title', with: 'Title')
      click_button('Add')
      expect(page).to have_css('.error', text: 'Error: invalid URL')
    end

    scenario 'bookmark is not added when url is invalid' do
      visit '/add'
      fill_in('url', with: 'bloop')
      fill_in('title', with: 'Title')
      click_button('Add')
      visit '/'
      expect(page).not_to have_content 'bloop'
    end
  end

  feature 'deleting bookmarks' do
    scenario 'delete buttons are present on bookmark list for each bookmark' do
      visit '/'
      expect(page).to have_button('Delete', count: 3)
    end

    scenario 'deleting the first bookmarks makes it disappear' do
      visit '/'
      first('.bookmark').click_button('Delete')
      expect(page.first('.bookmark')).to have_content('http://www.destroyallsoftware.com')
      expect(page).not_to have_content('http://www.makersacademy.com')
      expect(page).not_to have_content('Makers')
    end
  end

  feature 'updating bookmarks' do
    scenario "first bookmark's title can be updated" do
      visit '/'
      first('.bookmark').click_button('Edit')
      fill_in('title', with: 'Coffee Academy')
      click_button('Save')
      expect(page).not_to have_content('Makers')
      expect(page).to have_content('Coffee Academy')
    end
    scenario "first bookmark's url can be updated" do
      visit '/'
      first('.bookmark').click_button('Edit')
      fill_in('url', with: 'http://coffeeacademy.biz')
      click_button('Save')
      expect(page).not_to have_content('http://www.makersacademy.com')
      expect(page).to have_content('http://coffeeacademy.biz')
    end
  end
end