module ConfigSupport
  # ディレクトリを再帰的に削除する(自分自身も削除する)
  def recursive_delete(dir_path)
    dir = Dir.new(dir_path)

    # 呼び出し元のディレクトリより1つ下の階層の各ファイルについて実行する
    dir.children.each do |file_name|
      # ディレクトリのパスとファイル名からファイルのパスを作る
      file_path = File.join(dir_path, file_name)

      # file_pathがファイルの場合、削除する
      File.delete(file_path) if File.file?(file_path)

      # file_pathがディレクトリの場合
      if File.directory?(file_path)
        # ディレクトリが空の場合
        if Dir.empty?(file_path)
          # 削除する
          Dir.rmdir(file_path)
        else
          # 空でないディレクトリについては、再帰呼び出しを行う
          recursive_delete(file_path)
        end
      end
    end
    # childrenを全て削除後、空となった自分自身を削除する
    Dir.rmdir(dir_path)
  end
end
