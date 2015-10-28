# CarrierWave.configure do |config|
#   config.storage = :file
#   config.asset_host = 'http://localhost:3000'
# end

::CarrierWave.configure do |config|
  config.storage             = :qiniu
  config.qiniu_access_key    = "51PeOMLBoxi1VFBrZgT8vTe-mW64g19DbEtPUCem"
  config.qiniu_secret_key    = 'IlQDXWZROSw8shqT42s5nw4Bp2ol-BmyOsjd21g9'
  config.qiniu_bucket        = "emxing"
  config.qiniu_bucket_domain = "7xl2f5.com1.z0.glb.clouddn.com"
  #config.qiniu_bucket_private= true #default is false
  config.qiniu_block_size    = 4*1024*1024
  #config.qiniu_protocol      = "http"

  #config.qiniu_up_host       = 'http://up.qiniug.com' #七牛上传海外服务器,国内使用可以不要这行配置
end

