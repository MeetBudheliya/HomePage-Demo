//
//  BottomSheetViewController.swift
//  HomePage Demo
//
//  Created by DREAMWORLD on 18/07/24.
//

import UIKit

class BottomSheetViewController: UIViewController {

    @IBOutlet weak var lbl_items: UILabel!
    @IBOutlet weak var lbl_description: UILabel!
      
      var list: [String] = [] // This should be populated with your list of items
      
      override func viewDidLoad() {
          super.viewDidLoad()
          
          // Calculate statistics
          let totalCount = list.count
          let characterCount = countCharacters(list: list)
          let topCharacters = getTopCharacters(characterCount: characterCount)
          
          // Update UI
          lbl_items.text = "\(list.joined(separator: ", ")) (\(totalCount) items)"
          lbl_description.text = formatTopCharacters(topCharacters: topCharacters)
      }
      
      // Function to count of characters
      private func countCharacters(list: [String]) -> [Character: Int] {
          var characterCount: [Character: Int] = [:]
          
          for item in list {
              for char in item.lowercased() {
                  if let count = characterCount[char] {
                      characterCount[char] = count + 1
                  } else {
                      characterCount[char] = 1
                  }
              }
          }
          
          return characterCount
      }
      
      private func getTopCharacters(characterCount: [Character: Int]) -> [(character: Character, count: Int)] {
          let sortedCount = characterCount.sorted { $0.value > $1.value }
          let top3 = sortedCount.prefix(3)
          return top3.map {($0.key, $0.value)}
      }
      
      private func formatTopCharacters(topCharacters: [(character: Character, count: Int)]) -> String {
          var formattedString = ""
          for (index, (char, count)) in topCharacters.enumerated() {
              formattedString += "\(char) = \(count)"
              if index < topCharacters.count - 1 {
                  formattedString += ", "
              }
          }
          return formattedString
      }
      
      @IBAction func dismissButtonTapped(_ sender: Any) {
          dismiss(animated: true, completion: nil)
      }
}
