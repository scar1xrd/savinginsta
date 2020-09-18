//
//  MainView.m
//  Saving insta
//
//  Created by Igor Sorokin on 14.05.2020.
//  Copyright © 2020 Igor Sorokin. All rights reserved.
//

#import "MainView.h"

@interface MainView ()

@property (weak, nonatomic, readwrite) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic, readwrite) IBOutlet UILabel *captionLabel;
@property (weak, nonatomic, readwrite) IBOutlet UIButton *captionCopyButton;
@property (weak, nonatomic, readwrite) IBOutlet UITextField *linkTextField;
@property (weak, nonatomic, readwrite) IBOutlet LoadingButton *downloadButton;
@property (weak, nonatomic, readwrite) IBOutlet UIButton *downloadMediaButton;
@property (weak, nonatomic, readwrite) IBOutlet UIView *cardView;

@end

@implementation MainView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self setup];
}

- (void)setup {
    self.collectionView.alwaysBounceVertical = YES;
    
    [self.downloadButton setTitle:@"Показать пост"];
    self.downloadButton.layer.cornerRadius = 8;
    self.downloadButton.layer.masksToBounds = YES;
    
    [self.downloadMediaButton setTitle:@"Сохранить выбранное" forState:UIControlStateNormal];
    self.downloadMediaButton.layer.cornerRadius = 8;
    self.downloadMediaButton.layer.masksToBounds = YES;
    self.downloadMediaButton.hidden = YES;
    
    self.captionLabel.text = @"";
    self.captionLabel.hidden = YES;
    self.captionCopyButton.hidden = YES;
    
    self.cardView.layer.maskedCorners = kCALayerMinXMinYCorner | kCALayerMaxXMinYCorner;
    self.cardView.layer.cornerRadius = 18;
    
    self.cardView.layer.shadowColor = UIColor.blackColor.CGColor;
    self.cardView.layer.shadowRadius = 8;
    self.cardView.layer.shadowOpacity = 0.1;
}

@end
