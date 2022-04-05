//
//  JogosTableViewCell.swift
//  Jogos
//
//  Created by administrator on 4/4/22.
//

import UIKit

class JogosTableViewCell: UITableViewCell {

    @IBOutlet weak var lblJogoConsole: UILabel!
    @IBOutlet weak var lblJogoNome: UILabel!
    @IBOutlet weak var imgJogo: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func addConsole(_ sender: UIBarButtonItem) {
        
        

    }
    
    func prepareGameCell(with game: Jogo) {
        lblJogoNome.text = game.title
        lblJogoConsole.text = game.console?.name
        
        if let image = game.cover as? UIImage {
            imgJogo.image = image
            return
        }
        
        imgJogo.image = UIImage(named: "noCover")
    }
}
