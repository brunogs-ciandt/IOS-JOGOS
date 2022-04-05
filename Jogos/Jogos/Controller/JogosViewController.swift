//
//  JogosViewController.swift
//  Jogos
//
//  Created by administrator on 4/4/22.
//

import UIKit

class JogosViewController: UIViewController {

    @IBOutlet weak var lblJogoName: UILabel!
    @IBOutlet weak var lblPlataforma: UILabel!
    @IBOutlet weak var lblData: UILabel!
    
    @IBOutlet weak var imgJogoImage: UIImageView!
    
    var jogo: Jogo!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadGameData(with: jogo)
    }
    

    func loadGameData(with jogo: Jogo) {
        lblJogoName.text = jogo.title
        lblPlataforma.text = jogo.console?.name ?? "Sem plataforma"
        
        if let releaseDate = jogo.releaseDate{
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .long
            lblData.text = "Lancamento " + dateFormatter.string(from: releaseDate)
        }
        
        if let image = jogo.cover as? UIImage {
            imgJogoImage.image = image
        } else {
            imgJogoImage.image = UIImage(named: "noCoverFull")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let view = segue.destination as! AddEditViewController
        view.game = jogo
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
