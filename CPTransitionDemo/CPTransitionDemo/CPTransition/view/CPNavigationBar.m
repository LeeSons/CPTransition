//
//  CPNavigationBar.m
//  zent
//
//  Created by Morplcp on 2018/11/16.
//  Copyright © 2018 zentcm. All rights reserved.
//

#import "CPNavigationBar.h"
#import "CPTransitionHelper.h"

NSString *const CPNavigationBarHeightDidChangeNotification = @"CPNavigationBarHeightDidChangeNotification";

#define CP_ITEM_SCREEN_MARGIN 15
#define CP_ITEM_SCOP 10

@interface CPNavigationBar () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
{
    BOOL _isLeftMoreButtons; // 是否显示左侧的更多按钮
    BOOL _isShowMoreButtonView; // 是否显示更多按钮
}

@property (nonatomic, strong) UIBlurEffect *effect;
@property (nonatomic, strong) UIVisualEffectView *effectView;
@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIButton *leftButton;
@property (nonatomic, strong) UIView *leftButtonView;

@property (nonatomic, strong) UIButton *rightButton;
@property (nonatomic, strong) UIView *rightButtonView;

// 底部分割线
@property (nonatomic, strong) UIView *bottomLineView;


@property (nonatomic, strong) UIButton *leftMoreButton;
@property (nonatomic, strong) NSMutableArray *leftMoreButtons;

@property (nonatomic, strong) UIButton *rightMoreButton;
@property (nonatomic, strong) NSMutableArray *rightMoreButtons;

@property (nonatomic, strong) UICollectionView *moreButtonsView;

@end

@implementation CPNavigationBar

- (instancetype)init
{
    self = [super initWithFrame:CGRectMake(0, 0, CP_SCREEN_WIDTH, CP_NAVBAR_HEIGHT)];
    if (self)
    {
        // 设置默认属性
        [self setDefaultValue];
        [self initSubViews];
    }
    return self;
}

- (void)setDefaultValue
{
    _showLineView = YES;
    _lineColor = [UIColor lightGrayColor];
    _blurEffect = YES;
    self.blurEffectStyle = UIBlurEffectStyleLight;
    _backColor = nil;
    _titleTextAttribute = @{
                            NSFontAttributeName:[UIFont systemFontOfSize:17],
                            NSForegroundColorAttributeName:[UIColor blackColor]
                            };
    _itemTextAttribute = @{
                           NSFontAttributeName:[UIFont systemFontOfSize:17],
                           NSForegroundColorAttributeName:[UIColor blackColor]
                           };
}

- (void)initSubViews
{
    self.backgroundColor = _backColor;
    [self addSubview:self.effectView];
    [self addSubview:self.bottomLineView];
    self.effectView.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height - 0.5f);
    self.bottomLineView.frame = CGRectMake(0, self.bounds.size.height - 0.5f, self.bounds.size.width, 0.5f);
}

#pragma mark -- actions

- (void)leftMoreAction:(UIButton *)sender
{
    if (_isLeftMoreButtons && _isShowMoreButtonView)
    {
        self.frame = CGRectMake(0, 0, CP_SCREEN_WIDTH, CP_NAVBAR_HEIGHT);
        self.effectView.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height - 0.5f);
        self.bottomLineView.frame = CGRectMake(0, self.bounds.size.height - 0.5f, self.bounds.size.width, 0.5f);
        [self.moreButtonsView removeFromSuperview];
        _isShowMoreButtonView = NO;
        self.moreButtonsView.hidden = YES;
        
        // 发送导航栏高度改变通知
        [[NSNotificationCenter defaultCenter] postNotificationName:CPNavigationBarHeightDidChangeNotification object:@(self.frame.size.height)];
    }
    else if (!_isLeftMoreButtons && _isShowMoreButtonView)
    {
        _isLeftMoreButtons = YES;
        self.moreButtonsView.hidden = NO;
        [self.moreButtonsView reloadData];
    }
    else if (!_isShowMoreButtonView)
    {
        self.frame = CGRectMake(0, 0, CP_SCREEN_WIDTH, CP_NAVBAR_HEIGHT + 44);
        self.effectView.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height - 0.5f);
        self.bottomLineView.frame = CGRectMake(0, self.bounds.size.height - 0.5f, self.bounds.size.width, 0.5f);
        self.moreButtonsView.frame = CGRectMake(0, CP_NAVBAR_HEIGHT, CP_SCREEN_WIDTH, 44);
        [self addSubview:self.moreButtonsView];
        
        _isLeftMoreButtons = YES;
        _isShowMoreButtonView = YES;
        self.moreButtonsView.hidden = NO;
        [self.moreButtonsView reloadData];
        
        // 发送导航栏高度改变通知
        [[NSNotificationCenter defaultCenter] postNotificationName:CPNavigationBarHeightDidChangeNotification object:@(self.frame.size.height)];
    }
}

- (void)rightMoreAction:(UIButton *)sender
{
    if (!_isLeftMoreButtons && _isShowMoreButtonView)
    {
        self.frame = CGRectMake(0, 0, CP_SCREEN_WIDTH, CP_NAVBAR_HEIGHT);
        self.effectView.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height - 0.5f);
        self.bottomLineView.frame = CGRectMake(0, self.bounds.size.height - 0.5f, self.bounds.size.width, 0.5f);
        [self.moreButtonsView removeFromSuperview];
        _isShowMoreButtonView = NO;
        self.moreButtonsView.hidden = YES;
        
        // 发送导航栏高度改变通知
        [[NSNotificationCenter defaultCenter] postNotificationName:CPNavigationBarHeightDidChangeNotification object:@(self.frame.size.height)];
    }
    else if (_isLeftMoreButtons && _isShowMoreButtonView)
    {
        _isLeftMoreButtons = NO;
        self.moreButtonsView.hidden = NO;
        [self.moreButtonsView reloadData];
    }
    else if (!_isShowMoreButtonView)
    {
        self.frame = CGRectMake(0, 0, CP_SCREEN_WIDTH, CP_NAVBAR_HEIGHT + 44);
        self.effectView.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height - 0.5f);
        self.bottomLineView.frame = CGRectMake(0, self.bounds.size.height - 0.5f, self.bounds.size.width, 0.5f);
        self.moreButtonsView.frame = CGRectMake(0, CP_NAVBAR_HEIGHT, CP_SCREEN_WIDTH, 44);
        [self addSubview:self.moreButtonsView];
        
        _isLeftMoreButtons = NO;
        _isShowMoreButtonView = YES;
        self.moreButtonsView.hidden = NO;
        [self.moreButtonsView reloadData];
        
        // 发送导航栏高度改变通知
        [[NSNotificationCenter defaultCenter] postNotificationName:CPNavigationBarHeightDidChangeNotification object:@(self.frame.size.height)];
    }
}

#pragma mark -- UICollectionDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
#pragma mark -- UICollectionDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (_isLeftMoreButtons)
    {
        return self.leftMoreButtons.count;
    }
    return self.rightMoreButtons.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"morebuttoncell" forIndexPath:indexPath];
    
    for (UIView *view in cell.contentView.subviews)
    {
        [view removeFromSuperview];
    }
    
    if (_isLeftMoreButtons)
    {
        UIButton *button = self.leftMoreButtons[indexPath.row];
        button.frame = CGRectMake(0, 0, button.frame.size.width, 44);
        [cell.contentView addSubview:button];
    }
    else
    {
        UIButton *button = self.rightMoreButtons[indexPath.row];
        button.frame = CGRectMake(0, 0, button.frame.size.width, 44);
        [cell.contentView addSubview:button];
    }
    return cell;
}
#pragma mark -- UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (_isLeftMoreButtons)
    {
        UIButton *button = self.leftMoreButtons[indexPath.row];
        return CGSizeMake(button.frame.size.width, 44);
    }
    UIButton *button = self.rightMoreButtons[indexPath.row];
    return CGSizeMake(button.frame.size.width, 44);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, CP_ITEM_SCREEN_MARGIN, 0, CP_ITEM_SCREEN_MARGIN);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 2 * CP_ITEM_SCOP;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 2 * CP_ITEM_SCOP;
}

#pragma mark -- setter

- (void)setLeftItem:(UIBarButtonItem *)leftItem
{
    _leftItem = leftItem;
    if (self.leftItems)
    {
        [self.leftButtonView removeFromSuperview];
    }
    [self.leftButton removeFromSuperview];
    if (!self.leftButton)
    {
        self.leftButton = [UIButton buttonWithType:UIButtonTypeSystem];
    }
    [_leftButton setTitleColor:_itemTextAttribute[NSForegroundColorAttributeName] forState:UIControlStateNormal];
    [_leftButton setTintColor:_itemTextAttribute[NSForegroundColorAttributeName]];
    _leftButton.titleLabel.font = _itemTextAttribute[NSFontAttributeName];
    if (leftItem.title)
    {
        [_leftButton setTitle:leftItem.title forState:UIControlStateNormal];
    }
    if (leftItem.image)
    {
        [_leftButton setImage:leftItem.image forState:UIControlStateNormal];
    }
    [_leftButton addTarget:leftItem.target action:leftItem.action forControlEvents:UIControlEventTouchUpInside];
    [_leftButton sizeToFit];
    CGFloat width = _leftButton.frame.size.width;
    if (width >= ((CP_SCREEN_WIDTH - CP_ITEM_SCREEN_MARGIN * 2 - CP_ITEM_SCOP) / 3.0f))
    {
        width = (CP_SCREEN_WIDTH - CP_ITEM_SCREEN_MARGIN * 2 - CP_ITEM_SCOP) / 3.0f;
    }
    _leftButton.frame = CGRectMake(CP_ITEM_SCREEN_MARGIN, CP_STATUS_HEIGHT, width, 44);
    [self addSubview:_leftButton];
}

- (void)setLeftItems:(NSArray<UIBarButtonItem *> *)leftItems
{
    _leftItems = leftItems;
    if (self.leftButton)
    {
        [self.leftButton removeFromSuperview];
    }
    [self.leftButtonView removeFromSuperview];
    
    self.leftButtonView = [[UIView alloc] initWithFrame:CGRectMake(CP_ITEM_SCREEN_MARGIN, CP_STATUS_HEIGHT, 0, 44)];
    CGFloat width = 0;
    for (int i = 0; i < leftItems.count; i++)
    {
        UIBarButtonItem *item = leftItems[i];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.tag = 10000 + i;
        [button setTitleColor:_itemTextAttribute[NSForegroundColorAttributeName] forState:UIControlStateNormal];
        [button setTintColor:_itemTextAttribute[NSForegroundColorAttributeName]];
        button.titleLabel.font = _itemTextAttribute[NSFontAttributeName];
        if (item.title)
        {
            [button setTitle:item.title forState:UIControlStateNormal];
        }
        if (item.image)
        {
            [button setImage:item.image forState:UIControlStateNormal];
        }
        [button addTarget:item.target action:item.action forControlEvents:UIControlEventTouchUpInside];
        CGFloat x = 0;
        if (i > 0)
        {
            UIButton *lastButton = [self.leftButtonView viewWithTag:10000 + (i - 1)];
            x = lastButton.frame.size.width + lastButton.frame.origin.x + CP_ITEM_SCOP;
        }
        [button sizeToFit];
        button.frame = CGRectMake(x, 0, button.frame.size.width, 44);
        width += button.frame.size.width + CP_ITEM_SCOP;
        [self.leftButtonView addSubview:button];
    }
    if (width > 0)
    {
        // 暂时存放需要隐藏的按钮
        [self.leftMoreButtons removeAllObjects];
        width = width - CP_ITEM_SCOP;
        NSInteger tempTag = leftItems.count - 1;
        // 如果 宽度超过 上限，则减去 一个按钮的宽度
        while (width >= ((CP_SCREEN_WIDTH - CP_ITEM_SCREEN_MARGIN * 2 - CP_ITEM_SCOP) / 3.0f))
        {
            UIButton *button = [self.leftButtonView viewWithTag:10000 + tempTag];
            [self.leftMoreButtons addObject:button];
            [button removeFromSuperview];
            width = width - button.frame.size.width - CP_ITEM_SCOP;
            tempTag--;
        }
        
        if (tempTag < leftItems.count - 1)
        {
            // 获取当前能显示下的最后一个按钮
            UIButton *button = [self.leftButtonView viewWithTag:10000 + tempTag];
            // 添加更多按钮
            [self.leftMoreButton removeFromSuperview];
            self.leftMoreButton.frame = button.frame;
            self.leftMoreButton.tintColor = button.tintColor;
            [button removeFromSuperview];
            [self.leftButtonView addSubview:self.leftMoreButton];
            [self.leftMoreButtons addObject:button];
        }
    }
    CGRect newFrame = self.leftButtonView.frame;
    newFrame.size = CGSizeMake(width, newFrame.size.height);
    self.leftButtonView.frame = newFrame;
    [self addSubview:self.leftButtonView];
}

- (void)setRightItem:(UIBarButtonItem *)rightItem
{
    _rightItem = rightItem;
    if (self.rightItems)
    {
        [self.rightButtonView removeFromSuperview];
    }
    [self.rightButton removeFromSuperview];
    if (!self.rightButton)
    {
        self.rightButton = [UIButton buttonWithType:UIButtonTypeSystem];
    }
    [_rightButton setTitleColor:_itemTextAttribute[NSForegroundColorAttributeName] forState:UIControlStateNormal];
    [_rightButton setTintColor:_itemTextAttribute[NSForegroundColorAttributeName]];
    _rightButton.titleLabel.font = _itemTextAttribute[NSFontAttributeName];
    if (rightItem.title)
    {
        [_rightButton setTitle:rightItem.title forState:UIControlStateNormal];
    }
    if (rightItem.image)
    {
        [_rightButton setImage:rightItem.image forState:UIControlStateNormal];
    }
    [_rightButton addTarget:rightItem.target action:rightItem.action forControlEvents:UIControlEventTouchUpInside];
    [_rightButton sizeToFit];
    CGFloat width = _rightButton.frame.size.width;
    if (width >= ((CP_SCREEN_WIDTH - CP_ITEM_SCREEN_MARGIN * 2 - CP_ITEM_SCOP) / 3.0f))
    {
        width = (CP_SCREEN_WIDTH - CP_ITEM_SCREEN_MARGIN * 2 - CP_ITEM_SCOP) / 3.0f;
    }
    _rightButton.frame = CGRectMake(CP_SCREEN_WIDTH - CP_ITEM_SCREEN_MARGIN - width, CP_STATUS_HEIGHT, width, 44);
    [self addSubview:_rightButton];
}

- (void)setRightItems:(NSArray<UIBarButtonItem *> *)rightItems
{
    _rightItems = rightItems;
    if (self.rightButton)
    {
        [self.rightButton removeFromSuperview];
    }
    [self.rightButtonView removeFromSuperview];
    self.rightButtonView = [[UIView alloc] initWithFrame:CGRectMake(CP_SCREEN_WIDTH - (((CP_SCREEN_WIDTH - CP_ITEM_SCREEN_MARGIN * 2 - CP_ITEM_SCOP) / 3.0f)) - CP_ITEM_SCREEN_MARGIN, CP_STATUS_HEIGHT, ((CP_SCREEN_WIDTH - CP_ITEM_SCREEN_MARGIN * 2 - CP_ITEM_SCOP) / 3.0f), 44)];
    CGFloat width = 0;
    for (int i = 0; i < rightItems.count; i++)
    {
        UIBarButtonItem *item = rightItems[i];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.tag = 10000 + i;
        [button setTitleColor:_itemTextAttribute[NSForegroundColorAttributeName] forState:UIControlStateNormal];
        [button setTintColor:_itemTextAttribute[NSForegroundColorAttributeName]];
        button.titleLabel.font = _itemTextAttribute[NSFontAttributeName];
        if (item.title)
        {
            [button setTitle:item.title forState:UIControlStateNormal];
        }
        if (item.image)
        {
            [button setImage:item.image forState:UIControlStateNormal];
        }
        [button addTarget:item.target action:item.action forControlEvents:UIControlEventTouchUpInside];
        [button sizeToFit];
        CGFloat x = (((CP_SCREEN_WIDTH - CP_ITEM_SCREEN_MARGIN * 2 - CP_ITEM_SCOP) / 3.0f)) - button.frame.size.width;
        if (i > 0)
        {
            UIButton *lastButton = [self.rightButtonView viewWithTag:10000 + (i - 1)];
            x = lastButton.frame.origin.x - CP_ITEM_SCOP - button.frame.size.width;
        }
        button.frame = CGRectMake(x, 0, button.frame.size.width, 44);
        width += button.frame.size.width + CP_ITEM_SCOP;
        [self.rightButtonView addSubview:button];
    }
    if (width > 0)
    {
        // 暂时存放需要隐藏的按钮
        [self.rightMoreButtons removeAllObjects];
        width = width - CP_ITEM_SCOP;
        NSInteger tempTag = rightItems.count - 1;
        // 如果 宽度超过 上限，则减去 一个按钮的宽度
        while (width >= ((CP_SCREEN_WIDTH - CP_ITEM_SCREEN_MARGIN * 2 - CP_ITEM_SCOP) / 3.0f))
        {
            UIButton *button = [self.rightButtonView viewWithTag:10000 + tempTag];
            [self.rightMoreButtons addObject:button];
            [button removeFromSuperview];
            width = width - button.frame.size.width - CP_ITEM_SCOP;
            tempTag--;
        }
        
        if (tempTag < rightItems.count - 1)
        {
            // 获取当前能显示下的最后一个按钮
            UIButton *button = [self.rightButtonView viewWithTag:10000 + tempTag];
            // 添加更多按钮
            [self.rightMoreButton removeFromSuperview];
            self.rightMoreButton.frame = button.frame;
            self.rightMoreButton.tintColor = button.tintColor;
            [button removeFromSuperview];
            [self.rightButtonView addSubview:self.rightMoreButton];
            [self.rightMoreButtons addObject:button];
        }
    }
    [self addSubview:self.rightButtonView];
}

- (void)setShowLineView:(BOOL)showLineView
{
    _showLineView = showLineView;
    if (showLineView)
    {
        if ([self.backColor isEqual:[UIColor clearColor]])
        {
            _showLineView = NO;
        }
    }
    self.bottomLineView.hidden = !_showLineView;
}

- (void)setLineColor:(UIColor *)lineColor
{
    _lineColor = lineColor;
    self.bottomLineView.backgroundColor = lineColor;
}

- (void)setBlurEffect:(BOOL)blurEffect
{
    _blurEffect = blurEffect;
    self.effectView.hidden = !blurEffect;
}

- (void)setBlurEffectStyle:(UIBlurEffectStyle)blurEffectStyle
{
    _blurEffectStyle = blurEffectStyle;
    self.effect = [UIBlurEffect effectWithStyle:blurEffectStyle];
    self.effectView.effect = self.effect;
}

- (void)setBackColor:(UIColor *)backColor
{
    _backColor = backColor;
    if (backColor)
    {
        self.effectView.hidden = YES;
        self.backgroundColor = backColor;
        if ([backColor isEqual:[UIColor clearColor]])
        {
            self.bottomLineView.hidden = YES;
        }
        else
        {
            self.bottomLineView.hidden = NO;
        }
    }
    else
    {
        self.effectView.hidden = NO;
    }
}

- (void)setTitleTextAttribute:(NSDictionary *)titleTextAttribute
{
    _titleTextAttribute = titleTextAttribute;
    self.titleLabel.textColor = _titleTextAttribute[NSForegroundColorAttributeName];
    self.titleLabel.font = _titleTextAttribute[NSFontAttributeName];
    [self.titleLabel sizeToFit];
    [self.titleView sizeToFit];
}

- (void)setItemTextAttribute:(NSDictionary *)itemTextAttribute
{
    _itemTextAttribute = itemTextAttribute;
    self.leftItem = _leftItem;
    self.rightItem = _rightItem;
    self.leftItems = _leftItems;
    self.rightItems = _rightItems;
}

- (void)setTitle:(NSString *)title
{
    _title = title;
    if (self.titleView)
    {
        [self.titleView removeFromSuperview];
    }
    
    [self.titleLabel removeFromSuperview];
    self.titleLabel.text = title;
    [self.titleLabel sizeToFit];
    self.titleLabel.center = CGPointMake(self.center.x, CP_STATUS_HEIGHT + 22);
    CGFloat width = self.titleLabel.frame.size.width;
    if (width >= ((CP_SCREEN_WIDTH - CP_ITEM_SCREEN_MARGIN * 2 - CP_ITEM_SCOP) / 3.0f))
    {
        width = (CP_SCREEN_WIDTH - CP_ITEM_SCREEN_MARGIN * 2 - CP_ITEM_SCOP) / 3.0f;
    }
    CGRect newFrame = self.titleLabel.frame;
    newFrame.size = CGSizeMake(width, newFrame.size.height);
    self.titleLabel.frame = newFrame;
    [self addSubview:self.titleLabel];
}

- (void)setTitleView:(UIView *)titleView
{
    _titleView = titleView;
    if (self.titleLabel)
    {
        [self.titleLabel removeFromSuperview];
    }
    [self.titleView removeFromSuperview];
    [self.titleView sizeToFit];
    self.titleView.center = CGPointMake(self.center.x, CP_STATUS_HEIGHT + 22);
    CGFloat width = self.titleView.frame.size.width;
    if (width >= ((CP_SCREEN_WIDTH - CP_ITEM_SCREEN_MARGIN * 2 - CP_ITEM_SCOP) / 3.0f))
    {
        width = (CP_SCREEN_WIDTH - CP_ITEM_SCREEN_MARGIN * 2 - CP_ITEM_SCOP) / 3.0f;
    }
    CGRect newFrame = self.titleView.frame;
    newFrame.size = CGSizeMake(width, newFrame.size.height);
    self.titleView.frame = newFrame;
    [self addSubview:self.titleView];
}

#pragma mark -- getter

- (UILabel *)titleLabel
{
    if (!_titleLabel)
    {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = _titleTextAttribute[NSForegroundColorAttributeName];
        _titleLabel.font = _titleTextAttribute[NSFontAttributeName];
        _titleLabel.numberOfLines = 1;
    }
    return _titleLabel;
}

- (UIView *)bottomLineView
{
    if (!_bottomLineView)
    {
        _bottomLineView = [[UIView alloc] initWithFrame:CGRectZero];
        _bottomLineView.backgroundColor = _lineColor;
    }
    return _bottomLineView;
}

- (UIVisualEffectView *)effectView
{
    if (!_effectView)
    {
        _effectView = [[UIVisualEffectView alloc] initWithEffect:self.effect];
    }
    return _effectView;
}

- (UIBlurEffect *)effect
{
    if (!_effect)
    {
        _effect = [UIBlurEffect effectWithStyle:_blurEffectStyle];
    }
    return _effect;
}

- (NSMutableArray *)leftMoreButtons
{
    if (!_leftMoreButtons)
    {
        _leftMoreButtons = [NSMutableArray array];
    }
    return _leftMoreButtons;
}

- (NSMutableArray *)rightMoreButtons
{
    if (!_rightMoreButtons)
    {
        _rightMoreButtons = [NSMutableArray array];
    }
    return _rightMoreButtons;
}

- (UICollectionView *)moreButtonsView
{
    if (!_moreButtonsView)
    {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        _moreButtonsView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _moreButtonsView.delegate = self;
        _moreButtonsView.dataSource = self;
        [_moreButtonsView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"morebuttoncell"];
        _moreButtonsView.showsVerticalScrollIndicator = NO;
        _moreButtonsView.showsHorizontalScrollIndicator = NO;
        _moreButtonsView.hidden = YES;
        _moreButtonsView.backgroundColor = [UIColor clearColor];
    }
    return _moreButtonsView;
}

- (UIButton *)leftMoreButton
{
    if (!_leftMoreButton)
    {
        _leftMoreButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_leftMoreButton setImage:[[CPTransitionHelper cp_getBundleImage:@"cp_nav_item_more"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
        [_leftMoreButton addTarget:self action:@selector(leftMoreAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftMoreButton;
}

- (UIButton *)rightMoreButton
{
    if (!_rightMoreButton)
    {
        _rightMoreButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_rightMoreButton setImage:[[CPTransitionHelper cp_getBundleImage:@"cp_nav_item_more"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
        [_rightMoreButton addTarget:self action:@selector(rightMoreAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightMoreButton;
}

@end
