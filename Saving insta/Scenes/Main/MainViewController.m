//
//  ViewController.m
//  Saving insta
//
//  Created by Igor Sorokin on 11.05.2020.
//  Copyright © 2020 Igor Sorokin. All rights reserved.
//

#import <IQKeyboardManagerSwift-Swift.h>
#import <MBProgressHUD/MBProgressHUD.h>
#import <Saving_insta-Swift.h>

#import "MainViewController.h"
#import "MainView.h"
#import "MediaInfo.h"
#import "MediaCollectionViewCell.h"
#import "UIViewController+Utils.h"
#import "MainPresenter.h"

@interface MainViewController ()
<
UICollectionViewDataSource,
NSURLSessionDelegate
>

@property (weak, nonatomic) UICollectionView *collectionView;
@property (weak, nonatomic) UILabel *captionLabel;
@property (weak, nonatomic) UIButton *captionCopyButton;
@property (weak, nonatomic) UITextField *linkTextField;
@property (weak, nonatomic) LoadingButton *downloadButton;
@property (weak, nonatomic) UIButton *downloadMediaButton;

@property (nonatomic, nonnull) MainPresenter *presenter;
@property (weak, nonatomic, nullable) MBProgressHUD *currentHUD;

@end

@implementation MainViewController

- (void)dealloc {
    [NSNotificationCenter.defaultCenter removeObserver:self];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    MainView *mainView = (MainView *)self.view;
    self.collectionView = mainView.collectionView;
    self.captionLabel = mainView.captionLabel;
    self.captionCopyButton = mainView.captionCopyButton;
    self.linkTextField = mainView.linkTextField;
    self.downloadButton = mainView.downloadButton;
    self.downloadMediaButton = mainView.downloadMediaButton;
    
    [self setup];
    [self startObservers];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    NSUserDefaults *userDefaults = NSUserDefaults.standardUserDefaults;
    if (![userDefaults boolForKey:@"firstLaunch"]) {
        UIViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:NSBundle.mainBundle] instantiateViewControllerWithIdentifier:@"OnboardingViewController"];
        [self presentViewController:controller animated:YES completion:nil];
        [userDefaults setBool:YES forKey:@"firstLaunch"];
    }
}

- (void)setup {
    self.presenter = [[MainPresenter alloc] initViewController:self];
    self.collectionView.dataSource = self;
    CGFloat inset = (self.collectionView.frame.size.width - self.collectionView.frame.size.height) / 2;
    self.collectionView.contentInset = UIEdgeInsetsMake(0, inset, 0, inset);
    
    CGFloat itemSide = self.collectionView.frame.size.height - 15;
    PagingCollectionViewLayout *layout = (PagingCollectionViewLayout *)self.collectionView.collectionViewLayout;
    layout.minimumLineSpacing = 15;
    layout.itemSize = CGSizeMake(itemSide, itemSide);
    
    [self.linkTextField addDoneOnKeyboardWithTarget:self
                                             action:@selector(tryDownloadMedia)
                                          titleText:nil];
}

- (void)startObservers {
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(tryDownloadMedia)
                                               name:UIApplicationDidBecomeActiveNotification
                                             object:nil];
}

#pragma mark Actions

- (IBAction)loadAction:(LoadingButton *)sender {
    [self.presenter loadPublicationFromURLString:self.linkTextField.text];
}

- (IBAction)copyAction:(UIButton *)sender {
    [self.presenter copyToPasteboardCaption:self.captionLabel.text];
}

- (IBAction)downloadMediaAction:(UIButton *)sender {
    [self.presenter saveMediaFromQueue];
}

- (void)addMediaToQueue:(CheckButton *)sender {
    sender.isChecked = !sender.isChecked;
    if (sender.isChecked) {
        [self.presenter addObjectToQueueAtIndex:sender.tag];
    } else {
        [self.presenter removeObjectFromQueueAtIndex:sender.tag];
    }
}

- (void)tryDownloadMedia {
    [self.view endEditing:YES];
    
    if ([self.presenter canDownloadPasteboardTextFieldText:self.linkTextField.text]) {
        self.linkTextField.text = UIPasteboard.generalPasteboard.string;
        [self.presenter loadPublicationFromURLString:self.linkTextField.text];
    }
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
    
    return self.presenter.publication.media.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    MediaCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([MediaCollectionViewCell class]) forIndexPath:indexPath];
    
    MediaInfo *mediaInfo = self.presenter.publication.media[indexPath.row];
    
    cell.imageView.image = [UIImage imageNamed:@"placeholder"];
    cell.checkButton.tag = indexPath.row;
    [cell.checkButton addTarget:self action:@selector(addMediaToQueue:) forControlEvents:UIControlEventTouchUpInside];
    
    if (self.presenter.publication.isCarousel) {
        cell.checkButton.isChecked = YES;
        [self.presenter addObjectToQueueAtIndex:indexPath.row];
    } else if ([self.presenter.mediaQueue containsObject:mediaInfo]){
        cell.checkButton.isChecked = YES;
    } else {
        cell.checkButton.isChecked = NO;
    }
    
    CGFloat side = collectionView.frame.size.width;
    [self.presenter loadImageURLString:mediaInfo.previewURLString
                          resizeToSize:CGSizeMake(side, side)
                 withCompletionHandler:^(UIImage *image) {
        cell.imageView.image = image;
    }];
    
    return cell;
}

#pragma mark - Helpers

- (void)updatePublicationAndCaption:(NSString *)caption {
    self.captionLabel.hidden = NO;
    self.captionCopyButton.hidden = NO;
    self.downloadMediaButton.hidden = NO;
    
    self.captionLabel.text = caption;
    [self.collectionView reloadData];
}

- (void)showNormalState {
    [self.downloadButton showNormalState];
    self.linkTextField.alpha = 1;
    
    self.linkTextField.enabled = YES;
    self.downloadButton.enabled = YES;
    
    [self.downloadButton setTitle:@"Показать пост"];
}

- (void)showLoadingState {
    [self.downloadButton showLoadingState];
    self.linkTextField.alpha = 0.6;
    
    self.linkTextField.enabled = NO;
    self.downloadButton.enabled = NO;
    
    [self.downloadButton setTitle:@"Загружаю пост"];
}

- (void)showProgressHudStatus:(NSString *)labelStatus progress:(NSNumber *)progress {
    if (self.currentHUD) {
        self.currentHUD.label.text = labelStatus;
        self.currentHUD.progress = progress.floatValue;
    } else {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeAnnularDeterminate;
        hud.label.text = labelStatus;
        hud.progress = progress.floatValue;
        
        self.currentHUD = hud;
    }
}

- (void)hideProgressHud {
    [self.currentHUD hideAnimated:YES];
    self.currentHUD = nil;
}

@end
