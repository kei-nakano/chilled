# 例外発生時は、ErrorsControllerのshowアクションにハンドリングし、showアクションからraiseする
Rails.configuration.exceptions_app = ->(env) { ErrorsController.action(:show).call(env) }
