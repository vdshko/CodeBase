//
//  SwinjectPage.swift
//  CodeBase
//
//  Created by Vladyslav Shkodych on 27.03.2023.
//

import SwiftUI

struct SwinjectPage: View {
    
    @StateObject var viewModel: SwinjectPageViewModel = SwinjectPageViewModel()
    
    var body: some View {
        Text(fileName())
    }
}

struct SwinjectPage_Previews: PreviewProvider {
    
    static var previews: some View {
        SwinjectPage()
    }
}
