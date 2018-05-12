require 'singleton'
# Appを登録するclass
# client, secretを登録する
# client, secretを保存していない場合は取得して保存する
# 保存先は/etc/app_info
class AppRegister
  include Singleton

  FILEPATH = 'etc/app_info'.freeze
  MSTDN_URL = 'https://mstdn-workers.com'.freeze
  APP_NAME = 'memodon'.freeze
  REDIRECT_URI = 'https://localhost/callback/oauth'.freeze

  def register_app
    return if exist_info?
    id, secret = client_info
    save_client_info(id, secret)
  end

  def exist_info?
    File.exist? FILEPATH
  end

  def redirect_uri
    REDIRECT_URI
  end

  def client_info
    if exist_info?
      File.read(FILEPATH).chomp.split('\n')
    else
      client = MstdnIvory::Client.new(MSTDN_URL)
      res = client.create_app(APP_NAME, 'read', REDIRECT_URI)
      [res.client_id, res.client_secret]
    end
  end

  def save_client_info(id, secret)
    Dir.mkdir('etc')
    File.open(FILEPATH, 'w') do |f|
      f.puts id
      f.puts secret
    end
  end
end
