#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
#
#【stat.rb】
#
# 概要: チャンネルに紐づく動画情報を取得する
#       全部のデータを取得する場合に微妙な動きになる可能性ｇあるのだが一旦実装してしまう。
#
#       参考: https://qiita.com/yuji_saito/items/8f472dcd785c1fadf666
#
# usage: video.rb <channel_id>
#
$:.unshift << File.join(File.dirname(__FILE__), '.')
require 'logger'
require 'net/http'
require 'uri'
require 'json'
require 'video'
require 'analyzer'
END_POINT = "https://www.googleapis.com/youtube/v3/search"
GOOGLE_API_KEY = ENV["GOOGLE_API_KEY"]
MAX_SEARCH = 30

def search(logger, channel_id)
  videos = []
  # 検索用URL の作成 (取得件数は50件[最大])
  url = END_POINT + "?part=snippet&channelId=#{channel_id}&key=#{GOOGLE_API_KEY}&resultsPerPage=50"
  url_next = nil
  # nextPageToken がなくなるまで検索する(ただし最大閾値は事前に設定)
  next_page_token = nil
  0.upto(MAX_SEARCH){|i|
    begin
      if url_next.nil?
        response = Net::HTTP.get(URI.parse(url))
      else
        response = Net::HTTP.get(URI.parse(url_next))
      end
      response = JSON.parse(response)
      # 結果を保存
      response["items"].each do |item|
        video = Video.new()
        video.id = item["id"]["videoId"]
        s = item["snippet"]
        video.pub_date = s["publishedAt"]
        video.title = s["title"]
        video.description = s["description"]
        video.channel_title = s["channelTitle"]
        videos.push(video)
      end
      # nextPageToken が存在するか？
      if response.has_key?("nextPageToken")
        next_page_token = response["nextPageToken"]
        url_next = url + "&pageToken=#{next_page_token}"
      else
        break
      end
    rescue => e
      logger.error(e.message)
    end
  }
  return videos
end

def main(argv)
  logger = Logger.new(STDERR)
  logger.level = Logger::INFO
  channel_id = argv[0]
  videos = search(logger, channel_id)
  analyzer = Analyzer.new(logger, videos)
  # 投稿時間の頻度
  p analyzer.pub_hour()
end


if __FILE__ == $0
  main(ARGV)
end
