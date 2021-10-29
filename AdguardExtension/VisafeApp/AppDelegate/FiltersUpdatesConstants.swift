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

struct FiltersUpdatesConstants {
    static let executionPeriodTime: Double = 3600 // 1 hours
    static let executionLeeway: Double = 5 // 5 seconds
    static let executionDelay: Double = 2 // 2 seconds
    
    static let checkFiltersUpdatesPeriod: Double = executionPeriodTime * 6
    static let checkFiltersUpdatesFromUiDelay: Double = executionDelay
    static let checkFiltersUpdatesLeeway: Double = executionLeeway
    static let checkFiltersUpdatesDefaultPeriod: Double = executionPeriodTime * 6
    
    static let fetchUpdateStatusPeriod: Double = checkFiltersUpdatesPeriod / 6
    static let dnsFiltersCheckLimit: Double = 21600 // 6 hours
    
    /// Timeout for downloading of data from the remote services
    static  let urlLoadTimeout: Double = 60
}
