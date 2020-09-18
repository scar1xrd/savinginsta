//
//  SettingsViewController.m
//  Saving insta
//
//  Created by Igor Sorokin on 17.05.2020.
//  Copyright © 2020 Igor Sorokin. All rights reserved.
//

#import "SettingsViewController.h"

@interface SettingsViewController ()

@property (weak, nonatomic) IBOutlet UISwitch *autodownloadSwitch;

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setup];
}

- (void)setup {
    BOOL isAutoDownload = [NSUserDefaults.standardUserDefaults boolForKey:@"is_autodownload"];
    [self.autodownloadSwitch setOn:isAutoDownload];
}

- (IBAction)autodownloadAction:(UISwitch *)sender {
    [NSUserDefaults.standardUserDefaults setBool:sender.isOn forKey:@"is_autodownload"];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 1 && indexPath.row == 0) {
        UIViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:NSBundle.mainBundle] instantiateViewControllerWithIdentifier:@"OnboardingViewController"];
        [self presentViewController:controller animated:YES completion:nil];
    }
}

@end
