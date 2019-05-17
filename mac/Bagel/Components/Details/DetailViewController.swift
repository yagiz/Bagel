//
//  DetailViewController.swift
//  Bagel
//
//  Created by Yagiz Gurgul on 30/08/2018.
//  Copyright © 2018 Yagiz Lab. All rights reserved.
//

import Cocoa

enum DetailType: Int {
    case overview = 0
    case requestHeaders = 1
    case requestParameters = 2
    case requestBody = 3
    case responseHeaders = 4
    case responseBody = 5
}

class DetailViewController: BaseViewController {

    var viewModel: DetailViewModel?
    
    @IBOutlet weak var urlTextField: NSTextField!
    @IBOutlet weak var httpMethodTextField: NSTextFieldCell!
    
    @IBOutlet weak var detailButtonOverview: NSButton!
    @IBOutlet weak var detailButtonRequestHeaders: NSButton!
    @IBOutlet weak var detailButtonRequestParameters: NSButton!
    @IBOutlet weak var detailButtonRequestBody: NSButton!
    @IBOutlet weak var detailButtonResponseHeaders: NSButton!
    @IBOutlet weak var detailButtonResponseBody: NSButton!
    
    var overview: OverviewViewController?
    var requestHeaders: KeyValueListViewController?
    var requestParameters: KeyValueListViewController?
    var requestBody: DataViewController?
    var responseHeaders: KeyValueListViewController?
    var responseData: DataViewController?
    
    var sections = [DetailSectionProtocol?]()
    var typeButtons = [NSButton]()
    
    @IBOutlet weak var tabView: NSTabView!
    var currentDetailType = DetailType.overview
    
    override func setup() {
        
        self.setupDetailTypeViews()
        
        self.viewModel?.onChange = { [weak self] in
            
            self?.refresh()
        }
        
        self.typeButtons.append(self.detailButtonOverview)
        self.typeButtons.append(self.detailButtonRequestHeaders)
        self.typeButtons.append(self.detailButtonRequestParameters)
        self.typeButtons.append(self.detailButtonRequestBody)
        self.typeButtons.append(self.detailButtonResponseHeaders)
        self.typeButtons.append(self.detailButtonResponseBody)
        
        self.refresh()
    }
    
    func setupDetailTypeViews() {
        
        let overview = self.storyboard?.instantiateController(withIdentifier: OverviewViewController.identifier) as! OverviewViewController
        overview.viewModel = OverviewViewModel()
        overview.viewModel?.register()
        let overviewTabItem = NSTabViewItem(viewController: overview)
        
        
        self.requestHeaders = self.storyboard?.instantiateController(withIdentifier: KeyValueListViewController.identifier) as? KeyValueListViewController
        self.requestHeaders?.viewModel = RequestHeadersViewModel()
        self.requestHeaders?.viewModel?.register()
        let requestHeadersTabItem = NSTabViewItem(viewController: self.requestHeaders!)
        
        
        self.requestParameters = self.storyboard?.instantiateController(withIdentifier: KeyValueListViewController.identifier) as? KeyValueListViewController
        self.requestParameters?.viewModel = RequestParametersViewModel()
        self.requestParameters?.viewModel?.register()
        let requestParametersTabItem = NSTabViewItem(viewController: self.requestParameters!)
        
        
        self.requestBody = self.storyboard?.instantiateController(withIdentifier: DataViewController.identifier) as? DataViewController
        self.requestBody?.viewModel = RequestBodyViewModel()
        self.requestBody?.viewModel?.register()
        let requestBodyTabItem = NSTabViewItem(viewController: self.requestBody!)
        
        
        self.responseHeaders = self.storyboard?.instantiateController(withIdentifier: KeyValueListViewController.identifier) as? KeyValueListViewController
        self.responseHeaders?.viewModel = ResponseHeadersViewModel()
        self.responseHeaders?.viewModel?.register()
        let responseHeadersTabItem = NSTabViewItem(viewController: self.responseHeaders!)
        
        
        self.responseData = self.storyboard?.instantiateController(withIdentifier: DataViewController.identifier) as? DataViewController
        self.responseData?.viewModel = ResponseDataViewModel()
        self.responseData?.viewModel?.register()
        let responseDataTabItem = NSTabViewItem(viewController: self.responseData!)
        
        
        self.tabView.addTabViewItem(overviewTabItem)
        self.tabView.addTabViewItem(requestHeadersTabItem)
        self.tabView.addTabViewItem(requestParametersTabItem)
        self.tabView.addTabViewItem(requestBodyTabItem)
        self.tabView.addTabViewItem(responseHeadersTabItem)
        self.tabView.addTabViewItem(responseDataTabItem)
    }
    
    @IBAction func selectDetailButtonAction(_ sender: NSButton) {
        
        self.currentDetailType = DetailType(rawValue: self.typeButtons.firstIndex(of: sender)!)!
        self.refresh()
    }
    
    func refresh() {
        
        self.refreshTypeButtons()
        
        self.tabView.selectTabViewItem(at: self.currentDetailType.rawValue)
        self.urlTextField.stringValue = self.viewModel?.packet?.requestInfo?.url ?? ""
        self.httpMethodTextField.stringValue = self.viewModel?.packet?.requestInfo?.requestMethod?.rawValue ?? ""
    
        if let detailSection = self.tabView.selectedTabViewItem?.viewController as? DetailSectionProtocol {
            detailSection.refreshViewModel()
        }
    }
    
    func refreshTypeButtons() {
        
        for (index, typeButton) in self.typeButtons.enumerated() {
            
            if index == self.currentDetailType.rawValue {
                
                typeButton.state = .on
            }else {
                typeButton.state = .off
            }
        }
    }
}
