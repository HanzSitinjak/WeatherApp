import UIKit

protocol ScrollBoxCustomDelegate: AnyObject{
    func selectedDetail(_ weatherInfo: homePageVC.WeatherInfo)
}

class ScrollBoxCustom: UIView {
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    weak var delegate: ScrollBoxCustomDelegate?
    private var weatherData: [homePageVC.WeatherInfo] = []
//    private var locationData: [homePageVC.LokasiInfo] = []

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupScrollView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupScrollView()
    }

    private func setupScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.alwaysBounceHorizontal = true //untuk memastikan bisa discroll
        addSubview(scrollView)

        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: self.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])

        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)

        NSLayoutConstraint.activate([
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
        ])
    }
    
    func itemContent(weatherInfo: homePageVC.WeatherInfo) -> UIView {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        container.layer.cornerRadius = 8
        container.backgroundColor = UIColor(hex: "#9CE0FB")

        let imgWeather = UIImageView()
        imgWeather.contentMode = .scaleAspectFit
        imgWeather.translatesAutoresizingMaskIntoConstraints = false
        
        // Ganti gambar sesuai kode cuaca
        switch weatherInfo.weather {
        case 0, 1:
            imgWeather.image = UIImage(named: "cerah")
        case 2:
            imgWeather.image = UIImage(named: "cerahBerawan")
        case 3:
            imgWeather.image = UIImage(named: "berawan")
        case 61:
            imgWeather.image = UIImage(named: "hujan")
        default:
            imgWeather.image = UIImage(named: "cerah")
        }

        let labelTemperatur = UILabel()
        labelTemperatur.text = "\(weatherInfo.temperature)°C"
        labelTemperatur.textColor = .white
        labelTemperatur.textAlignment = .center
        labelTemperatur.translatesAutoresizingMaskIntoConstraints = false

        let labelTime = UILabel()
        labelTime.text = weatherInfo.time
        labelTime.textColor = .white
        labelTime.textAlignment = .center
        labelTime.font = UIFont.systemFont(ofSize: 12.0)
        labelTime.translatesAutoresizingMaskIntoConstraints = false

        container.addSubview(imgWeather)
        container.addSubview(labelTemperatur)
        container.addSubview(labelTime)

        NSLayoutConstraint.activate([
            imgWeather.topAnchor.constraint(equalTo: container.topAnchor, constant: 8),
            imgWeather.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            imgWeather.heightAnchor.constraint(equalToConstant: 40),

            labelTemperatur.topAnchor.constraint(equalTo: imgWeather.bottomAnchor, constant: 5),
            labelTemperatur.centerXAnchor.constraint(equalTo: container.centerXAnchor),

            labelTime.topAnchor.constraint(equalTo: labelTemperatur.bottomAnchor, constant: 5),
            labelTime.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            labelTime.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -8)
        ])

        return container
    }


    func labelDataAPI(_ weatherData: [homePageVC.WeatherInfo]) {
        self.weatherData = weatherData
        contentView.subviews.forEach { $0.removeFromSuperview() }

        var previousContainer: UIView? = nil
        let itemWidth: CGFloat = 73
        let itemHeight: CGFloat = 115
        let spacing: CGFloat = 10

        for (index,weatherInfo) in weatherData.enumerated() {
            let container = itemContent(weatherInfo: weatherInfo)
            contentView.addSubview(container)

            NSLayoutConstraint.activate([
                container.widthAnchor.constraint(equalToConstant: itemWidth),
                            container.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
            ])
            
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(containerIsTapped(_:)))
            container.addGestureRecognizer(tapGesture)
            container.isUserInteractionEnabled = true
            
            container.tag = index

            if let previous = previousContainer {
                NSLayoutConstraint.activate([
                    container.leadingAnchor.constraint(equalTo: previous.trailingAnchor, constant: spacing)
                ])
            } else {
                container.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: spacing).isActive = true
            }

            previousContainer = container
        }
        
        if let lastContainer = previousContainer {
            contentView.trailingAnchor.constraint(equalTo: lastContainer.trailingAnchor, constant: spacing).isActive = true
        }
    }
    
    @objc private func containerIsTapped(_ sender:UITapGestureRecognizer){
        if let container = sender.view{
            let index = container.tag
            guard index < weatherData.count else {return}
            
            let selectedInfoWeather = weatherData[index]
            delegate?.selectedDetail(selectedInfoWeather)
        }
    }
}
