//
//  LBCreateScreenplayController.m
//  LBVideoMaker_Example
//
//  Created by 赵立波 on 2018/7/2.
//  Copyright © 2018年 胡萝卜_小波波. All rights reserved.
//

#import "LBCreateScreenplayController.h"
#import "LBCreateTimelineController.h"

#import <ReactiveObjC/ReactiveObjC.h>

@interface LBCreateScreenplayController () <UITextFieldDelegate, UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *nextBarBtnItem;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *scrollContentView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollContentViewConsHeight;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;

@property (weak, nonatomic) IBOutlet UILabel *sizeLabel;
@property (weak, nonatomic) IBOutlet UITextField *widthTextField;
@property (weak, nonatomic) IBOutlet UITextField *heightTextField;

@property (weak, nonatomic) IBOutlet UILabel *framesLabel;
@property (weak, nonatomic) IBOutlet UISlider *framesSlider;
@property (weak, nonatomic) IBOutlet UILabel *framesDisplayLabel;

@property (weak, nonatomic) IBOutlet UILabel *customAudioLabel;
@property (weak, nonatomic) IBOutlet UISwitch *customAudioSwitch;

@property (weak, nonatomic) IBOutlet UILabel *customVideoLabel;
@property (weak, nonatomic) IBOutlet UISwitch *customVideoSwitch;

@end

@implementation LBCreateScreenplayController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addAccessoryViewWithTitle:@"Next" forTextField:self.nameTextField];
    [self addAccessoryViewWithTitle:@"Next" forTextField:self.widthTextField];
    [self addAccessoryViewWithTitle:@"Done" forTextField:self.heightTextField];
    
    RACSignal *inputsSignal = [RACSignal combineLatest:@[self.nameTextField.rac_textSignal, self.widthTextField.rac_textSignal, self.heightTextField.rac_textSignal] reduce:^id (NSString *name, NSString *width, NSString *height) {
        BOOL existName = NO;
        BOOL nameEnable = NO;
        if ([name length] > 0) {
            existName = YES;
            NSString *str = [[name stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] stringByReplacingOccurrencesOfString:@" " withString:@""];
            nameEnable = [str length] > 0;
        }
        BOOL existWidth = NO;
        BOOL widthEnable = NO;
        if ([width length] > 0) {
            existWidth = YES;
            widthEnable = [width integerValue] > 0;
        }
        BOOL existHeight = NO;
        BOOL heightEnable = NO;
        if ([height length] > 0) {
            existHeight = YES;
            heightEnable = [height integerValue] > 0;
        }
        
        BOOL valid = (!existName && !existWidth && !existHeight) ||
        ((existName && nameEnable) && !existWidth && !existHeight) ||
        (!existName && (existWidth && widthEnable) && (existHeight && heightEnable));
        if (valid) {
            return @YES;
        } else {
            return @(nameEnable && widthEnable && heightEnable);
        }
    }];
    RAC(self.nextBarBtnItem, enabled) = inputsSignal;
    
    @weakify(self);
    [[self.framesSlider rac_signalForControlEvents:UIControlEventValueChanged] subscribeNext:^(__kindof UISlider * _Nullable framesSlider) {
        @strongify(self);
        if (framesSlider.value <= 45) {
            self.framesDisplayLabel.text = @"30";
        } else if (framesSlider.value <= 90) {
            self.framesDisplayLabel.text = @"60";
        } else {
            self.framesDisplayLabel.text = @"120";
        }
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated {
    self.navigationController.interactivePopGestureRecognizer.delegate = nil;
}

- (void)addAccessoryViewWithTitle:(NSString *)title forTextField:(UITextField *)textField {
    UIBarButtonItem *doneBarBtnItem = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:self action:@selector(doAccessoryViewAction:)];
    UIBarButtonItem *spaceBarBtnItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIToolbar *accessoryView = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), 44)];
    [accessoryView setItems:@[spaceBarBtnItem, doneBarBtnItem] animated:NO];
    
    textField.inputAccessoryView = accessoryView;
}

#pragma mark - Actions

- (IBAction)doCancelAction:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)doAccessoryViewAction:(id)sender {
    if (self.heightTextField.isFirstResponder) {
        [self.heightTextField resignFirstResponder];
    }
    if (self.widthTextField.isFirstResponder) {
        [self.heightTextField becomeFirstResponder];
    }
    if (self.nameTextField.isFirstResponder) {
        [self.widthTextField becomeFirstResponder];
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    return NO;
}

#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    LBScreenplayObj *obj = [[LBScreenplayObj alloc] init];
    if ([self.nameTextField.text length] > 0) {
        obj.screenplayName = self.nameTextField.text;
    }
    if ([self.widthTextField.text length] > 0 && [self.heightTextField.text length] > 0) {
        obj.videoSize = CGSizeMake([self.widthTextField.text integerValue], [self.heightTextField.text integerValue]);
    }
    obj.frames = [self.framesDisplayLabel.text intValue];
    obj.customBackgroundVideo = [self.customAudioSwitch isOn];
    obj.customBackgroundVideo = [self.customVideoSwitch isOn];
    
    LBCreateTimelineController *timelineVC = (LBCreateTimelineController *)segue.destinationViewController;
    timelineVC.obj = obj;
}

@end
