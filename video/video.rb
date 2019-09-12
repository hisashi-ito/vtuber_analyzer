# -*- coding: utf-8 -*-
#
#【video】
#
# 概要: 動画情報管理クラス
#
class Video
  attr_accessor :id , :title, :description, :pub_date, :channel_title
  def initialize()
    @id = nil
    @title = nil
    @description = nil
    @pub_date = nil
    @channel_title = nil
  end
end
