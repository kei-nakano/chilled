module UsersHelper
  # ブロックまたはブロックされているユーザのidを返す
  def block_ids(user)
    return [] unless user # userがnilの場合は空のArrayを返す

    active_block_ids = user.active_blocks.pluck(:blocked_id)
    passive_block_ids = user.passive_blocks.pluck(:from_id)
    (active_block_ids + passive_block_ids).uniq
  end
end
