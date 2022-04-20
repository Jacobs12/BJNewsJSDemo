//
//  ViewController.m
//  JSDemo
//
//  Created by wolffy on 2022/4/20.
//

#import "ViewController.h"
#import "XHWWebViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)buttonClick:(id)sender{
    XHWWebViewController * vc = [[XHWWebViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
