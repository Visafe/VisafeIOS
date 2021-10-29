/**
    This file is part of Visafe for iOS (https://github.com/VisafeTeam/VisafeForiOS).
    Copyright © Visafe Software Limited. All rights reserved.

    Visafe for iOS is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    Visafe for iOS is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with Visafe for iOS.  If not, see <http://www.gnu.org/licenses/>.
 */

protocol ISettingsResetor {
    func resetAllSettings()
}

// Reset statistics and settings
struct SettingsResetor: ISettingsResetor {
    
    //MARK: - Properties
    
    private weak var appDelegate: AppDelegate?
    private let dnsFiltersService: DnsFiltersServiceProtocol
    private let filtersService: FiltersServiceProtocol
    private let vpnManager: VpnManagerProtocol
    private let resources: AESharedResourcesProtocol
    private let activityStatisticsService: ActivityStatisticsServiceProtocol
    private let dnsStatisticsService: DnsStatisticsServiceProtocol
    private let dnsLogRecordsService: DnsLogRecordsServiceProtocol
    
    //MARK: - Init
    
    init(appDelegate: AppDelegate,
         dnsFiltersService: DnsFiltersServiceProtocol,
         filtersService: FiltersServiceProtocol,
         vpnManager: VpnManagerProtocol,
         resources: AESharedResourcesProtocol,
         activityStatisticsService: ActivityStatisticsServiceProtocol,
         dnsStatisticsService: DnsStatisticsServiceProtocol,
         dnsLogRecordsService: DnsLogRecordsServiceProtocol) {
        
        self.appDelegate = appDelegate
        self.dnsFiltersService = dnsFiltersService
        self.filtersService = filtersService
        self.vpnManager = vpnManager
        self.resources = resources
        self.activityStatisticsService = activityStatisticsService
        self.dnsStatisticsService = dnsStatisticsService
        self.dnsLogRecordsService = dnsLogRecordsService
    }
    
    //MARK: - IResetSettings methods
    
    func resetAllSettings() {
        presentAlert()
        
        DispatchQueue(label: "reset_queue").async {
            DDLogInfo("(ResetSettings) resetAllSettings")

            self.filtersService.reset()
            self.vpnManager.removeVpnConfiguration { _ in }
            self.resources.reset()
            resetStatistics()
            
            self.dnsFiltersService.reset()
            
            appDelegate?.setAppInterfaceStyle()
            
            let providersService: DnsProvidersServiceProtocol = ServiceLocator.shared.getService()!
            providersService.reset()
            
            if #available(iOS 14.0, *) {
                let nativeProviders: NativeProvidersServiceProtocol = ServiceLocator.shared.getService()!
                nativeProviders.reset()
            }
            
            // force load filters to fill database
            self.filtersService.load(refresh: true) {}
            
            
            DispatchQueue.main.async {
//                appDelegate?.setMainPageAsCurrentAndPopToRootControllersEverywhere()
                DDLogInfo("(ResetSettings) Reseting is over")
            }
        }
    }
    
    //MARK: - Private methods
    
    private func resetStatistics(){
        /* Reseting statistics Start*/
        self.activityStatisticsService.stopDb()
        self.dnsStatisticsService.stopDb()
        
        // delete database file
        let url = self.resources.sharedResuorcesURL().appendingPathComponent("dns-statistics.db")
        do {
            try FileManager.default.removeItem(atPath: url.path)
            DDLogInfo("(ResetSettings) Statistics removed successfully")
        } catch {
            DDLogInfo("(ResetSettings) Statistics removing error: \(error.localizedDescription)")
        }
        
        /* Reseting statistics end */
        self.activityStatisticsService.startDb()
        self.dnsStatisticsService.startDb()
        
        self.dnsLogRecordsService.reset()
    }
    
    private func presentAlert() {
        let alert = UIAlertController(title: nil, message: String.localizedString("loading_message"), preferredStyle: .alert)

        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.startAnimating();

        alert.view.addSubview(loadingIndicator)
        appDelegate?.window?.rootViewController?.present(alert, animated: true, completion: nil)
    }
}
