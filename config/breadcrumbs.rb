crumb :root do
  link "トップ", "/"
end

# search
crumb :search do
  link "検索", "/search"
  parent :root
end

# search#show
crumb :search_show do |keyword|
  link "「#{keyword}」の検索結果", "/search"
  parent :search
end

# items
crumb :items do
  link "商品一覧", "/search?type=item"
  parent :search
end

# item#show
crumb :item_show do |item|
  link item.title, item
  parent :items
end

# users
crumb :users do
  link "ユーザー一覧", "/search?type=user"
  parent :search
end

# user#show
crumb :user_show do |user|
  link user.name, user
  parent :users
end

# room#index
crumb :room_index do |user|
  link "メッセージ", "/rooms"
  parent :user_show, user
end

# room#show
crumb :room_show do |current_user, other|
  link other.name, "#"
  parent :room_index, current_user
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
