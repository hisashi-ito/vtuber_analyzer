#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
#
#【analyzer.rb】
#
# 概要: ビデオ情報のアナライザクラス
#
$:.unshift << File.join(File.dirname(__FILE__), '.')
require 'logger'
require 'video'
require 'time'

class Analyzer
  def initialize(logger, videos)
    @logger = logger
    @videos = videos
  end
  
  # 投稿時間(24時間の頻度)
  def pub_hour()
    ret = {}
    @videos.each do |video|
      p video.pub_date
      hour = Time::parse(video.pub_date).hour
      ret[hour] ||= 0
      ret[hour] += 1
    end
    return ret
  end
end
