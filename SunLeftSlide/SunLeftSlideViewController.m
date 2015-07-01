//
//  SunLeftSlideViewController.m
//  SunLeftSlide
//
//  Created by sun on 15/6/26.
//  Copyright (c) 2015年 sunxingxiang. All rights reserved.
//

#import "SunLeftSlideViewController.h"

#define CellHeight              40                                              //表视图单元格的高度
#define BlurViewAlpha           0.7                                             //菜单式图的覆盖视图的透视度
#define ViewChangeScale         0.8                                             //菜单和主视图的缩放比例
#define MainViewShowWidth       130                                             //主视图控制器动画时显示的宽度
#define MainViewCenter          CGPointMake(ScreenWidth/2.0+ScreenWidth-MainViewShowWidth,ScreenHeight/2.0)
                                                                                //打开左侧菜单时主视图的中心位置
#define LeftViewOpenCenter      CGPointMake((ScreenWidth - MainViewShowWidth)/2.0, ScreenHeight/2.0)
                                                                                //左侧菜单栏打开时的中心位置
#define LeftViewCloseCenter     CGPointMake((ScreenWidth - MainViewShowWidth)/2.0*ViewChangeScale-20, ScreenHeight/2.0)                                                           //左侧菜单栏关闭时的中心位置
#define AnimationTime           0.35                                            //动画时间

@interface SunLeftSlideViewController ()<UITableViewDataSource,UITableViewDelegate>{

    UIViewController *_mainViewController;      //主视图控制器

    UITableView *_tableView;                    //左侧选项
    UIView *_blurView;                          //模糊视图
    NSArray *_array;                            //左侧表视图的数据
    UITapGestureRecognizer *_tapGesture;        //主视图的单击手势
    UIPanGestureRecognizer *_panGesture;        //滑动手势
    BOOL _isOpen;                               //是否已经打开左侧菜单
    BOOL _isPanGesture;                         //是否打开滑动手势
    float _mainViewCenterx;                        //移动距离
}
@property (nonatomic,assign) float speedf;
@end

@implementation SunLeftSlideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view.layer setContents:(id)[UIImage imageNamed:@"leftbackiamge"].CGImage];
    
    _array = @[@"开通会员",@"QQ钱包",@"网上营业厅",@"个性装扮",@"我的收藏",@"我的相册",@"我的文件"];
    [self createSubViews];
    [self openSlidePanGesture];

}



#pragma mark - 创建子视图
- (void)createSubViews {
    
    _tableView = [UITableView new];
    _tableView.bounds = CGRectMake(0, 0, ScreenWidth - MainViewShowWidth, CellHeight*_array.count);
    _tableView.center = LeftViewCloseCenter;
    _tableView.transform = CGAffineTransformMakeScale(ViewChangeScale, ViewChangeScale);
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_tableView];
    
    _blurView = [[UIView alloc] initWithFrame:_tableView.bounds];
    _blurView.backgroundColor = [UIColor blackColor];
    _blurView.alpha = BlurViewAlpha;
    [_tableView addSubview:_blurView];
    
    [self.view addSubview:_mainViewController.view];
    _isPanGesture = YES;
    _mainViewCenterx = 0;
}

/**
 *  初始化侧滑视图控制器
 *
 *  @param mainViewController 主视图控制器
 */
- (instancetype)initWithMainViewController:(UIViewController *)mainViewController {
    self = [super init];
    if(self){
        _mainViewController = mainViewController;
    }
    return self;
}

/**
 *  打开平移手势
 */
- (void)openSlidePanGesture {
    if(_panGesture == nil){
        _panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(slidePanGesture:)];
        [self.view addGestureRecognizer:_panGesture];
    }
    _panGesture.enabled = YES;
}

/**
 *  关闭平移手势
 */
- (void)closeSlidePanGesture {
    _panGesture.enabled = NO;
}

/**
 *  给主视图添加单击手势
 */
- (void)addMainViewTapGesture {
    if(_tapGesture == nil){
        _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeSlideWithAnimation:)];
        [_mainViewController.view addGestureRecognizer:_tapGesture];
    }
    _tapGesture.enabled = YES;
    
    //禁止主视图中子控件的响应
    for(UIView *subView in _mainViewController.view.subviews){
        subView.userInteractionEnabled = NO;
    }
}

/**
 *  给主视图添加单击手势
 */
- (void)removeMainViewTapgesture {
    _tapGesture.enabled = NO;
    
    //开启主视图中子控件的响应
    for(UIView *subView in _mainViewController.view.subviews){
        subView.userInteractionEnabled = YES;
    }
}

/**
 *  打开左侧菜单栏
 */
- (void)openSlideWithAnimation:(BOOL)isAnimation {
    float durationTime = (isAnimation==YES?AnimationTime:0);
    [UIView animateWithDuration:durationTime animations:^{
        //左侧视图的变化
        _tableView.transform = CGAffineTransformMakeScale(1, 1);
        _tableView.center = LeftViewOpenCenter;
        
        //主视图的变化
        _mainViewController.view.transform = CGAffineTransformMakeScale(ViewChangeScale, ViewChangeScale);
        _mainViewController.view.center = MainViewCenter;
        
        _blurView.alpha = 0;
    }];
    _isOpen = YES;
    [self addMainViewTapGesture];
}

/**
 *  关闭左侧菜单栏
 */
- (void)closeSlideWithAnimation:(BOOL)isAnimation {
    
    float durationTime = (isAnimation==YES?AnimationTime:0);
    [UIView animateWithDuration:durationTime animations:^{
        //左侧视图的变化
        _tableView.transform = CGAffineTransformMakeScale(ViewChangeScale, ViewChangeScale);
        _tableView.center = LeftViewCloseCenter;
        
        //主视图的变化
        _mainViewController.view.transform = CGAffineTransformMakeScale(1, 1);
        _mainViewController.view.center = self.view.center;
        
        _blurView.alpha = BlurViewAlpha;
    }];
    _isOpen = NO;
    [self removeMainViewTapgesture];
}


- (void)slidePanGesture:(UIPanGestureRecognizer *)panGesture {

    float xDistance = [panGesture translationInView:self.view].x;
//    float direction = ([panGesture velocityInView:self.view].x >= 0?1:-1);
    if(_isOpen == NO){
        _mainViewCenterx = ScreenWidth/2.0 + xDistance;
    }else if (_isOpen == YES){
        _mainViewCenterx = MainViewCenter.x +xDistance;
    }
    
    if(_mainViewCenterx >= ScreenWidth/2.0 && _mainViewCenterx <= MainViewCenter.x){

        float scale = (_mainViewCenterx-ScreenWidth/2.0)*1.0/(ScreenWidth-MainViewShowWidth);
        float mainViewScale = 1-(1-ViewChangeScale)*scale;
        float tableViewScale = ViewChangeScale + (1-ViewChangeScale)*scale;

        _mainViewController.view.transform = CGAffineTransformMakeScale(mainViewScale, mainViewScale);
        _mainViewController.view.center = CGPointMake(_mainViewCenterx, ScreenHeight/2.0);
        
        float leftViewCenterX = LeftViewCloseCenter.x+(LeftViewOpenCenter.x-LeftViewCloseCenter.x)*scale;
        _tableView.transform = CGAffineTransformMakeScale(tableViewScale, tableViewScale);
        _tableView.center = CGPointMake(leftViewCenterX, ScreenHeight/2.0);
        
        _blurView.alpha = BlurViewAlpha*(1-scale);
    }
    
    //结束
    if(panGesture.state == UIGestureRecognizerStateEnded){
        
        if(_mainViewCenterx >= ScreenWidth){
            [self openSlideWithAnimation:NO];
        }else{
            [self closeSlideWithAnimation:NO];
        }
    }

    
}


#pragma mark - ***********************代理方法***************************
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *iden = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iden];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.textColor = [UIColor whiteColor];
    }
    cell.textLabel.text = _array[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return CellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UIViewController *viewController = [UIViewController new];
    viewController.view.backgroundColor = [UIColor greenColor];
    
    //主视图控制器的操作
    UINavigationController *navigationVC = (UINavigationController*)_mainViewController;
    navigationVC.viewControllers = @[viewController];
}






/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
