//
//  ChannelParserTest.swift
//  PodcastPlayerTests
//
//  Created by roy on 2020/11/1.
//

import XCTest

class ChannelParserTest: XCTestCase {
    
    let fakeDataString = """
<rss version="2.0"
    xmlns:itunes="http://www.itunes.com/dtds/podcast-1.0.dtd"
    xmlns:atom="http://www.w3.org/2005/Atom">
    <channel>
        <atom:link href="https://feeds.soundcloud.com/users/soundcloud:users:322164009/sounds.rss" rel="self" type="application/rss+xml"/>
        <atom:link href="https://feeds.soundcloud.com/users/soundcloud:users:322164009/sounds.rss?before=335052773" rel="next" type="application/rss+xml"/>
        <title>科技島讀</title>
        <link>https://daodu.tech</link>
        <pubDate>Sun, 25 Oct 2020 11:53:25 +0000</pubDate>
        <lastBuildDate>Sun, 25 Oct 2020 11:53:25 +0000</lastBuildDate>
        <ttl>60</ttl>
        <language>zh-tw</language>
        <copyright>All rights reserved</copyright>
        <webMaster>feeds@soundcloud.com (SoundCloud Feeds)</webMaster>
        <description>一些描述</description>
        <itunes:subtitle>描述</itunes:subtitle>
        <itunes:owner>
            <itunes:name>科技島讀 Podcast</itunes:name>
            <itunes:email>hi@daodu.tech</itunes:email>
        </itunes:owner>
        <itunes:author>Daodu Tech</itunes:author>
        <itunes:explicit>no</itunes:explicit>
        <itunes:image href="https://i1.sndcdn.com/avatars-000326154119-ogb1ma-original.jpg"/>
        <image>
            <url>https://i1.sndcdn.com/avatars-000326154119-ogb1ma-original.jpg</url>
            <title>科技島讀 Podcast</title>
            <link>https://daodu.tech</link>
        </image>
        <itunes:category text="Business"/>
        <item>
            <guid isPermaLink="false">tag:soundcloud,2010:tracks/917343037</guid>
            <title>Ep.118 科技不會放過聲音｜特別來賓 Firstory 共同創辦人于子軒</title>
            <pubDate>Sun, 25 Oct 2020 22:00:16 +0000</pubDate>
            <link>https://soundcloud.com/daodutech/ep118-firstory</link>
            <itunes:duration>00:34:40</itunes:duration>
            <itunes:author>Daodu Tech</itunes:author>
            <itunes:explicit>no</itunes:explicit>
            <itunes:summary>Test description !!😍</itunes:summary>
            <itunes:subtitle>錄製音樂受到科技的幾番鍛鍊，從廣播、CD、下載到串流，其商業模式與內容型態不斷改朝換代。然而相較於…</itunes:subtitle>
            <description>Test description !!😍</description>
            <enclosure type="audio/mpeg" url="https://feeds.soundcloud.com/stream/917343037-daodutech-ep118-firstory.mp3" length="49880147"/>
            <itunes:image href="https://i1.sndcdn.com/artworks-Z7zJRFuDjv63KCHv-5W8whA-t3000x3000.jpg"/>
        </item>
        <item>
            <guid isPermaLink="false">tag:soundcloud,2010:tracks/912631840</guid>
            <title>Ep.117 別為了 5G 換 iPhone</title>
            <pubDate>Sun, 18 Oct 2020 22:00:14 +0000</pubDate>
            <link>https://soundcloud.com/daodutech/ep117</link>
            <itunes:duration>00:34:18</itunes:duration>
            <itunes:author>Daodu Tech</itunes:author>
            <itunes:explicit>no</itunes:explicit>
            <itunes:summary>描述</itunes:summary>
            <itunes:subtitle>蘋果推出 iPhone 12 手機，以 5G 為全系列賣點。但在發表會上蘋果 CEO 庫克讓版位給…</itunes:subtitle>
            <description>描述</description>
            <enclosure type="audio/mpeg" url="https://feeds.soundcloud.com/stream/912631840-daodutech-ep117.mp3" length="49343165"/>
            <itunes:image href="https://i1.sndcdn.com/artworks-Z7zJRFuDjv63KCHv-5W8whA-t3000x3000.jpg"/>
        </item>
  </channel>
</rss>
"""
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testChannelParser() throws {
        let data = fakeDataString.data(using: .utf8)!
        let parser = ChannelParser()
        let channel = parser.parse(data: data)
        XCTAssert(channel?.episodes.count == 2)
        XCTAssert(channel?.title == "科技島讀")
        XCTAssert(channel?.image == "https://i1.sndcdn.com/avatars-000326154119-ogb1ma-original.jpg")
        
        let episode = channel?.episodes.first
        XCTAssert(episode?.title == "Ep.118 科技不會放過聲音｜特別來賓 Firstory 共同創辦人于子軒")
        XCTAssert(episode?.image == "https://i1.sndcdn.com/artworks-Z7zJRFuDjv63KCHv-5W8whA-t3000x3000.jpg")
        XCTAssert(episode?.pubDate == "Sun, 25 Oct 2020 22:00:16 +0000")
        XCTAssert(episode?.url == "https://feeds.soundcloud.com/stream/917343037-daodutech-ep118-firstory.mp3")
        XCTAssert(episode?.summary == "Test description !!😍")
    }
}
