//
//  ViewController.m
//  WKWebView交互
//
//  Created by xuanhe on 2019/1/2.
//  Copyright © 2019 xuanhe. All rights reserved.
//

#import "ViewController.h"
#import "HTMLViewController.h"
#import "WKWebViewViewController.h"
#import "UIWebViewViewController.h"


@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *data;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"WKWebViewAndJS";
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];;
    self.data = @[@"WKWebView加载HTML以及所有交互",@"WKWebView点击图片放大",@"UIWebView点击图片放大"];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupUITabView];
    
}


#pragma mark -
#pragma mark - 初始化界面
-(void)setupUITabView
{
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, kNavBarH, kScreenW, kScreenH-kNavBarH) style:UITableViewStyleGrouped];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.estimatedRowHeight = 0;
    tableView.estimatedSectionHeaderHeight = 0;
    tableView.estimatedSectionFooterHeight = 0;
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    [self.view addSubview:tableView];
    
//    if (@available(iOS 11.0, *))
//        tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
//    else
//        self.automaticallyAdjustsScrollViewInsets = NO;
    
    
}

#pragma mark --------------------------------------------------
#pragma mark - tableView delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    cell.textLabel.text = self.data[indexPath.row];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 45;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        HTMLViewController *vc = [[HTMLViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.row == 1){
        WKWebViewViewController *vc = [[WKWebViewViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.row == 2){
        UIWebViewViewController *vc = [[UIWebViewViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

@end
