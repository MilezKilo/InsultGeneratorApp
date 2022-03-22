//
//  SavedInsults.swift
//  EvilGenerator
//
//  Created by Майлс on 18.03.2022.
//

import SwiftUI

struct SavedInsults: View {
    
    //MARK: - PROPERTIES
    @EnvironmentObject private var evilInsult: EvilGenVM
    @Environment(\.presentationMode) private var presentationMode
    
    var body: some View {
        List {
            ForEach(evilInsult.evilInsultsContainer) { insult in
                Text(insult.insult ?? "")
                    .font(.headline)
            }
            .onDelete(perform: evilInsult.deleteInsult)
        }
        .listStyle(PlainListStyle())
        .navigationBarTitle("Сохранено")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) { backButton }
        }
    }
}

//MARK: - EXTENSION
extension SavedInsults {
    //VIEWS
    private var backButton: some View {
        Button(action: {
            presentationMode.wrappedValue.dismiss()
        }) {
            Image(systemName: "chevron.backward")
                .font(.headline)
                .foregroundColor(.black)
        }
    }
}

struct SavedInsults_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SavedInsults()
                .environmentObject(EvilGenVM())
        }
    }
}
