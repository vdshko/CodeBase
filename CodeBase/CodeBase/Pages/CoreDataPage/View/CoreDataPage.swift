//
//  CoreDataPage.swift
//  CodeBase
//
//  Created by Vladyslav Shkodych on 25.03.2023.
//

import SwiftUI

struct CoreDataPage: View {
    
    @StateObject var viewModel: CoreDataPageViewModel = CoreDataPageViewModel(dataService: CoreDataService.shared)
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20.0) {
                addContainer
                list
            }
            .padding()
            .navigationTitle(fileName())
        }
        .onAppear() {
            viewModel.onAppear()
        }
    }
    
    private var addContainer: some View {
        VStack(spacing: 20.0) {
            TextField("Add new fruit here...", text: $viewModel.text)
                .padding(.leading)
                .frame(maxWidth: .infinity)
                .frame(height: 50.0)
                .background(Color.secondary.opacity(0.4))
                .cornerRadius(10.0)
            Button {
                viewModel.addNewFruit()
            } label: {
                Text("Submit")
                    .frame(maxWidth: .infinity)
                    .frame(height: 50.0)
                    .foregroundColor(.white)
                    .background(.blue)
                    .cornerRadius(24.0)
            }
            .disabled(!viewModel.canSubmit)
        }
        .font(.headline)
    }
    
    private var list: some View {
        List {
            ForEach(viewModel.fruits) { fruit in
                row(for: fruit)
            }
            .onDelete(perform: viewModel.deleteFruit)
        }
        .listStyle(PlainListStyle())
    }
    
    private func row(for fruit: FruitEntity) -> some View {
        HStack {
            Text((fruit.name ?? "") + " \(fruit.tappedCounter)")
            Spacer(minLength: 0)
        }
        .background(Color.white)
        .onTapGesture { [weak viewModel] in
            viewModel?.update(fruit)
        }
    }
}

struct CoreDataPage_Previews: PreviewProvider {
    
    static var previews: some View {
        CoreDataPage()
    }
}
