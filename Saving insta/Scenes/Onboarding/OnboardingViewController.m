//
//  OnboardingViewController.m
//  Saving insta
//
//  Created by Igor Sorokin on 31.05.2020.
//  Copyright © 2020 Igor Sorokin. All rights reserved.
//

#import "OnboardingViewController.h"
#import "OnboardingView.h"
#import "OnboardingCollectionViewCell.h"

#import <Saving_insta-Swift.h>

typedef NS_ENUM(NSInteger, OnboardingCollectionViewCellType) {
    OnboardingCollectionViewCellWelcome,
    OnboardingCollectionViewCellInstagramPost,
    OnboardingCollectionViewCellInstagramCopy,
    OnboardingCollectionViewCellPasteUrl,
    OnboardingCollectionViewCellSaveMedia
};

@interface OnboardingViewController ()
<
UICollectionViewDataSource,
PagingCollectionFlowDelegate
>

@property (weak, nonatomic) UICollectionView *collectionView;
@property (weak, nonatomic) UIButton *nextButton;
@property (weak, nonatomic) UIPageControl *pageControl;

@end

@implementation OnboardingViewController

- (void)awakeFromNib {
    [super awakeFromNib];
    OnboardingView *mainView = (OnboardingView *)self.view;
    self.collectionView = mainView.collectionView;
    self.nextButton = mainView.nextButton;
    self.pageControl = mainView.pageControl;
    
    [self setup];
}

- (void)setup {
    self.modalPresentationStyle = UIModalPresentationOverFullScreen;
    self.collectionView.bounces = true;
    self.collectionView.alwaysBounceHorizontal = true;
    self.collectionView.alwaysBounceVertical = false;
    self.collectionView.dataSource = self;
    
    PagingCollectionViewLayout *layout = (PagingCollectionViewLayout *)self.collectionView.collectionViewLayout;
    layout.delegate = self;
    layout.minimumLineSpacing = 15;
    layout.itemSize = CGSizeMake(self.collectionView.frame.size.width, self.collectionView.frame.size.height);
}

- (IBAction)closeButtonTapped:(UIButton *)sender {
    [self dismissViewControllerAnimated:self completion:nil];
}

#pragma mark - PagingCollectionFlowDelegate

- (void)pagingCollectionFlowWithCurrentItemDidChange:(NSInteger)new_ {
    self.pageControl.currentPage = new_;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
    return 5;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
     OnboardingCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([OnboardingCollectionViewCell class]) forIndexPath:indexPath];
    
    OnboardingCollectionViewCellType type = (OnboardingCollectionViewCellType)indexPath.row;
    switch (type) {
        case OnboardingCollectionViewCellWelcome:
            cell.imageView.image = [UIImage imageNamed:@"onboardingLogo"];
            cell.label.text = @"Добро пожаловать в «Saving insta», сейчас мы покажем вам, как пользоваться приложением!";
            break;
            
        case OnboardingCollectionViewCellInstagramPost:
            cell.imageView.image = [UIImage imageNamed:@"tutorial1"];
            cell.label.text = @"Выберите нужный пост и нажмите на три точки в правом верхнем углу";
            break;
            
        case OnboardingCollectionViewCellInstagramCopy:
            cell.imageView.image = [UIImage imageNamed:@"tutorial2"];
            cell.label.text = @"В открывшемся меню, выберите пункт «Копировать ссылку»";
            break;
            
        case OnboardingCollectionViewCellPasteUrl:
            cell.imageView.image = [UIImage imageNamed:@"tutorial3"];
            cell.label.text = @"Октройте приложение, вставьте ссылку и нажмите «Показать пост» (если в настройках включена функция «Автозагрузка», то этот шаг можно пропустить)";
            break;
            
        case OnboardingCollectionViewCellSaveMedia:
            cell.imageView.image = [UIImage imageNamed:@"tutorial4"];
            cell.label.text = @"Выберите нужные фото и видео и нажмите «Сохранить выбранное». Готово!";
            break;
    }
    
    return cell;
}

@end
