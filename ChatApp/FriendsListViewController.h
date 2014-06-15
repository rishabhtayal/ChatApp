//
//  FriendsListViewController.h
//  ChatApp
//
//  Created by Rishabh Tayal on 5/5/14.
//  Copyright (c) 2014 Rishabh Tayal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SWTableViewCell/SWTableViewCell.h>
#import <GADInterstitial.h>

@interface FriendsListViewController : UITableViewController<SWTableViewCellDelegate, GADInterstitialDelegate>

-(IBAction)inviteFriend:(id)sender;

@end
