//
//  ViewController.swift
//  CityWeather
//
//  Created by Admin on 24/02/2020.
//  Copyright © 2020 Polina Chernova. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    let defaults = UserDefaults.standard
    let cityTableView = UITableView.init( frame: CGRect.zero)
    let searchController = UISearchController(searchResultsController: nil)
    private let maxCountOfLastSearchCities : Int  = 5
    private var foundCities : [City] = []
    private var lastSearchCities : [City] = []
    
    private var searchBarIsEmpty: Bool{
        guard let text = searchController.searchBar.text
            else {
                return false
        }
        return text.isEmpty
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        let wasGetting = defaults.bool(forKey: UserDefaultKeys.getPlacesList )
        if !wasGetting {
            prepare()
            defaults.setValue(true, forKey: UserDefaultKeys.getPlacesList )
        }
        addTapGestureToHideKeyboard()
        lastSearchCities =  getLastCities()
        navigationItem.title = "Погода"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.hidesBarsWhenKeyboardAppears = false
        configureTableView()
        configureSearchController()
        let footer = addFooter()
        self.updateLayout( with: self.view.frame.size)
    }
    
     override func viewWillTransition( to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator ){
        super.viewWillTransition(to : size, with : coordinator)
        coordinator.animate( alongsideTransition: { (context) in
            self.updateLayout(with: size)
        }, completion: nil)
    }
    
    private func updateLayout(with size: CGSize){
        self.cityTableView.frame = CGRect.init( origin : .zero, size : size )
    }
    
    private func getLastCities() -> [City] {
        guard let cities : [City] = defaults.array(forKey: UserDefaultKeys.lastSearchCities) as? [City] else {
            return []
        }
        return cities
    }
}

extension ViewController {

    private func configureTableView(){
        self.view.addSubview( self.cityTableView)
        cityTableView.backgroundColor = .clear
        cityTableView.register(CityCell.self, forCellReuseIdentifier: "CityCell")
        cityTableView.delegate = self
        cityTableView.dataSource = self
        cityTableView.separatorStyle = UITableViewCell.SeparatorStyle(rawValue: 0)!
        
    }
    private func configureSearchController(){
        navigationItem.searchController = searchController
        searchController.searchBar.placeholder = "Поиск"
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        definesPresentationContext = false
        searchController.searchBar.delegate = self
        configureSearchBar()
    }
    private func configureSearchBar() {
        self.searchController.searchBar.barTintColor = .dynamicBackgroundColor
    }
}

extension ViewController: UISearchBarDelegate{
   
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar){
        searchController.searchBar.text = ""
        getNewCities(city: searchController.searchBar.text!)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        getNewCities(city: searchController.searchBar.text!)
        self.cityTableView.reloadData()
    }
}

extension ViewController : UITableViewDataSource{

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if searchBarIsEmpty {
            updateLastCities(city: lastSearchCities[indexPath.row])
        } else {
            updateLastCities( city : foundCities [indexPath.row])
        }
        let newViewController = CityViewController()
        self.navigationController?.pushViewController(newViewController, animated: true)
        }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       return 78
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive {
            return foundCities.count
        }
        return lastSearchCities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CityCell", for: indexPath) as! CityCell
        cell.backgroundColor = .clear
        if searchController.isActive {
            let nowCell = foundCities[indexPath.row]
            cell.city = nowCell
        }
        else {
            let nowCell = lastSearchCities[indexPath.row]
            cell.city = nowCell
        }
        return cell
    }
}

extension ViewController : UITableViewDelegate {}

extension ViewController : UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        getNewCities(city: searchController.searchBar.text!)
        self.cityTableView.reloadData()
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        cityTableView.reloadData()
    }
}

extension City: Comparable {
    static func < (lhs: City, rhs: City) -> Bool {
        return lhs.key < rhs.key
    }
    
    static func == (lhs: City, rhs: City) -> Bool {
        return lhs.key == rhs.key
    }
    
}

extension ViewController {
    private func getNewCities(city: String) {
        do {
            var newFoundCities : [City] = []
            foundCities.removeAll()
            if city.invalid || city.isEmpty
            { DispatchQueue.main.async { self.cityTableView.reloadData() }
                return  }
            let configuration = URLSessionConfiguration.default
            let session = URLSession( configuration: configuration)
            //let accessKey = "qUWACSMA8XxxEni8UkYHGjZBPG9WTkKy"
            //let accessKey = "lrjGSI59G857CNkVurOqm7W2FngsGRGW"
            let accessKey = "txOJDOLABbTlfqMKOcPpy7kkgLs020QC"
            var str =  "http://dataservice.accuweather.com/locations/v1/cities/autocomplete?apikey="+accessKey+"&q="+city
            if str.containsCyrillic {
                str += "&language=ru"
            }
            let url = URL( string: str.encodeUrl )!
            let task = session.dataTask(with: url){  data, response, error in
            if let json = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [[String : Any]] {
                for city  in json {
                    let key = city["Key"] as! String
                    let cityName = city["LocalizedName"] as! String
                    let locationInfo = city["AdministrativeArea"] as! [String : Any]
                    let region = locationInfo["LocalizedName"] as! String
                    
                    let countryInfo = city["Country"] as! [String : Any]
                    let country = countryInfo["LocalizedName"] as! String
                    var place : String = ""
                    if region == "" {
                        place = country
                    } else {
                        place = region + ", " + country
                    }
                    newFoundCities.append( City(Key: key, CityName: cityName, Country: place ))
                }
                self.foundCities = newFoundCities
                DispatchQueue.main.async {
                    self.cityTableView.reloadData()
               }
            }
            }
            task.resume()
        } catch{
            print(error)
        }
    }
}

extension ViewController{
    func addTapGestureToHideKeyboard() {
        let tapGesture = UITapGestureRecognizer(target: view, action: #selector(view.endEditing))
        view.addGestureRecognizer(tapGesture)
    }

    private func updateLastCities(city: City){
        if let index = lastSearchCities.firstIndex(of: city) {
            lastSearchCities.remove(at: index)
        }

        if( lastSearchCities.count == maxCountOfLastSearchCities )
            { lastSearchCities.removeLast() }
        lastSearchCities.insert(city, at: 0)
        
        DispatchQueue.main.async {
             self.cityTableView.reloadData()
        }
        
        let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: lastSearchCities)
        defaults.set(encodedData, forKey: UserDefaultKeys.lastSearchCities )
    }
}


extension ViewController {
    private func prepare(){
        insertCity(cityName: "Пекин", cityKey: "101924")
        insertPlace(cityKey: "101924", name: "Врата Небесного Спокойствия", imageUrl: "", desc: "Врата построены в 1420 году и являются на сегодняшний день одним из главных символов Китая.", descfull: "Врата были построены в период Империи Мин и назывались тогда они Вратами Небесного Наследования, по примеру других ворот с тем же названием и той же конструкции (в традиции Пайлоу), которые находились в Нанкине, городе, бывшем до 1420 года столицей, пока её не перенесли в Пекин. Дважды ворота были разрушены: первый раз молнией в 1457 году (их восстановили по новому проекту, ворота уже тогда выглядели примерно так же, как сегодня), второй раз — участниками крестьянского восстания под предводительством Ли Цзычэна, в 1644 году. Год спустя, когда Пекин стал частью Империи Цин, сооружение начали восстанавливать, а в 1651 году оно получило современное название — Тяньаньмэнь. Между 1969 и 1970 годами врата находились на реконструкции. Поскольку уже тогда они являлись одним из символов Китая, проведение восстановительных работ содержалось под строгим секретом. Главной задачей ремонта было обеспечение сооружения системой водоснабжения, отопления, а также повышение сейсмостойкости объекта.", lon: 116.3915, lat: 39.9031)
        insertPlace(cityKey: "101924", name:"Запретный город", imageUrl: "https://lh3.googleusercontent.com/proxy/R-h-cTC8l08XgKBEc8T8y-1hEB50YWzyU1Wrg_QKMyD97uOi_zDcJ-WwS2IDma4VAIoN99Vsns9IxAIXfZLFjFWnUmDr0j8Yb16ZzYEXHFYVYR-IogD5uXJGzDuM9ggXQW3Mig9wC1IemFnDY1Pw8aR5o6zLoekghA-N-c6wLsqk=w370-h253-n-k-no", desc: "Главный дворцовый комплекс китайских императоров начиная с династии Мин и до конца династии Цин.", descfull: "Запретный город — самый обширный дворцовый комплекс в мире. Находится в центре Пекина, к северу от главной площади Тяньаньмэнь и восточнее озёрного квартала. Главный дворцовый комплекс китайских императоров начиная с династии Мин и до конца династии Цин, то есть с 1420 по 1912 годы; на протяжении всего этого времени служил как местом жительства императоров и членов их семей, так и церемониальным и политическим центром китайского правительства. Отсюда Поднебесной правили 24 императора династий Мин и Цин. Построенный в период с 1406 по 1420 годы, как дворец китайских императоров Мин, дворцовый комплекс с тех пор претерпел множество изменений. Будучи образцом традиционной китайской дворцовой архитектуры, комплекс повлиял на культурное и архитектурное развитие как Восточной Азии, так и других регионов. С 1925 года Запретный город находится в ведении Дворцового музея, чья обширная коллекция произведений искусства и артефактов была сформирована на базе императорских коллекций династий Мин и Цин.", lon :116.3907, lat: 39.9175)
        insertPlace(cityKey: "101924", name: "Национальный стадион", imageUrl: "https://lh5.googleusercontent.com/p/AF1QipOo_ynFkdiTz6lK9_eMfIiPi4TnNx2tsC7oTH-V=w370-h253-n-k-no", desc: "Пекинский национальный стадион, также известный как «Птичье гнездо» — многофункциональный спортивный комплекс.", descfull: "Стадион имеет достаточно интересный и необычный внешний вид. Трибуны стадиона находятся на бетонной «чаше». Вокруг этой «чаши» расположены 24 ферменные колонны, поверх которых находятся переплетения кривых металлических балок. В верхней части этой структуры между переплетением натянуты плёнки из этилентетрафторэтилена, это формирует верхнюю часть покрытия. В нижней же части покрытия использовался политетрафторэтилен. Эти два материала прозрачные, что даёт возможность проникать солнечному свету на трибуны, а также они очень лёгкие. Для строительства стадиона в Китае была разработана новая марка стали, которая отличается почти полным отсутствием сторонних примесей, что в некоторой степени усложняло сварку стальных элементов. Изначально было запланировано возвести стадион с раздвижным покрытием, которое бы полностью закрывало площадь поля.", lon: 116.3903, lat: 39.9915)
        insertPlace(cityKey: "101924", name: "Саньлитунь", imageUrl: "", desc: "Улица, известная многочисленными барами и магазинами зарубежных товаров.", descfull: "В условиях активной конкуренции барных улиц Пекина, таких как Хоухай и Наньлогусян, барная улица Саньлитунь становилась гораздо менее популярной, чем в начале 2000-х годов, но по-прежнему была оживленным местом для ночного отдыха в Пекине. Торговые центры Village и Nali Mall открылись летом 2008 года, благодаря чему в районе появилось множество новых магазинов, ресторанов, баров и многозальный кинотеатр. 19 июля 2008 года в Village появился первый магазин компании Apple. Помимо этого, комплекс Саньлитунь SOHO расположен на западной стороне улицы и используется для коммерческих и жилых целей. На южной улице располагается театр Deyunshe, в котором регулярно происходят выступления с сяншэнами от известных комиков. Вокруг баров улицы также расположены магазины и развлекательные заведения, такие как Pacific Century Place, клуб горячих источников Кайфу и коммерческое офисное здание «Китайская красная улица».", lon: 116.44877, lat: 39.93611)
        

        insertCity(cityName:"Париж", cityKey: "623")
        insertPlace(cityKey: "623", name: "Эйфелева башня", imageUrl: "https://t2.gstatic.com/images?q=tbn:ANd9GcTZqojMuPgBs1hI7sB6dutyGt9oeMf7tX3uDrl58vn_VdTN4wpfIOpCeugZP77x0Ra-mehw3smmmCf0ag", desc: "Увидеть Эйфелеву башню и умереть.", descfull: "Всемирная выставка 1889 года проходила в Париже и была приурочена к столетнему юбилею Великой французской революции. Парижская городская администрация обратилась к известным французским инженерам с предложением принять участие в архитектурном конкурсе. На таком конкурсе следовало создать сооружение, зримо демонстрирующее инженерные и технологические достижения страны. В том числе такое предложение пришло и в инженерное бюро Гюстава Эйфеля. У самого Эйфеля готовой идеи не было, но, порывшись в отложенных проектах, он нашёл эскиз высотной башни, который сделал его сотрудник Мори́с Кёшле́н . В доработке проекта затем принял участие другой сотрудник, Эми́ль Нугье́ . Чертежи 300-метровой железной башни были предложены на конкурс. Предварительно 18 сентября 1884 года Гюстав Эйфель получает совместный со своими сотрудниками патент на проект, а впоследствии выкупает у них же исключительное право.", lon: 2.29453, lat: 48.85836)
        insertPlace(cityKey: "623", name: "Нотр-Дам-де-Пари", imageUrl: "https://lh5.googleusercontent.com/proxy/6WH39cWlcHOOOugVtXLAxtg8Q67FmC-OYaYHLteExvsJmOPdpdVKDqXKvMW3l9r5dQ8ledCHzLy-NYs1Ud1elOGMJXmJKnM-B85tP1NI9-rOpdA-JtvsPB4bTdxAj2Oq7vXRRRXY1bjh7FMgDBmfaWKodUSHwc-9LUVJmM_G7ajP=w370-h253-n-k-no", desc: "Католический храм в центре Парижа, один из символов французской столицы", descfull: "Высота собора — 35 м, длина — 130 м, ширина — 48 м, высота колоколен — 69 м, вес колокола Эммануэль в южной башне — 13 тонн, его языка — 500 кг.  Мощный и величественный фасад разделён по вертикали на три части пилястрами, а по горизонтали — на три яруса галереями, при этом нижний ярус, в свою очередь, имеет три глубоких портала: портал Страшного суда , портал Богородицы  и портал. Над ними идёт аркада  с двадцатью восемью статуями, представляющими царей древней Иудеи. Как и в других готических храмах, здесь нет настенной живописи, и единственным источником света являются многочисленные витражи высоких стрельчатых окон.", lon: 2.34993, lat: 48.85291)
        insertPlace(cityKey: "623", name: "Лувр", imageUrl: "https://t0.gstatic.com/images?q=tbn:ANd9GcRs8t363LfBFdpDAWAaP9G39O32eKfyi_OcJ5hHmXxPuYg8Q9nqLGjO8yFhnzQcl14OKAXlIwBO6Mpf0w", desc: "Один из крупнейших и самый популярный художественный музей мира", descfull: "В основе Лувра лежит замок-крепость — Большая башня Лувра, — возведённая королём Филиппом-Августом в 1190 году. Одним из главных предназначений замка было наблюдение низовий Сены, одного из традиционных путей вторжений и набегов эпохи викингов. В 1317 году, после передачи имущества Тамплиеров Мальтийскому ордену, королевская казна переносится в Лувр. Карл V делает из замка королевскую резиденцию. Устаревшая Большая башня Лувра была разрушена по приказу Франциска I в 1528 году, и в 1546 начинается превращение крепости в великолепную королевскую резиденцию. Эти работы проведены Пьером Леско и продолжались во время правления Генриха II и Карла IX. Два новых крыла были присоединены к зданию. В 1594 году Генрих IV решает соединить Лувр с дворцом Тюильри, построенным по желанию Екатерины Медичи", lon: 2.33437, lat: 48.86102)
        
        insertCity(cityName: "Прага" , cityKey: "125594")
        insertPlace(cityKey: "125594", name: "Карлов мост", imageUrl: "https://t1.gstatic.com/images?q=tbn:ANd9GcQY8CY9lcXk8TR5zV7_9m-0OeG51qzVPUuQfHscv8AesXwUDYo-hAe-ZgQt5KCnT7JiXSAfE04suLci3w", desc: "Средневековый мост в Праге через реку Влтаву, соединяющий исторические районы Мала Страна и Старое Место", descfull: "Мост является связующим звеном между Пражским градом и Старым Городом. Через мост вела так называемая «Королевская дорога» (а ныне проходит Пражский марафон). С мостом связаны многие ключевые события в истории города. Например, в 1420 году мост помог попасть гуситам на Малую Страну, а в 1648 году с этого моста шведы, захватившие и разграбившие Град и Малу Страну, атаковали правобережный Старый Город.", lon: 14.40772, lat: 50.08702)
        insertPlace(cityKey: "125594", name: "Пражский Град", imageUrl: "https://t1.gstatic.com/images?q=tbn:ANd9GcSR6b0X0GhkGNG2GwbHsKwkgUscL7rdGeWeHj3L-i8vrPPhayZaOQZ_7wIleGh7daicbXyresTB1UE8nQ", desc: "Национальный памятник культуры Чешской Республики.", descfull: "Прага всегда была центром чешских земель, от которого зависела судьба народа. Соответственно, постоянно приходилось прикладывать усилия для её защиты. Кроме того, в городе находились королевские драгоценности, которые также привлекали неприятелей.Разные формы фортификационных сооружений были на территории города всегда. Сначала славянские городища, в середине IX века появился Пражский град с земляными валами, в середине XI века он стал укреплён каменными стенами. На другой стороне реки возник Вышеград, появились Старе-Место, Мала-Страна, Градчаны, Нове-Место — четыре «города», так как имели свои крепостные стены; сейчас это исторические районы Праги.        В XVII и XVIII веках всё это постепенно превратилось в комплексную систему бастионных укреплений, которая к XIX веку потеряла смысл из-за развития военных технологий.С другой стороны, Пражский град развивался не только как крепость, но и как резиденция чешских королей и культурный центр.", lon: 14.40024, lat: 50.09062)
        insertPlace(cityKey: "125594", name: "Национальная галерея", imageUrl: "https://t1.gstatic.com/images?q=tbn:ANd9GcRRfnAvOsrZq-EQNfGz3lrsqeDqt4PoZlAoWe_TJqLJK4ozxIMG8Y0X_iz2plFMX_ZpCFRzDKJcJGtYkw", desc: "Государственная организация, в ведении которой находятся крупнейшие коллекции изобразительного искусства.", descfull: "История галереи началась 5 февраля 1796 года, когда группой патриотически настроенных чешских аристократов и просвещённых интеллектуалов из среднего класса было создано Общество патриотических друзей искусства для просвещения и приобщения к искусству населения. Общество основало две организации — Академию искусств и Галерею, открытую для посещений горожан. Именно она стала предшественницей современной Национальной галереи. \n В 1902 году Общество организовало Галерею современного искусства Чешского королевства, в которую вошла коллекция, подаренная императором Францем Иосифом I. \n В 1918 году коллекция Общества стала главным художественным собранием Чехословакии.\n В 1942 году к Галерее, называвшейся тогда Чешско-Моравская земская галерея, были присоединены коллекции расформированной Галереи современного искусства Чешского королевства. Законом 1949 года была образована Национальная галерея в Праге. В собрание вошли также графические коллекции Национального музея и Университетской библиотеки.", lon: 14.3966, lat: 50.09028)
    }
}
