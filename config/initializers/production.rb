# 例外発生時は、ErrorsControllerのshowアクションにハンドリングし、showアクションからraiseする
Rails.configuration.exceptions_app = ErrorsController.action(:show)
