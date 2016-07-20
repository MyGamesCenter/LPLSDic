//
//  ViewController.h
//  LPLSDic
//
//  Created by mickey on 16/7/18.
//  Copyright © 2016年 李盼. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<NSXMLParserDelegate>

@property (weak, nonatomic) IBOutlet UITextField *word;

@property (weak, nonatomic) IBOutlet UILabel *WordLabel;

@property (weak, nonatomic) IBOutlet UIButton *AMbutton;
@property (weak, nonatomic) IBOutlet UILabel *AMgrammarLabel;
@property (weak, nonatomic) IBOutlet UIButton *ENButton;
@property (weak, nonatomic) IBOutlet UILabel *EnGrammarLabel;
@property (weak, nonatomic) IBOutlet UITextView *EnchnagechinesetextField;

@property (weak, nonatomic) IBOutlet UITextView *textView;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityview;

@property (weak, nonatomic) IBOutlet UILabel *pinyinLabel;

- (IBAction)wordClick:(UIButton *)sender;


@end

