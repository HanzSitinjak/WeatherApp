import UIKit

class homePageVC: UIViewController{
    var username: String?
    
    @IBOutlet weak var containerDetailFirst: UIView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var containerDetailSecond: UIView!
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var humidityLabel: UILabel!
    
    private var scrollBox: ScrollBoxCustom!
    private var temperatures: [String] = []
    private var weatherDetails: [WeatherInfo] = []
    private var lokasiDetails: [LokasiInfo] = []
    
    @IBOutlet weak var placeholderView: UIView!
    @IBOutlet weak var placeHolder2: UIView!
    
    @IBOutlet weak var HumidityDataLabel: UIView!
    @IBOutlet weak var placeholderView2: UIView!
    @IBOutlet weak var TTCDataLabel: UIView!
    
    @IBOutlet weak var ArahanginData: UIView!
    @IBOutlet weak var RainfallDataLabel: UIView!
    @IBOutlet weak var kecAnginData: UIView!
    
    @IBOutlet weak var temperaturLabel2: UILabel!
    @IBOutlet weak var desCuacaLabel: UILabel!
    @IBOutlet weak var ketCuacaLabel: UILabel!
    @IBOutlet weak var datetimeLabel: UILabel!
    
    @IBOutlet weak var provinsiLabel: UILabel!
    @IBOutlet weak var kabupatenLabel: UILabel!
    @IBOutlet weak var kecamatanLabel: UILabel!
    @IBOutlet weak var containerDataLocation: UIView!
    
    struct WeatherInfo{
        let temperature: Int
        let humidity: Int
        let weather: Int
        let rainfall: Double
        let date: String
        let time: String
        let arahAngin: Int
        let kecAngin: Double
        let totalCloudCover: Double
        let ketCuaca: String
        let desCuaca: String
    }
    
    struct LokasiInfo{
        let provinsi: String
        let kabupaten: String
        let kecamatan: String
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.hidesBackButton = true
        setupUsernameLabel()
        setupScrollBox()
        fetchDataCuaca()
        setupSkeletonPlaceholder()
        setupLocationLabel()
    }
    
    private func setupSkeletonPlaceholder() {
        placeholderView.backgroundColor = .lightGray.withAlphaComponent(0.7)
        placeholderView.layer.cornerRadius = 10
        containerDetailFirst.addSubview(placeholderView)
        placeholderView.startSkeletonAnimation()
        
        placeholderView2.backgroundColor = .lightGray.withAlphaComponent(0.7)
        placeholderView2.layer.cornerRadius = 10
        containerDetailFirst.addSubview(placeholderView)
        placeholderView2.startSkeletonAnimation()
    }

    private func setupLocationLabel(){
        guard let lokasiInfo = lokasiDetails.first else {
            print("Lokasi Tidak Ada")
            return
        }
        DispatchQueue.main.async{
            self.provinsiLabel.text = "\(lokasiInfo.provinsi)"
            self.provinsiLabel.textColor = .white
            self.provinsiLabel.font = UIFont(name: "Arial Rounded MT Bold", size: 28.0)
            self.provinsiLabel.textAlignment = .left
            
            self.kabupatenLabel.text = "\(lokasiInfo.kabupaten)"
            self.kabupatenLabel.textColor = .white
            self.kabupatenLabel.font = UIFont(name: "Arial Rounded MT Bold", size: 15.0)
            self.kabupatenLabel.textAlignment = .left
            
            self.kecamatanLabel.text = "\(lokasiInfo.kecamatan)"
            self.kecamatanLabel.textColor = .white
            self.kecamatanLabel.font = UIFont.systemFont(ofSize: 16.0)
            self.kecamatanLabel.textAlignment = .left
        }
    }
    
    private func setupUsernameLabel() {
        if let username = username {
            usernameLabel.text = username
            usernameLabel.textColor = .white
            usernameLabel.font = UIFont(name: "Arial Rounded MT Bold", size: 20)
        } else {
            usernameLabel.text = "Selamat Datang!"
        }
    }
    
    final func fetchDataCuaca(){
        let urlDataCuaca = "https://api.bmkg.go.id/publik/prakiraan-cuaca?adm4=31.74.05.1001"
        guard let url = URL(string: urlDataCuaca) else {return}
        let getData = URLSession.shared.dataTask(with: url){data, response, error in
            guard let data = data, error == nil else{
                print("Gagal mendapatkan data!!:\(String(describing: error))")
                return
            }
            do{
                if let DataCuaca = try JSONSerialization.jsonObject(with: data, options: [])as?[String: Any],
                   
                    let DataCuacaArray = DataCuaca["data"] as? [[String: Any]]{
                    if let DatalokasiArray = DataCuaca["lokasi"] as? [String:Any]{
                        if let provinsi = DatalokasiArray["provinsi"] as? String,
                        let kabupaten = DatalokasiArray["kota"] as? String,
                        let kecamatan = DatalokasiArray["kecamatan"] as? String{
                            print("Ini Provinsi: \(provinsi) dan \(kabupaten) dan \(kecamatan)")
                            
                            let lokasiInfo = LokasiInfo(provinsi: provinsi, kabupaten: kabupaten, kecamatan: kecamatan)
                            self.lokasiDetails.append(lokasiInfo)
                            self.setupLocationLabel()
                        }else{
                        print("gagal mengambil data")
                        }
                    }
                    
                    self.weatherDetails.removeAll()
                    
                    for Cuaca in DataCuacaArray{
                        if let cuacaArray = Cuaca["cuaca"] as? [[Any]]{
                            let cuacas = cuacaArray.flatMap({ $0 })
                            for cuaca in cuacas {
         
                                let dateFormatter = DateFormatter()
                                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                                
                                if let detailCuaca  = cuaca as? [String: Any]{
                                    if let temperatur = detailCuaca["t"] as? Int,
                                       let humidity = detailCuaca["hu"] as? Int,
                                       let weather = detailCuaca["weather"] as? Int,
                                       let rainfall = detailCuaca["tp"] as? Double,
                                       let arahAngin = detailCuaca["wd_deg"] as? Int,
                                       let kecAngin = detailCuaca["ws"] as? Double,
                                       let totalCloudCover = detailCuaca["tcc"] as? Double,
                                       let ketCuaca = detailCuaca["weather_desc"] as? String,
                                       let desCuaca = detailCuaca["weather_desc_en"] as? String,
                                       let localDatetime = detailCuaca["local_datetime"] as? String,
                                       let date = dateFormatter.date(from: localDatetime){
                                        dateFormatter.dateFormat = "d MMMM yyyy"
                                        let dateString = dateFormatter.string(from: date)
                                        dateFormatter.dateFormat = "HH:mm"
                                        let timeString = dateFormatter.string(from: date)
                                    
                                        let weatherInfo = WeatherInfo(temperature: temperatur, humidity: humidity, weather: weather, rainfall: rainfall, date: dateString, time: timeString, arahAngin: arahAngin, kecAngin: kecAngin, totalCloudCover: totalCloudCover, ketCuaca: ketCuaca, desCuaca: desCuaca
                                        )
                                        self.weatherDetails.append(weatherInfo)
                                    }
                                }
                            }
                        }
                    }
                    DispatchQueue.main.async {
//                        print("Ini Detail Cuaca: \(self.weatherDetails)")
                        self.placeholderView.stopSkeletonAnimation()
                            self.placeholderView.removeFromSuperview()
                        
                        self.scrollBox.labelDataAPI(self.weatherDetails)
                        if let firstDataWeather = self.weatherDetails.first{
                            self.selectedDetail(firstDataWeather)
                        }
                    }
                }
            }catch{
                print("Error dalam mengambil data!!")
            }
        }
        getData.resume()
    }
    
    private func setupScrollBox(){
        scrollBox = ScrollBoxCustom()
        scrollBox.delegate = self
        scrollBox.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollBox)
        
        NSLayoutConstraint.activate([
            scrollBox.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            scrollBox.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            scrollBox.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30),
            scrollBox.heightAnchor.constraint(equalToConstant: 120)
        ])
    }
}

extension homePageVC: ScrollBoxCustomDelegate {
    func selectedDetail(_ weatherInfo: homePageVC.WeatherInfo){
        containerDetailFirst.subviews.forEach {
            $0.removeFromSuperview()
            $0.removeConstraints($0.constraints)
        }
        containerDetailSecond.subviews.forEach {
            $0.removeFromSuperview()
            $0.removeConstraints($0.constraints)
        }

        containerDetailFirst.backgroundColor = .white.withAlphaComponent(0.4)
        containerDetailFirst.roundCorners(corners: [.topRight, .bottomRight], radius: 10)

        RainfallDataLabel.labelData(teksAtas: "Rainfall", teksBawah: "\(weatherInfo.rainfall)mm", in: RainfallDataLabel, space: 28.0, sizeFontAtas: 10, sizeFontBawah: 12)
                
        TTCDataLabel.labelData(teksAtas: "Total Cloud\nCover", teksBawah: "\(weatherInfo.totalCloudCover)%", in: TTCDataLabel, space: 28.0, sizeFontAtas: 10, sizeFontBawah: 12)
                
        HumidityDataLabel.labelData(teksAtas: "Humadity", teksBawah: "\(weatherInfo.humidity)%", in: HumidityDataLabel, space: 35.0, sizeFontAtas: 14, sizeFontBawah: 20)
        
        ArahanginData.labelData(teksAtas: "Arah Angin", teksBawah: "\(weatherInfo.arahAngin)", in: ArahanginData, space: 35.0, sizeFontAtas: 14, sizeFontBawah: 20)
        
        kecAnginData.labelData(teksAtas: "Kecepatan Angin", teksBawah: "\(weatherInfo.kecAngin)", in: kecAnginData, space: 35.0, sizeFontAtas: 14, sizeFontBawah: 20)
    
        containerDetailFirst.addSubview(HumidityDataLabel)
        containerDetailFirst.addSubview(RainfallDataLabel)
        containerDetailFirst.addSubview(TTCDataLabel)
        containerDetailFirst.addSubview(ArahanginData)
        containerDetailFirst.addSubview(kecAnginData)

        containerDetailSecond.backgroundColor = .white
        containerDetailSecond.layer.cornerRadius = 10
        
        weatherImage.contentMode = .scaleAspectFit
        switch weatherInfo.weather {
        case 0, 1:
            weatherImage.image = UIImage(named: "cerah")
        case 2:
            weatherImage.image = UIImage(named: "cerahBerawan")
        case 3:
            weatherImage.image = UIImage(named: "berawan")
        case 61:
            weatherImage.image = UIImage(named: "hujan")
        default:
            weatherImage.image = UIImage(named: "cerah")
        }

        containerDetailSecond.addSubview(weatherImage)
        containerDetailSecond.addSubview(datetimeLabel)
        containerDetailSecond.addSubview(desCuacaLabel)
        containerDetailSecond.addSubview(ketCuacaLabel)
        containerDetailSecond.addSubview(temperaturLabel2)
        
        temperaturLabel2.text = "\(weatherInfo.temperature)°C"
        temperaturLabel2.textColor = UIColor(hex:"#9CE0FB")
        temperaturLabel2.font = UIFont.boldSystemFont(ofSize: 45.0)
        temperaturLabel2.textAlignment = .left
        
        datetimeLabel.text = "\(weatherInfo.date)"
        datetimeLabel.textColor = UIColor(hex:"#9CE0FB")
        datetimeLabel.font = UIFont.boldSystemFont(ofSize: 20.0)
        datetimeLabel.textAlignment = .center
        
        desCuacaLabel.text = "\(weatherInfo.desCuaca)"
        desCuacaLabel.textColor = UIColor(hex:"#9CE0FB")
        desCuacaLabel.font = UIFont.boldSystemFont(ofSize: 20.0)
        desCuacaLabel.textAlignment = .left
        
        ketCuacaLabel.text = "\(weatherInfo.ketCuaca)"
        ketCuacaLabel.textColor = UIColor(hex:"#9CE0FB")
        ketCuacaLabel.font = UIFont.systemFont(ofSize: 16.0)
        ketCuacaLabel.textAlignment = .left

        print("Info Data: \(weatherInfo)")
    }
}


extension UIView {
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
    
    func labelData(teksAtas: String, teksBawah: String, in container: UIView, space: Double, sizeFontAtas: Double, sizeFontBawah: Double) {
        
        container.subviews.forEach { subview in
            subview.removeFromSuperview()
            subview.removeConstraints(subview.constraints)
        }
        
        let labelAtas = UILabel()
        labelAtas.text = teksAtas
        labelAtas.font = UIFont.systemFont(ofSize: sizeFontAtas)
        labelAtas.textColor = .white
        labelAtas.textAlignment = .left
        labelAtas.numberOfLines = 0
        labelAtas.translatesAutoresizingMaskIntoConstraints = false

        let labelBawah = UILabel()
        labelBawah.text = teksBawah
        labelBawah.font = UIFont.boldSystemFont(ofSize: sizeFontBawah)
        labelBawah.textColor = .white
        labelBawah.textAlignment = .left
        labelBawah.translatesAutoresizingMaskIntoConstraints = false

        container.addSubview(labelAtas)
        container.addSubview(labelBawah)

        NSLayoutConstraint.activate([
            labelAtas.leadingAnchor.constraint(equalTo: container.leadingAnchor),
        
            labelBawah.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            labelBawah.topAnchor.constraint(equalTo: container.topAnchor, constant: space)
        ])
    }
}
