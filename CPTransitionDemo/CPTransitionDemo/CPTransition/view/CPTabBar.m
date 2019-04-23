//
//  CPTabBar.m
//  CPTabBarController
//
//  Created by 孙登峰 on 2018/3/12.
//  Copyright © 2018年 morplcp. All rights reserved.
//

#import "CPTabBar.h"
#import "CPFrameworkMacro.h"

@implementation CPTabBarButton

- (void)dealloc
{
    NSLog(@"释放了就很棒");
}

+ (instancetype)buttonWithType:(UIButtonType)buttonType
{
    CPTabBarButton *button = [super buttonWithType:buttonType];
    return button;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self addSubview:self.badgeView];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    if (self.titleLabel.text && self.imageView.image)
    {
        self.titleEdgeInsets = UIEdgeInsetsMake(0, -self.imageView.frame.size.width, -self.imageView.frame.size.height - 0, 0);
        self.imageEdgeInsets = UIEdgeInsetsMake(-self.titleLabel.intrinsicContentSize.height - 0, 0, 0, -self.titleLabel.intrinsicContentSize.width);
    }
    
    
    CGFloat width = 13;
    CGFloat minWidth = 13;
    if (self.badgeType == CPBadgeTypeDot)
    {
        if (self.badgeView.currentBackgroundImage)
        {
            width = self.badgeView.currentBackgroundImage.size.width;
            minWidth = self.badgeView.currentBackgroundImage.size.height;
        }
        else
        {
            width = 10;
            minWidth = 10;
        }
    }
    else if (self.badgeType == CPBadgeTypeNumber)
    {
        width = 13;
        minWidth = 13;
    }
    
    width = [self.badgeView.titleLabel.text boundingRectWithSize:CGSizeMake(MAXFLOAT, minWidth) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:10]} context:nil].size.width + 5;
    if (width <= minWidth)
    {
        width = minWidth;
    }
    if (self.imageView.image)
    {
        self.badgeView.frame = CGRectMake(self.imageView.frame.origin.x + (self.imageView.frame.size.width - width) + (width / 2.5f), self.imageView.frame.origin.y - 2, width, minWidth);
        self.badgeView.layer.cornerRadius = minWidth * 0.5f;
    }
    
}

- (void)setTitle:(NSString *)title
{
    [self setTitle:title forState:UIControlStateNormal];
}

- (void)setTitleColor:(UIColor *)titleColor
{
    [self setTintColor:titleColor];
    [self setTitleColor:titleColor forState:UIControlStateNormal];
}

- (void)setImage:(UIImage *)image
{
    [self setImage:image forState:UIControlStateNormal];
}

- (void)setSelectImage:(UIImage *)image
{
    [self setImage:image forState:(UIControlStateSelected)];
}

- (void)setFont:(UIFont *)font
{
    [self.titleLabel setFont:font];
}

- (UIButton *)badgeView
{
    if (!_badgeView)
    {
        _badgeView = [UIButton buttonWithType:UIButtonTypeCustom];
        _badgeView.userInteractionEnabled = NO;
        _badgeView.hidden = YES;
        _badgeView.titleLabel.font = [UIFont boldSystemFontOfSize:10];
    }
    return _badgeView;
}

@end

@interface CPTabBar ()

@property (nonatomic, strong) NSMutableArray <CPTabBarButton *> *tabBarButtonArray;
@property (nonatomic, strong) UIView *lineView;

@end

@implementation CPTabBar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor whiteColor];
        
        // 顶部分割线
        self.lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 0.5f)];
        self.lineView.backgroundColor = CP_COLOR_VALUE(0xe5e5e5);
        [self addSubview:self.lineView];
        
        self.selectColor = [UIButton buttonWithType:(UIButtonTypeSystem)].tintColor;
        self.unSelectColor = [UIColor lightGrayColor];
        self.selectFont = [UIFont systemFontOfSize:10];
        self.unselectFont = [UIFont systemFontOfSize:10];
        self.scope = 8;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self resetItems];
}

- (void)setCp_items:(NSArray<CPTabBarItem *> *)cp_items
{
    _cp_items = cp_items;
    [self addItems];
}

- (void)addItems
{
    NSInteger count = self.cp_items.count;
    CGFloat width = (CP_SCREEN_WIDTH - self.scope * (count + 1)) / count * 1.0f;
    for (int i = 0; i < self.cp_items.count; i++)
    {
        CPTabBarItem *item = self.cp_items[i];
        CPTabBarButton *button = [CPTabBarButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(self.scope + (self.scope + width) * i, 0, width, 49);
        [button setTitle:item.title];
        [button setImage:item.image];
        button.badgeView.backgroundColor = item.badgeBgColor?item.badgeBgColor:[UIColor redColor];
        
        if (item.badgeNumber > 0)
        {
            if (item.badgeType == CPBadgeTypeNumber)
            {
                button.badgeView.hidden = NO;
                NSString *badgeValue = [NSString stringWithFormat:@"%ld", item.badgeNumber];
                [button.badgeView setTitle:badgeValue forState:UIControlStateNormal];
            }
        }
        
        if (item.badgeType == CPBadgeTypeDot)
        {
            button.badgeView.hidden = !item.showBadgeDot;
            [button.badgeView setBackgroundImage:[[UIImage imageNamed:item.badgeIcon] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        }
        
        if (item.selectedImage)
        {
            [button setSelectImage:item.selectedImage];
        }
        [button addTarget:self action:@selector(itemDidSelect:) forControlEvents:(UIControlEventTouchUpInside)];
        [self addSubview:button];
        [self.tabBarButtonArray addObject:button];
        item.cp_tabBarButton = button;
    }
}

- (void)setSelectItem:(CPTabBarItem *)selectItem
{
    _selectItem = selectItem;
    [self resetItems];
}

- (void)setSelectIndex:(NSInteger)index
{
    self.selectItem = self.cp_items[index];
}

- (void)resetItems
{
    NSInteger index = [self.cp_items indexOfObject:self.selectItem];
    [self.tabBarButtonArray enumerateObjectsUsingBlock:^(CPTabBarButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
     {
         if (index == idx)
         {
             [obj setTitleColor:self.selectColor];
             [obj setFont:self.selectFont];
             [obj setSelected:YES];
         }
         else
         {
             [obj setTitleColor:self.unSelectColor];
             [obj setFont:self.unselectFont];
             [obj setSelected:NO];
         }
     }];
}

- (void)itemDidSelect:(CPTabBarButton *)sender
{
    NSInteger index = [self.tabBarButtonArray indexOfObject:sender];
    CPTabBarItem *item = self.cp_items[index];
    if (![self.selectItem isEqual:item])
    {
        self.selectItem = item;
    }
    if (self.cp_delegate && [self.cp_delegate respondsToSelector:@selector(cp_tabBar:didSelectItem:)])
    {
        [self.cp_delegate cp_tabBar:self didSelectItem:item];
    }
    
    [self setNeedsLayout];
}

- (void)setTitleColor:(UIColor *)titleColor withIndex:(NSInteger)index
{
    CPTabBarButton *button = self.tabBarButtonArray[index];
    [button setTitleColor:titleColor];
}

- (NSMutableArray<CPTabBarButton *> *)tabBarButtonArray
{
    if (!_tabBarButtonArray)
    {
        _tabBarButtonArray = [NSMutableArray array];
    }
    return _tabBarButtonArray;
}

@end

