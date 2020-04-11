//
//  CardDetail.swift
//  Framewerk
//
//  Created by Michael Neas on 2/29/20.
//  Copyright © 2020 Neas Lease. All rights reserved.
//

import SwiftUI

struct CardDetail: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @ObservedObject var card: Card
    @State var textHeight: CGFloat = 150
    var commited: ((Card) -> ())?
    var isNewCard = false
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: CardDetailTitle(title: "Title")) {
                    TextField("Title", text: $card.question, onEditingChanged: changed, onCommit: commit)
                        .foregroundColor(Color(.systemGray4))
                        .padding()
                }
                Section(header:  CardDetailTitle(title: "Description")) {
                    ScrollView {
                        TextView(placeholder: "Card Solution", text: $card.answer, minHeight: 100.0, calculatedHeight: $textHeight, finished: commit)
                            .frame(minHeight: self.textHeight, maxHeight: self.textHeight)
                            .padding()
                    }
                }
                Section(header: CardDetailTitle(title: "Link")) {
                    TextField("Link", text: Binding(
                        get: {
                            self.card.link.absoluteString
                        },
                        set: { potentialURL in
                            guard let url = URL(string: potentialURL) else { return }
                            self.card.link = url
                        }), onEditingChanged: changed, onCommit: commit)
                        .foregroundColor(Color(.systemGray4))
                        .padding()
                }
            }
            .navigationBarTitle(Text($card.question.wrappedValue), displayMode: .inline)
            .navigationBarItems(trailing: Button(action: {
                self.presentationMode.wrappedValue.dismiss()
                self.commited?(self.card)
                print("Dismissing sheet view...")
            }) {
                Text("Save")
            })
        }
        .background(Color(UIColor.systemGray)).edgesIgnoringSafeArea(.bottom)
        .navigationBarTitle(Text($card.question.wrappedValue), displayMode: .inline)
    }
    
    func changed(change: Bool) {
        if !change {
            commit()
        }
    }
    
    func commit(description: String) {
        commit()
    }
    
    // commit fires on 'done' and manually from change finishing
    func commit() {
        guard !isNewCard else { return }
        print("COMMIT")
        commited?(card)
    }
}

struct CardDetailTitle: View {
    var title: String
    var body: some View {
        Text(title)
            .bold()
            .foregroundColor(.black)
            .font(.headline)
    }
}

struct CardDetail_Previews: PreviewProvider {
    static var previews: some View {
        CardDetail(card: Card.test)
    }
}
