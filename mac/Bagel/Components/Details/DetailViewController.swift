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
        
        
        let requestHeaders = self.storyboard?.instantiateController(withIdentifier: KeyValueListViewController.identifier) as! KeyValueListViewController
        requestHeaders.viewModel = RequestHeadersViewModel()
        requestHeaders.viewModel?.register()
        let requestHeadersTabItem = NSTabViewItem(viewController: requestHeaders)
        
        
        let requestParameters = self.storyboard?.instantiateController(withIdentifier: KeyValueListViewController.identifier) as! KeyValueListViewController
        requestParameters.viewModel = RequestParametersViewModel()
        requestParameters.viewModel?.register()
        let requestParametersTabItem = NSTabViewItem(viewController: requestParameters)
        
        
        let requestBody = self.storyboard?.instantiateController(withIdentifier: DataViewController.identifier) as! DataViewController
        requestBody.viewModel = RequestBodyViewModel()
        requestBody.viewModel?.register()
        let requestBodyTabItem = NSTabViewItem(viewController: requestBody)
        
        
        let responseHeaders = self.storyboard?.instantiateController(withIdentifier: KeyValueListViewController.identifier) as! KeyValueListViewController
        responseHeaders.viewModel = ResponseHeadersViewModel()
        responseHeaders.viewModel?.register()
        let responseHeadersTabItem = NSTabViewItem(viewController: responseHeaders)
        
        
        let responseData = self.storyboard?.instantiateController(withIdentifier: DataViewController.identifier) as! DataViewController
        responseData.viewModel = ResponseDataViewModel()
        responseData.viewModel?.register()
        let responseDataTabItem = NSTabViewItem(viewController: responseData)
        
        
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
        self.httpMethodTextField.stringValue = self.viewModel?.packet?.requestInfo?.requestMethod ?? ""
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
