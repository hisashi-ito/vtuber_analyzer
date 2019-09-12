#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
#
#【stat.rb】
#
# 概要: チャンネルの統計情報を取得する
#
# usage: stat.rb <channel_id>
#
require 'logger'
require 'net/http'
require 'uri'
require 'json'
END_POINT = "https://www.googleapis.com/youtube/v3/channels"
GOOGLE_API_KEY = ENV["GOOGLE_API_KEY"]

# 統計情報を出力
def show(response)
  response["items"].each do |item|
    pv  = item["statistics"]["viewCount"]
    user = item["statistics"]["subscriberCount"]
    video = item["statistics"]["videoCount"]
    # 総動画再生回数
    puts("# 総動画再生回数\t登録者数\t動画本数")
    puts("#{pv}\t#{user}\t#{video}")
  end
end

def main(argv)
  logger = Logger.new(STDERR)
  logger.level = Logger::INFO
  channel_id = argv[0] 
  # 統計情報用のURLを作成
  url = END_POINT + "?part=statistics&id=#{channel_id}&key=#{GOOGLE_API_KEY}"
  begin
    response = Net::HTTP.get(URI.parse(url))
    response = JSON.parse(response)
  rescue => e
    logger.error(e.message)
  end
  if response["pageInfo"]["totalResults"] >= 1
    show(response)
  else
    logger.warn("指定のチャンネルIDのページが存在しません: #{channel_id}")
  end
end


if __FILE__ == $0
  main(ARGV)
end
