//
//  ViewController.m
//  20121019_ALM
//
//  Created by murapong on 12/10/14.
//  Copyright (c) 2012年 com.murapong. All rights reserved.
//

#import "ViewController.h"

// ヘッダファイルをインポート
#import <Social/Social.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBAction

- (IBAction)SLComposeViewControllerButtonPressed:(id)sender
{
    NSString *serviceType = SLServiceTypeTwitter;   // Twitter
//    NSString *serviceType = SLServiceTypeFacebook;  // Facebook
    
    // 利用可能かチェック
    if ([SLComposeViewController isAvailableForServiceType:serviceType]) {
        SLComposeViewController *composeViewController = [SLComposeViewController
                                                          composeViewControllerForServiceType:serviceType];
        
        // テキストの初期値
        [composeViewController setInitialText:@"hogehoge"];
        
        // 画像を添付
        [composeViewController addImage:[UIImage imageNamed:@"murapong.jpg"]];
        
        // URLを追加
        [composeViewController addURL:[NSURL URLWithString:@"http://example.com"]];
        
        // 完了時の処理
        [composeViewController setCompletionHandler:^(SLComposeViewControllerResult result) {
            if (result == SLComposeViewControllerResultDone) {
                NSLog(@"Done");
            } else if (result == SLComposeViewControllerResultCancelled) {
                NSLog(@"Cancelled");
            }
        }];
        
        // SLComposeViewControllerを表示
        [self presentViewController:composeViewController animated:YES completion:nil];
    }
}

@end
