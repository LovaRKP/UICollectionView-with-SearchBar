//
//  ViewController.m
//  SignEasy
//
//  Created by Techno on 10/21/15.
//  Copyright © 2015 Techno. All rights reserved.
//

#import "ViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface ViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollContaintHight;

@property (weak, nonatomic) IBOutlet UIScrollView *myScrollview;
@property (weak, nonatomic) IBOutlet UILabel *myLabel;
@property (weak, nonatomic) IBOutlet UIButton *mybutton;
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@property (weak, nonatomic) IBOutlet UIView *myView;

@end

@implementation ViewController
@synthesize myLabel,mybutton,scrollContaintHight,myScrollview;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor colorWithRed:55.0/255.0 green:240.0/255 blue:238.0/255 alpha:1.0];

    self.myView.backgroundColor = [UIColor colorWithRed:55.0/255.0 green:240.0/255 blue:238.0/255 alpha:1.0];
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor  colorWithRed:57.0/255.0 green:158.0/255 blue:209.0/255 alpha:1.0]];
    
    [self.navigationController.navigationBar setTranslucent:NO];
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    [self.navigationItem setTitle:@"LOGOIN"];

    self.userNameTextField.delegate = self;
    self.passwordTextField.delegate = self;
    
    [[_userNameTextField layer] setBorderColor:[[UIColor grayColor] CGColor]]; //border color
    [[_userNameTextField layer] setBackgroundColor:[[UIColor whiteColor] CGColor]]; //background color
    [[_userNameTextField layer] setBorderWidth:1.5]; // border width
    [[_userNameTextField layer] setCornerRadius:5]; // radius of rounded corners
    [_userNameTextField setClipsToBounds: YES]; //clip text within the bounds
    
    
    [[_passwordTextField layer] setBorderColor:[[UIColor grayColor] CGColor]]; //border color
    [[_passwordTextField layer] setBackgroundColor:[[UIColor whiteColor] CGColor]]; //background color
    [[_passwordTextField layer] setBorderWidth:1.5]; // border width
    [[_passwordTextField layer] setCornerRadius:5]; // radius of rounded corners
    [_passwordTextField setClipsToBounds: YES]; //clip text within the bounds
    
    mybutton.layer.cornerRadius = 10; // this value
    mybutton.clipsToBounds = YES;
    
    
    //adding Long text to uilabel
    
    self.myLabel.textColor = [UIColor blackColor];
    myLabel.font = [UIFont fontWithName:@"Helvetica Neue" size:14];
    self.myLabel.textAlignment =  NSTextAlignmentCenter;
    
    
    myLabel.text = @"Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s.";
    
    // Cluculating Scrollview containt Size for Scrolling.
    
    float sizeOfContent = 0;
    UIView *lLast = [myScrollview.subviews lastObject];
    NSInteger wd = lLast.frame.origin.y;
    NSInteger ht = lLast.frame.size.height;
    
    sizeOfContent = wd+ht;
    
    myScrollview.contentSize = CGSizeMake(myScrollview.frame.size.width, sizeOfContent);
    
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    //hide the keyboard
    [textField resignFirstResponder];
    return YES;
}

@end
