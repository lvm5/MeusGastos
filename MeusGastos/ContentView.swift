//
//  ContentView.swift
//  iExpense
//
//  Created by Paul Hudson on 15/10/2023.
//  Modified by Leandro Morais on 06/02/2024
//

import SwiftUI

struct ExpenseItem: Identifiable, Codable {
	var id = UUID()
	let name: String
	let type: String
	let amount: Double
}

@Observable
class Expenses {
	var items = [ExpenseItem]() {
		didSet {
			if let encoded = try? JSONEncoder().encode(items) {
				UserDefaults.standard.set(encoded, forKey: "Itens")
			}
		}
	}

	init() {
		if let savedItems = UserDefaults.standard.data(forKey: "Itens") {
			if let decodedItems = try? JSONDecoder().decode([ExpenseItem].self, from: savedItems) {
				items = decodedItems
				return
			}
		}

		items = []
	}
}

struct ContentView: View {
	@State private var expenses = Expenses()

	@State private var showingAddExpense = false

	var body: some View {
		NavigationStack {
			List {
				ForEach(expenses.items) { item in
					HStack {
						VStack(alignment: .leading) {
							Text(item.name)
								.font(.headline)

							Text(item.type)
						}

						Spacer()
						//ORIGINAL CODE
						//Text(item.amount, format: .currency(code: "USD"))
						Text(item.amount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
					}
				}
				.onDelete(perform: removeItems)
			}
			.navigationTitle("Meus Gastos")
			.toolbar {
				Button("Adicionar despesa", systemImage: "plus") {
					showingAddExpense = true
				}
			}
			.sheet(isPresented: $showingAddExpense) {
				AddView(expenses: expenses)
			}
		}
	}

	func removeItems(at offsets: IndexSet) {
		expenses.items.remove(atOffsets: offsets)
	}
}

#Preview {
	ContentView()
}
