//
//  AddView.swift
//  iExpense
//
//  Created by Paul Hudson on 16/10/2023.
//

import SwiftUI

struct AddView: View {
	@Environment(\.dismiss) var dismiss

	@State private var name = ""
	@State private var type = "Pessoal"
	@State private var amount = 0.0

	var expenses: Expenses

	let types = ["Diversão", "Pessoal", "Trabalho", "Viagem", "Alimentação"]

	var body: some View {
		NavigationStack {
			Form {
				TextField("Nome", text: $name)

				Picker("Tipo", selection: $type) {
					ForEach(types, id: \.self) {
						Text($0)
					}
				}
//ORIGINAL CODE
//				TextField("Total", value: $amount, format: .currency(code: Locale.current.currency? .identifier ?? "USD"))
				TextField("Total", value: $amount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
					.keyboardType(.decimalPad)
			}
			.navigationTitle("Adicionar despesa")
			.toolbar {
				Button("Salvar") {
					let item = ExpenseItem(name: name, type: type, amount: amount)
					expenses.items.append(item)
					dismiss()
				}
			}
		}
	}
}

#Preview {
	AddView(expenses: Expenses())
}
