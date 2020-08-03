//
//  NewsContent.swift
//  DailyNews
//
//  Created by Karthick Ramasamy on 7/22/20.
//  Copyright © 2020 Karthick Ramasamy. All rights reserved.
//

import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    let request: URLRequest
        
    func makeUIView(context: Context) -> WKWebView  {
        return WKWebView()
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        uiView.load(request)
    }
}

struct ReadMoreNewsView: View {
    @Environment(\.presentationMode) private var presentationMode
    
    var article: Article

    var body: some View {
        WebView(request: URLRequest(url: URL(string: article.url)!)) .navigationBarTitle(article.title)
    }
}
