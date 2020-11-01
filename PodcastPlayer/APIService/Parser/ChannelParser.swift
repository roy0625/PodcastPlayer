//
//  ChannelParser.swift
//  PodcastPlayer
//
//  Created by roy on 2020/10/27.
//

import Foundation


class ChannelParser: NSObject {
    var channel: ChannelModel?
    var episode: EpisodeModel?
    
    var depth: Int = 0
    var currentElement: String = ""
    var parser: XMLParser = XMLParser()
    
    func parse(data: Data) -> ChannelModel? {
        parser = XMLParser(data: data)
        parser.delegate = self
        parser.parse()
        return channel
    }
}

extension ChannelParser: XMLParserDelegate {
    func parserDidStartDocument(_ parser: XMLParser) {
        depth = 0
        currentElement = ""
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        currentElement = elementName
        if elementName == "channel"{
            depth += 1
            channel = ChannelModel()
            channel?.episodes = []
        } else if elementName == "image" {
            depth += 1
        } else if elementName == "item" {
            depth += 1
            episode = EpisodeModel()
        } else if elementName == "itunes:image" {
            episode?.image = attributeDict["href"] ?? ""
        } else if elementName == "enclosure" {
            episode?.url = attributeDict["url"] ?? ""
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        if depth == 1 {          // channel
            switch currentElement {
            case "title":
                channel?.title += string
            case "itunes:summary":
                //channel.channelDescription = string
                break
            default:
                break
            }
        } else if depth == 2 {   // episode
            switch currentElement {
            case "title":
                episode?.title += string
                
            case "pubDate":
                episode?.pubDate = string
                
            case "itunes:summary":
                episode?.summary += string
                
            case "url":                   // channel image
                channel?.image = string
                
            default:
                break
            }
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        currentElement = ""
        if elementName == "channel" {
            depth -= 1
        } else if elementName == "item" {
            if let episode = episode {
                channel?.episodes.append(episode)
            }
            depth -= 1
        } else if elementName == "image" {
            depth -= 1
        }
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        print("parser finish: \(String(describing: channel)), count: \(channel?.episodes.count ?? 0)")
    }
}
