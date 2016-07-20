//
//  LPCHViewController.m
//  乐搜
//
//  Created by mickey on 16/7/20.
//  Copyright © 2016年 李盼. All rights reserved.
//

#import "LPCHViewController.h"

@interface LPCHViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation LPCHViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  self.navigationController.navigationBar.translucent = NO;
  self.tabBarController.tabBar.translucent =NO;
    // Do any additional setup after loading the view.
//  self.webView.scalesPageToFit= YES;
//  self.webView.layer.borderColor =[[UIColor lightGrayColor]CGColor];
//  self.webView.layer.borderWidth = 0.5;
//  self.webView.layer.masksToBounds = YES;
//  self.webView.opaque = NO;
//  self.webView.scalesPageToFit=YES;
  NSURL * url =[NSURL URLWithString:[NSString stringWithFormat:@"http://m.46644.com/cidian/index.php"]];
  NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url];
  [self.webView loadRequest:request];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
