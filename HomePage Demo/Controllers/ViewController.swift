//
//  ViewController.swift
//  HomePage Demo
//
//  Created by DREAMWORLD on 18/07/24.
//

import UIKit

class ViewController: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var col_images: UICollectionView!
    @IBOutlet weak var page_control: UIPageControl!
    @IBOutlet weak var search_bar: UISearchBar!
    @IBOutlet weak var tbl_list: UITableView!
    @IBOutlet weak var btn_bottom: UIButton!
    @IBOutlet weak var con_table_height: NSLayoutConstraint!
    @IBOutlet weak var lbl_no_data: UILabel!
    
    //MARK: - Variables
    
    var timer: Timer?
    let timeInterval: Double = 5
    var counter = 0
    var itemList = [NSDictionary]()
    var searchedItemList = [NSDictionary]()// List of Image here or from api
    var carasoulItems = 5
    var carasoulitemsList = [NSDictionary]()
    private var contentSizeObservation: NSKeyValueObservation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        collectionviewSetup()
        tableviewSetup()
        
        search_bar.delegate = self
        
        if let layout = col_images.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
            layout.itemSize = CGSize(width: view.frame.width, height: view.frame.height)
            layout.minimumLineSpacing = 0
        }
        
        btn_bottom.layer.masksToBounds = true
        btn_bottom.layer.cornerRadius = btn_bottom.frame.height / 2
        page_control.addTarget(self, action: #selector(pageControlChanged), for: .valueChanged)
        contentSizeObservation = tbl_list.observe(\.contentSize, options: .new, changeHandler: { [weak self] (tbl, _) in
            guard let self = self else { return }
            self.con_table_height.constant = tbl.contentSize.height
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        LoadingView.shared.showOverlay(view: view)
        APIHelper.shared.fetchPhotos(completion: { result, error in
            guard error == nil else {
                print(error?.localizedDescription ?? "") // Here we can add alert message
                self.showPopup(message: error?.localizedDescription ?? "")
                return
            }
            
            self.itemList = ((result ?? []) as [NSDictionary])
            self.searchedItemList = self.itemList
            self.carasoulitemsList = []
            
            if self.itemList.count > self.carasoulItems{
                for i in 0..<self.carasoulItems{
                    self.carasoulitemsList.append(self.itemList[i])
                }
            }else{
                self.carasoulitemsList = self.itemList
            }
            
            DispatchQueue.main.async {
                self.col_images.reloadData()
                self.tbl_list.reloadData()
                
                self.lbl_no_data.isHidden = self.searchedItemList.count > 0 // Hide no data label when data empty
                self.tbl_list.isHidden = self.searchedItemList.count == 0 // Hide table when data empty
                
                self.page_control.numberOfPages = self.carasoulitemsList.count // Example page count
                self.page_control.currentPage = 0
                
                LoadingView.shared.hideOverlayView()
                
                self.timer = Timer.scheduledTimer(timeInterval: self.timeInterval, target: self, selector: #selector(self.scrollNext), userInfo: nil, repeats: true)
            }
        })
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        timer = nil
        timer?.invalidate()
    }
    
    deinit {
        contentSizeObservation?.invalidate()
    }
    
    @objc func scrollNext(){
        guard self.carasoulitemsList.count > 1 else {
            timer?.invalidate()
            return
        }
        
        if counter < self.carasoulitemsList.count-1 {
            counter += 1
        }else{
            counter = 0
        }
        page_control.currentPage = counter
        guard self.carasoulitemsList.count > counter else { return }
        col_images.scrollToItem(at: IndexPath(item: counter, section: 0), at: .right, animated: true)
        
    }
    
    //    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
    //          autoScrollPaused = true
    //      }
    //
    //      func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    //          updatePageControl()
    //          autoScrollPaused = false
    //      }
    //
    //      func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
    //          if !decelerate {
    //              updatePageControl()
    //              autoScrollPaused = false
    //          }
    //      }
    
    func updatePageControl() {
        let page = Int(col_images.contentOffset.x / col_images.frame.width)
        page_control.currentPage = page
    }
    
    @objc func pageControlChanged(_ sender: UIPageControl) {
        counter = sender.currentPage
        let indexPath = IndexPath(item: counter, section: 0)
        col_images.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    
    //MARK: - Actions
    @IBAction func BTNBottomSheetAction(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let bottomSheetVC = storyboard.instantiateViewController(withIdentifier: "BottomSheetViewController") as? BottomSheetViewController {
            bottomSheetVC.list = ["apple", "banana", "orange", "blueberry"] // Replace with your actual list
            bottomSheetVC.modalPresentationStyle = .pageSheet
            present(bottomSheetVC, animated: true, completion: nil)
        }
    }
    
}

//MARK: - tableView Setup
extension ViewController: UISearchBarDelegate{
    
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        var search = searchBar.text!
           if let r = Range(range, in: search){
               search.removeSubrange(r) // it will delete any deleted string.
           }
           search.insert(contentsOf: text, at: search.index(search.startIndex, offsetBy: range.location)) // it will insert any text.
           print(search)
        
        if search == ""{
            searchedItemList = itemList
        }else{
            searchedItemList = itemList.filter({($0.value(forKey: "id") as? String ?? "").lowercased().contains(search.lowercased())})
            if searchedItemList.isEmpty{
                searchedItemList = itemList.filter({($0.value(forKey: "url") as? String ?? "").lowercased().contains(search.lowercased())})
            }
        }
        tbl_list.reloadData()
        self.lbl_no_data.isHidden = self.searchedItemList.count > 0
        self.tbl_list.isHidden = self.searchedItemList.count == 0
        return true
    }
}

//MARK: - tableView Setup
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableviewSetup() {
        tbl_list.delegate = self
        tbl_list.dataSource = self
        tbl_list.register(UINib(nibName: "ListTableCell", bundle: nil), forCellReuseIdentifier: "ListTableCell")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchedItemList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tbl_list.dequeueReusableCell(withIdentifier: "ListTableCell", for: indexPath) as! ListTableCell
        let item = searchedItemList[indexPath.row]
        
        cell.lbl_title.text = item.value(forKey: "id") as? String ?? "Title #\(indexPath.row+1)"
        cell.lbl_subtitle.text = item.value(forKey: "url") as? String ?? "Subtitle #\(indexPath.row+1)"
        
        if let image_url = item.value(forKey: "url") as? String{
            cell.img_item.setImageFromStringrURL(stringUrl: image_url)
        }else{
            cell.img_item.image = UIImage(named: "img_test")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
}

//MARK: - collectionView Setup
extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionviewSetup() {
        col_images.delegate = self
        col_images.dataSource = self
        col_images.register(UINib(nibName: "HomeCVC", bundle: nil), forCellWithReuseIdentifier: "HomeCVC")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return carasoulitemsList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = col_images.dequeueReusableCell(withReuseIdentifier: "HomeCVC", for: indexPath) as! HomeCVC
        let item = carasoulitemsList[indexPath.row]
        if let image_url = item.value(forKey: "url") as? String{
            cell.image.setImageFromStringrURL(stringUrl: image_url)
        }else{
            cell.image.image = UIImage(named: "img_test")
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: col_images.bounds.width, height: col_images.bounds.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        counter = indexPath.row
        page_control.currentPage = indexPath.row
    }
    
}
