//
//  CardList.swift
//  Framewerk
//
//  Created by Michael Neas on 2/27/20.
//  Copyright © 2020 Neas Lease. All rights reserved.
//

import SwiftUI

struct CardList: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Binding var cards: [Card]
    
    init(cards: Binding<[Card]>){
        self._cards = cards
    }
    
    var body: some View {
        List {
            ForEach(self.cards, id: \.id) { card in
                NavigationLink(destination: CardDetail(card: card, link: card.link.absoluteString)) {
                    Text(card.question)
                }
            }.onDelete(perform: delete)
        }
        .navigationBarItems(leading: Button(action: {
           self.presentationMode.wrappedValue.dismiss()
        }) {
            Image(systemName: "rectangle.stack").padding(.bottom, 8)
        }, trailing: EditButton())
        .navigationBarTitle("Cards", displayMode: .inline)
    }
    
    func delete(at offsets: IndexSet) {
        cards.remove(atOffsets: offsets)
    }
}
