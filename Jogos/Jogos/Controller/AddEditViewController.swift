//
//  AddEditViewController.swift
//  Jogos
//
//  Created by administrator on 4/4/22.
//

import UIKit

class AddEditViewController: UIViewController {
    
    @IBOutlet weak var txtJogoNome: UITextField!
    @IBOutlet weak var txtPlataforma: UITextField!
    
    @IBOutlet weak var dtJogo: UIDatePicker!
    @IBOutlet weak var btnAddEdit: UIButton!
    @IBOutlet weak var btnEditImage: UIButton!
    
    @IBOutlet weak var imgCoverJogoe: UIImageView!
    
    var game: Jogo!;
    let consoleManager = ConsoleManager.shared
    
    lazy var pickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.delegate = self
        pickerView.backgroundColor = .white
        return pickerView
    }()
    
    private func preparePlataformaControl() {
        txtPlataforma.inputView = pickerView
        
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 44))
        
        let btnCancel = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
        let btnDone = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        let btnSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        
        toolbar.items = [btnCancel, btnSpace, btnDone]
        txtPlataforma.inputAccessoryView = toolbar
    }
    
    private func prepareEditGameData() {
        if game != nil {
            title = "Editar Jogo"
            btnAddEdit.setTitle("Editar", for: .normal)
            txtJogoNome.text = game.title
            
            imgCoverJogoe.image = game.cover as? UIImage
            
            if let releaseDate = game.releaseDate {
                dtJogo.date = releaseDate
            }
            
            if let console = game.console, let index = consoleManager.consoles.firstIndex(of: console) {
                pickerView.selectRow(index, inComponent: 0, animated: true)
                txtPlataforma.text = console.name
            }
            
            if game.cover != nil {
                btnEditImage.setTitle(nil, for: .normal)
            }
        } else {
            title = "Adicionar Jogo"
            btnAddEdit.setTitle("Adicionar", for: .normal)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        consoleManager.loadConsoles(with: context)
        preparePlataformaControl()
        prepareEditGameData()
    }
    
    @objc func cancel(){
        txtPlataforma.resignFirstResponder()
    }
    
    @objc func done(){
        txtPlataforma.text = consoleManager.consoles[pickerView.selectedRow(inComponent: 0)].name
        
        cancel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        consoleManager.loadConsoles(with: context)
    }
    
    @IBAction func addEditCover(_ sender: UIButton) {
        let alert = UIAlertController(title: "Selecionar poster", message: "De onde voce quer escolher o poster ?", preferredStyle: .actionSheet)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let cameraAction = UIAlertAction(title: "Camera", style: .default) { action in
                self.selectPicture(sourceType: .camera)
            }
            alert.addAction(cameraAction)
        }
        
        let libraryAction = UIAlertAction(title: "Biblioteca", style: .default) { action in
                self.selectPicture(sourceType: .photoLibrary)
        }
        alert.addAction(libraryAction)
        
        let photosAction = UIAlertAction(title: "Album", style: .default) { action in
                self.selectPicture(sourceType: .savedPhotosAlbum)
        }
        alert.addAction(photosAction)
        
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    func selectPicture(sourceType: UIImagePickerController.SourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = sourceType
        imagePicker.delegate = self
        imagePicker.navigationBar.tintColor = UIColor(named: "main")
        present(imagePicker, animated: true)
    }
    
    
    @IBAction func addEditJogo(_ sender: UIButton) {
        if game == nil {
            game = Jogo(context: context)
        }
        
        game.title = txtJogoNome.text
        game.releaseDate = dtJogo.date
        game.cover = imgCoverJogoe.image
            
        if !txtPlataforma.text!.isEmpty {
            game.console = consoleManager.consoles[pickerView.selectedRow(inComponent: 0)]
        }
            
        do {
            try
                context.save()
            } catch {
                print("Error save jogo")
        }
            
        navigationController?.popViewController(animated: true)
    }
}

extension AddEditViewController : UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return consoleManager.consoles.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return consoleManager.consoles[row].name
    }
}

extension AddEditViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.originalImage] as? UIImage
        imgCoverJogoe.image = image
        btnEditImage.setTitle("", for: .normal)
        dismiss(animated: true, completion: nil)
    }
}
