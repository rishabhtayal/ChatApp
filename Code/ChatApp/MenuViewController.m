//
//  MenuViewController.m
//  ChatApp
//
//  Created by Rishabh Tayal on 5/5/14.
//  Copyright (c) 2014 Rishabh Tayal. All rights reserved.
//

#import "MenuViewController.h"
#import "FriendsListViewController.h"
#import "NearChatViewController.h"
#import "SettingsViewController.h"
#import <MFSideMenu.h>
#import "UIImage+Utility.h"
#import <Parse/Parse.h>
#import "ActivityView.h"
#import "AppDelegate.h"
#import "Friend.h"
#import "Group.h"
#import "IntroViewController.h"
#import "Chat.h"
#import <MaveSDK.h>
#import "MenuButton.h"

@interface MenuViewController ()

@property (strong) NearChatViewController* near;
@property (strong) FriendsListViewController* friends;
@property (strong) SettingsViewController* settings;

@end

@implementation MenuViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"vCinity";
    
    self.tableView.scrollsToTop = NO;
    
    UIImage* img = [UIImage imageNamed:@"menu_background"];
    UIImage* blurImage = [img applyGaussianBlur];
    UIImageView* iv = [[UIImageView alloc] initWithImage:blurImage];
    iv.contentMode = UIViewContentModeScaleAspectFill;
    iv.frame = self.tableView.frame;
    self.tableView.backgroundView = iv;
    self.tableView.backgroundColor = [UIColor clearColor];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UIImageView* navImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 32, 32)];
    navImage.layer.cornerRadius = navImage.frame.size.height / 2;
    navImage.layer.masksToBounds = YES;
    PFFile* file = [PFUser currentUser][kPFUser_Picture];
    [file getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        navImage.image = [UIImage imageWithData:data];
    }];
    //    UIImage* image = [UIImage imageWithData:[file getData]];
    //    navImage.image = image;
    navImage.contentMode = UIViewContentModeScaleAspectFill;
    navImage.clipsToBounds = YES;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:navImage];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 3;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.selectedBackgroundView = [UIView new];
        
    }
    cell.textLabel.textColor = [UIColor lightGrayColor];
    cell.textLabel.highlightedTextColor = [UIColor kRedColor];
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.textLabel.font = [UIFont systemFontOfSize:28];
    cell.backgroundColor = [UIColor clearColor];
    
    // Configure the cell...
    switch (indexPath.row) {
        case 0:
        {
            cell.textLabel.text = NSLocalizedString(@"vCinity Chat", nil);
            cell.imageView.image = [UIImage imageNamed:@"chat-off"];
            cell.imageView.highlightedImage = [[UIImage imageNamed:@"chat-off"] imageWithColor:[UIColor kRedColor]];
        }
            break;
//        case 1:
//        {
//            cell.textLabel.text = NSLocalizedString(@"Friends", nil);
//            cell.imageView.image = [UIImage imageNamed:@"sillouhette-off"];
//            cell.imageView.highlightedImage = [[UIImage imageNamed:@"sillouhette-off"] imageWithColor:[UIColor kRedColor]];
//        }
//            break;
        case 1:
        {
            cell.textLabel.text = NSLocalizedString(@"Invite", nil);
            cell.imageView.image = [[UIImage imageNamed:@"share-off"] imageWithColor:[UIColor lightGrayColor]];
            cell.imageView.highlightedImage = [[UIImage imageNamed:@"share-off"] imageWithColor:[UIColor kRedColor]];
        }
            break;
        case 2:
        {
            cell.textLabel.text = NSLocalizedString(@"Settings", nil);
            cell.imageView.image = [UIImage imageNamed:@"settings-off"];
            cell.imageView.highlightedImage = [[UIImage imageNamed:@"settings-off"] imageWithColor:[UIColor kRedColor]];
        }
            break;
        default:
        {
            cell.textLabel.text = NSLocalizedString(@"Logout", nil);
            cell.imageView.image = [UIImage imageNamed:@"logout-off"];
            cell.imageView.highlightedImage = [[UIImage imageNamed:@"logout-off"] imageWithColor:[UIColor kRedColor]];
        }
            break;
    }
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    __block NSMutableArray* array;
    UIStoryboard* sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    switch (indexPath.row) {
        case 0:
        {
            if (!_near) {
                _near = [sb instantiateViewControllerWithIdentifier:@"NearChatViewController"];
                AppDelegate* appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
                appDelegate.sessionController = [[SessionController alloc] initWithDelegate:_near];
            }
            array = [[NSMutableArray alloc] initWithObjects:[[UINavigationController alloc] initWithRootViewController:_near], nil];
            self.menuContainerViewController.centerViewController = array[0];
            [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
        }
            break;
//        case 1:
//        {
//            if ([PFUser currentUser] == nil) {
//                DLog(@"Show login");
//                AppDelegate* appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
//                [appDelegate setLoginViewModal:YES];
//            } else {
//                if (!_friends)
//                    _friends = [sb instantiateViewControllerWithIdentifier:@"FriendsListViewController"];
//                array = [[NSMutableArray alloc] initWithObjects:[[UINavigationController alloc] initWithRootViewController:_friends], nil];
//                self.menuContainerViewController.centerViewController = array[0];
//                [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
//            }
//        }
            break;
        case 1:
        {
            MaveSDK* mave = [MaveSDK sharedInstance];
//            MAVEUserData* userData = [[MAVEUserData alloc] initWithUserID:@"1" firstName:@"Rishabh" lastName:@"Tayal"];
            [mave identifyAnonymousUser];
            [mave presentInvitePagePushWithBlock:^(UIViewController *inviteController) {
                [MenuButton setupLeftMenuBarButtonOnViewController:inviteController];
                [((UIButton*)inviteController.navigationItem.leftBarButtonItem.customView) removeTarget:inviteController action:nil forControlEvents:UIControlEventTouchUpInside];
                [((UIButton*)inviteController.navigationItem.leftBarButtonItem.customView) addTarget:self action:@selector(leftMenuPressed:) forControlEvents:UIControlEventTouchUpInside];
                inviteController.navigationItem.rightBarButtonItem = nil;
                array = [[NSMutableArray alloc] initWithObjects:[[UINavigationController alloc] initWithRootViewController:inviteController] , nil];
                self.menuContainerViewController.centerViewController = array[0];
                [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
            } forwardBlock:^(UIViewController *controller, NSUInteger numberOfInvitesSent) {
                
            } backBlock:^(UIViewController *controller, NSUInteger numberOfInvitesSent) {
                
            } inviteContext:@"default"];
        }
            break;
        case 2:
        {
            if (!_settings)
                _settings = [sb instantiateViewControllerWithIdentifier:@"SettingsViewController"];
            array = [[NSMutableArray alloc] initWithObjects:[[UINavigationController alloc] initWithRootViewController:_settings], nil];
            self.menuContainerViewController.centerViewController = array[0];
            [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
        }
            break;
        default:
        {
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            UIActionSheet* sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil) destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"Logout", nil), nil];
            [sheet showInView:self.view.window];
        }
            break;
    }
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [ActivityView showInView:self.navigationController.view loadingMessage:@"Logging out..."];
        [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(performLogout) userInfo:nil repeats:NO];
    }
}

-(void)performLogout __attribute__((unavailable("Update Parse API to enable login feature.")))
{
    [ActivityView hide];
    
    [Friend MR_truncateAll];
    [Group MR_truncateAll];
    [Chat MR_truncateAll];
    [PFUser logOut];
    
    [[UIApplication sharedApplication] unregisterForRemoteNotifications];
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:false] forKey:kUDKeyUserLoggedIn];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kUDKeyLoginSkipped];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    AppDelegate* appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    [appDelegate setLoginViewModal:NO];
}

-(void)leftMenuPressed:(id)sender
{
    [self.menuContainerViewController toggleLeftSideMenuCompletion:nil];
}

@end
