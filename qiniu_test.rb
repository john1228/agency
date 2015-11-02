#!/usr/bin/env ruby

require 'qiniu'

Qiniu.establish_connection! :access_key => '51PeOMLBoxi1VFBrZgT8vTe-mW64g19DbEtPUCem',
                            :secret_key => 'IlQDXWZROSw8shqT42s5nw4Bp2ol-BmyOsjd21g9'

put_policy = Qiniu::Auth::PutPolicy.new(
    'emxing',     # 存储空间
    nil,        # 最终资源名，可省略，即缺省为“创建”语义
    nil, # 相对有效期，可省略，缺省为3600秒后 uptoken 过期
    nil    # 绝对有效期，可省略，指明 uptoken 过期期限（绝对值），通常用于调试
)

uptoken = Qiniu::Auth.generate_uptoken(put_policy)
puts uptoken

code, result, response_headers = Qiniu::Storage.upload_with_put_policy(
    put_policy,     # 上传策略
    'tmp.txt',     # 本地文件名
    nil,            # 最终资源名，可省略，缺省为上传策略 scope 字段中指定的Key值
    {}           # 用户自定义变量，可省略，需要指定为一个 Hash 对象
)
puts code, result, response_headers

code, result, response_headers = Qiniu::Storage.stat(
    'emxing',     # 存储空间
    'FiDZ1HwSaaS730nUgyvIiG-2y4IE'         # 资源名
)
puts 3