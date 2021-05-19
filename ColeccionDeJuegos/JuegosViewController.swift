import UIKit

class JuegosViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate,UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var JuegoImagenView: UIImageView!
    @IBOutlet weak var tituloTextField: UITextField!
    @IBOutlet weak var agregarActualizarBoton: UIButton!
    @IBOutlet weak var eliminarBoton: UIButton!
    @IBOutlet weak var btnDrop: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    var imagePicker = UIImagePickerController()
    
    var juego:Juego? = nil
    
    let generos = ["Accion", "Aventura", "Terror", "Exploracion", "Puzzle"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        
        if juego != nil {
            JuegoImagenView.image = UIImage(data: (juego!.imagen!) as Data)
            tituloTextField.text = juego!.titulo
            btnDrop.setTitle(juego!.genero, for: .normal)
            agregarActualizarBoton.setTitle("Actualizar", for: .normal)
        }else{
            eliminarBoton.isHidden = true
        }
    }
    
    @IBAction func fotosTapped(_ sender: Any) {
        imagePicker.sourceType = .photoLibrary
        present(imagePicker,animated: true,completion:nil)
    }
    
    @IBAction func camaraTapped(_ sender: Any) {
        imagePicker.sourceType = .camera
        present(imagePicker,animated: true, completion: nil)
    }
    
    @IBAction func agregarTapped(_ sender: Any) {
        if juego != nil {
            juego!.titulo! = tituloTextField.text!
            juego!.imagen = JuegoImagenView.image?.jpegData(compressionQuality:0.50)
            juego!.genero! = btnDrop.titleLabel!.text!
        }else{
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            let juego = Juego(context:context)
            juego.titulo = tituloTextField.text
            juego.imagen = JuegoImagenView.image?.jpegData(compressionQuality:0.50)
            juego.genero = btnDrop.titleLabel!.text
        }
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func eliminarTapped(_ sender: Any) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        context.delete(juego!)
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        navigationController?.popViewController(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let imagenSeleccionada = info[.originalImage] as? UIImage
        JuegoImagenView.image = imagenSeleccionada
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    //ComboBox
    
    @IBAction func onClickDropButton(_ sender: Any) {        if tableView.isHidden {
            drop(toogle: true)
        } else {
            drop(toogle: false)
        }
    }
    
    func drop(toogle: Bool) {
        if toogle {
            UIView.animate(withDuration: 0.3) {
                self.tableView.isHidden = false
            }
        } else {
            UIView.animate(withDuration: 0.3) {
                self.tableView.isHidden = true
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return generos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = generos[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        btnDrop.setTitle("\(generos[indexPath.row])", for: .normal)
        drop(toogle: false)
    }
    
}
