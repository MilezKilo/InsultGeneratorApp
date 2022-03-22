//
//  Home.swift
//  EvilGenerator
//
//  Created by Майлс on 16.03.2022.
//

import SwiftUI

struct Home: View {
    
    //MARK: - PROPERTIES
    @EnvironmentObject private var evilInsult: EvilGenVM
    @State private var showLoad: Bool = false
    @State private var changeLanguage: Bool = true
    
    //MARK: - BODY
    var body: some View {
        VStack {
            if !showLoad {
                Text(evilInsult.evilInsult.insult)
                    .padding(.horizontal)
                    .frame(width: UIScreen.main.bounds.width * 0.9, height: 250)
                    .background(Color.white.cornerRadius(10))
                    .shadow(color: Color.black.opacity(0.2), radius: 10)
                    .padding(.top)
            } else {
                ProgressView()
                    .offset(y: 100)
            }
            Spacer()
            saveButton
        }
        .frame(height: UIScreen.main.bounds.height * 0.7)
        .navigationBarTitle("Генератор Зла!")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) { contextMenu }
            ToolbarItem(placement: .navigationBarLeading) { listOfInsults }
        }
    }
}

//MARK: - EXTENSION
extension Home {
    //VIEWS
    private var resetButton: some View {
        Button(action: {
            guard !showLoad else { return }
            withAnimation(.linear) {
                showLoad = true
                evilInsult.getEvilInsult()
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    withAnimation(.linear) {
                        showLoad = false
                    }
                }
            }
        }) {
            HStack {
                Text("Перезагрузить")
                Image(systemName: "goforward")
            }
            .foregroundColor(.black)
        }
    }
    private var saveButton: some View {
        Button(action: {
            saveInsult()
        }) {
            Text("Сохранить!")
                .frame(width: UIScreen.main.bounds.width * 0.9, height: 65)
                .background(Color.teal.opacity(0.7).cornerRadius(10))
                .font(.headline)
                .foregroundColor(.black)
        }
    }
    private var listOfInsults: some View {
        NavigationLink(destination: SavedInsults().environmentObject(EvilGenVM())) {
            Image(systemName: "list.bullet.rectangle")
                .foregroundColor(.black)
        }
    }
    private var changeLanguageButton: some View {
        Button(action: {guard !showLoad else { return }
            withAnimation(.linear) {
                showLoad = true
                evilInsult.changeLanguage()
                evilInsult.getEvilInsult()
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    withAnimation(.linear) {
                        showLoad = false
                    }
                }
            }
        }) {
            HStack {
                Text("Сменить язык")
                Image(systemName: "globe")
            }
            .foregroundColor(.black)
        }
    }
    
    //CONTEXTMENU
    private var contextMenu: some View {
        Image(systemName: "ellipsis")
            .foregroundColor(.black)
            .contextMenu {
                resetButton
                changeLanguageButton
            }
    }
    
    //METHODS
    private func saveInsult() {
        evilInsult.addNewInsult(
            number: evilInsult.evilInsult.number,
            language: evilInsult.evilInsult.language,
            insult: evilInsult.evilInsult.insult,
            created: evilInsult.evilInsult.created,
            shown: evilInsult.evilInsult.shown,
            createdby: evilInsult.evilInsult.createdby,
            active: evilInsult.evilInsult.active,
            comment: evilInsult.evilInsult.comment)
    }
}


//MARK: - PREVIEW
struct Home_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            Home()
                .environmentObject(EvilGenVM())
        }
    }
}
