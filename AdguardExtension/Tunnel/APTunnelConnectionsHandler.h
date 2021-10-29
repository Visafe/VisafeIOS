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

@import NetworkExtension;

@class APTUdpProxySession, PacketTunnelProvider;
@protocol DnsProxyServiceProtocol;

/////////////////////////////////////////////////////////////////////
#pragma mark - APTunnelConnectionsHandler

/**
 Class controller for UDP sessions, which controls of the DNS traffic.
 */
@interface APTunnelConnectionsHandler : NSObject

/////////////////////////////////////////////////////////////////////
#pragma mark Init and Class methods

- (id)initWithProvider:(nonnull PacketTunnelProvider *)provider dnsProxy: (id<DnsProxyServiceProtocol>) dnsProxy;

/////////////////////////////////////////////////////////////////////
#pragma mark Properties and public methods

@property (weak, readonly) PacketTunnelProvider *provider;

/**
 Make the initial readPacketsWithCompletionHandler call.
 */
- (void)startHandlingPackets;

@end
