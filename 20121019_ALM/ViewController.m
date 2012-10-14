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
#import <Accounts/Accounts.h>

// 投稿する内容
#define kShareText  @"hogehoge"
#define kShareUrl   @"http://example.com"
#define kShareImage @"murapong.jpg"

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
        [composeViewController setInitialText:kShareText];
        
        // 画像を添付
        [composeViewController addImage:[UIImage imageNamed:kShareImage]];
        
        // URLを追加
        [composeViewController addURL:[NSURL URLWithString:kShareUrl]];
        
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

- (IBAction)SLRequestButtonPressed:(id)sender
{
    NSString *accountTypeIdentifier = ACAccountTypeIdentifierTwitter;   // Twitter
    
    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
    ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:accountTypeIdentifier];
    [accountStore requestAccessToAccountsWithType:accountType options:nil completion:^(BOOL granted, NSError *error) {
        // アカウントが設定されているかチェック
        if (granted) {
            NSArray *accounts = [accountStore accountsWithAccountType:accountType];
            if ([accounts count] > 0) {
                // Twitterアカウントは複数設定できるがとりあえず最初のを使用する
                ACAccount *account = [accounts objectAtIndex:0];
                
                // TwitterのWeb API
                NSURL *url = [NSURL URLWithString:@"https://api.twitter.com/1/statuses/update.json"];
                
                // パラメータを設定
                NSDictionary *params = @{@"status" : kShareText};
                
                // リクエストを組み立てる
                SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:SLRequestMethodPOST URL:url parameters:params];
                
                // アカウントの設定
                request.account = account;
                
                // リクエスト送信
                [request performRequestWithHandler:
                 ^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
                     NSLog(@"%@", [NSString stringWithFormat:@"status code : %d", urlResponse.statusCode]);
                }];
            }
        }
    }];
}

- (IBAction)UIActivityViewControllerButtonPressed:(id)sender
{
    // 投稿する内容
    NSString *text = kShareText;
    UIImage *image = [UIImage imageNamed:kShareImage];
    NSURL *url = [NSURL URLWithString:kShareUrl];
    NSArray *activityItems = @[text, image, url];
    
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    
    // 除外するアクティビティタイプを指定
    NSArray *excludedActivityTypes = @[
//                                        UIActivityTypePostToWeibo,
//                                        UIActivityTypeMessage,
//                                        UIActivityTypeMail,
//                                        UIActivityTypePrint,
//                                        UIActivityTypeCopyToPasteboard,
//                                        UIActivityTypeAssignToContact,
//                                        UIActivityTypeSaveToCameraRoll,
                                    ];
    activityViewController.excludedActivityTypes = excludedActivityTypes;
    
    // UIActivityViewControllerを表示
    [self presentViewController:activityViewController animated:YES completion:nil];
}

@end
