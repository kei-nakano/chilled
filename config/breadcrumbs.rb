crumb :root do
  link "Home", root_path
end

# item#index
crumb :items do
  link "Items", items_path
  parent :root
end

# item#show
crumb :item_show do |item|
  link item.title, item
  parent :items
end

# user#index
crumb :users do
  link "Users", users_path
  parent :root
end

# user#show
crumb :show_user do |user|
  link user.name, user
  parent :users
end

# user#edit
crumb :edit_user do |user|
  link "Edit #{user.name}", edit_user_path(user)
  parent :show_user, user
end

# user#new
crumb :new_user do
  link "New User", new_user_path
  parent :users
end
