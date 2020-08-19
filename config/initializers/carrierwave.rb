CarrierWave.configure do |config|
  if Rails.env.production?
    config.fog_credentials = {
      provider: "AWS",
      aws_access_key_id: Rails.application.credentials.s3_access_key,
      aws_secret_access_key: Rails.application.credentials.s3_secret_key,
      region: "ap-northeast-1"
    }
    config.fog_public = false
    config.fog_attributes = { cache_control: "public, max-age=#{365.days.to_i}" }
    config.fog_directory = "chilled-site"

    # キャッシュストレージの向き先をfog(aws)にするか
    # config.cache_storage = :fog
  end
end
