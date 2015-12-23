//
//  AboutProjectVC.m
//  24blogger
//
//  Created by iZaVyLoN on 11/9/15.
//  Copyright © 2015 iZaVyLoN. All rights reserved.
//

#import "AboutProjectVC.h"
#import "RTLabel.h"
#import <MessageUI/MessageUI.h>
#import "DMRNotificationView.h"

#define FACTOR_IMAGE 2.07
#define OFFSET_TEXT 10.0f
#define EMAIL_TITLE @"Сообщение из Kakadu Club App"

@interface AboutProjectVC () <MFMailComposeViewControllerDelegate>

@end

@implementation AboutProjectVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = [[LanguageManager sharedLanguageManager] getStringValueByKey:@"about_project_lm"];
    
    [self addLeftBarButtonItem];
    [self addTopImageWithTitle];
    [self addTextAbout];
    [self addSocialButton];
    [self.scrollAbout setContentSize:CGSizeMake(self.view.frame.size.width, self.view.frame.size.width / FACTOR_IMAGE + OFFSET_TEXT * 5 + [self heightTextAbout] + [UIImage imageNamed:@"ic_facebook"].size.height)];
}

#pragma Button

- (void)addLeftBarButtonItem {
    UIBarButtonItem *menuButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_menu"] style:UIBarButtonItemStylePlain target:self action:nil];
    self.navigationItem.leftBarButtonItem = menuButton;
    
    menuButton.target = self.revealViewController;
    menuButton.action = @selector(revealToggle:);
    
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
}

- (void)addSocialButton {
    CGFloat positionY = self.view.frame.size.width / FACTOR_IMAGE + OFFSET_TEXT + [self heightTextAbout] + OFFSET_TEXT * 2;
    
    // Add FaceBook button
    UIImage *ic_facebook = [UIImage imageNamed:@"ic_facebook"];
    UIButton *buttonFacebook = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 2 - (ic_facebook.size.width * 2 + OFFSET_TEXT * 3), positionY, ic_facebook.size.width, ic_facebook.size.height)];
    [buttonFacebook setImage:ic_facebook forState:UIControlStateNormal];
    [buttonFacebook addTarget:self action:@selector(pressButtonFaceBook) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollAbout addSubview:buttonFacebook];

    // Add Twitter button
    UIImage *ic_twitter = [UIImage imageNamed:@"ic_twitter"];
    UIButton *buttonTwitter = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 2 - (ic_facebook.size.width + OFFSET_TEXT), positionY, ic_facebook.size.width, ic_facebook.size.height)];
    [buttonTwitter setImage:ic_twitter forState:UIControlStateNormal];
    [buttonTwitter addTarget:self action:@selector(pressButtonTwitter) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollAbout addSubview:buttonTwitter];
    
    // Add Instagram button
    UIImage *ic_instagram = [UIImage imageNamed:@"ic_instagram"];
    UIButton *buttobInstagram = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 2 + OFFSET_TEXT, positionY, ic_facebook.size.width, ic_facebook.size.height)];
    [buttobInstagram setImage:ic_instagram forState:UIControlStateNormal];
    [buttobInstagram addTarget:self action:@selector(pressButtonInstagram) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollAbout addSubview:buttobInstagram];
    
    // Add Email button
    UIImage *ic_mail = [UIImage imageNamed:@"ic_mail"];
    UIButton *buttobEmail = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 2 + (ic_facebook.size.width + OFFSET_TEXT * 3), positionY, ic_facebook.size.width, ic_facebook.size.height)];
    [buttobEmail setImage:ic_mail forState:UIControlStateNormal];
    [buttobEmail addTarget:self action:@selector(pressButtonEmail) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollAbout addSubview:buttobEmail];
    
}

#pragma Action Button

- (void)pressButtonFaceBook {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"https://www.facebook.com/kakadudev?_rdr"]];
}

- (void)pressButtonTwitter {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"https://twitter.com/kakadudev"]];
}

- (void)pressButtonInstagram {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"https://instagram.com/kakadudev/"]];
}

- (void)pressButtonEmail {
    if ([MFMailComposeViewController canSendMail]) {
        NSArray *toRecipents = [NSArray arrayWithObject:@"info@kakadu.bz"];
        
        MFMailComposeViewController *mailController = [[MFMailComposeViewController alloc] init];
        mailController.mailComposeDelegate = self;
        [mailController setSubject:EMAIL_TITLE];
        [mailController setToRecipients:toRecipents];
        [mailController.navigationBar setTintColor:[UIColor whiteColor]];
        [mailController.navigationBar setBarTintColor:[UIColor whiteColor]];
        [self presentViewController:mailController animated:YES completion:NULL];
        
        [[mailController navigationBar] setTitleTextAttributes:[NSDictionary dictionaryWithObject:[UIColor blackColor] forKey:NSForegroundColorAttributeName]];
    } else {
        NSString *error;
        NSString *message;
        
        error = [[LanguageManager sharedLanguageManager] getStringValueByKey:@"error_av"];
        message  = [[LanguageManager sharedLanguageManager] getStringValueByKey:@"message_av"];
        
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:error message:message delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
    }
}

#pragma UIImageView

- (void)addTopImageWithTitle {
    UIImageView *imageViewAbout = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.width / FACTOR_IMAGE)];
    [imageViewAbout setImage:[UIImage imageNamed:@"about_bg"]];
    [self.scrollAbout addSubview:imageViewAbout];
    
    RTLabel *title = [[RTLabel alloc] init];
    [title setText:[NSString stringWithFormat:@"<font face='%@' size=34>About</font>\n<font face='%@' size=34>Kakadu</font> <font face='%@' size=34>Club</font>", KAKADU_FONT_BOLD, KAKADU_FONT_NORMAL, KAKADU_FONT_BOLD]];
    [title setTextColor:[UIColor whiteColor]];
    [title setTextAlignment:RTTextAlignmentCenter];
    [self.scrollAbout addSubview:title];
    
    [title setFrame:CGRectMake(0.0f, (self.view.frame.size.width / FACTOR_IMAGE - [title optimumSize].height) / 2, self.view.frame.size.width, [title optimumSize].height)];
}

#pragma UITextView

- (void)addTextAbout {
    RTLabel *textAbout = [[RTLabel alloc] initWithFrame:CGRectMake(OFFSET_TEXT, self.view.frame.size.width / FACTOR_IMAGE + OFFSET_TEXT, self.view.frame.size.width - OFFSET_TEXT * 2, [self heightTextAbout])];
    [textAbout setFont:[UIFont fontWithName:KAKADU_FONT_NORMAL size:16.0f]];
    [textAbout setText:[self aboutText]];
    [self.scrollAbout addSubview:textAbout];
}

- (NSString *)aboutText {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"about" ofType:@"txt"];
    return [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
}

- (CGFloat)heightTextAbout {
    RTLabel *rtLabel = [[RTLabel alloc] initWithFrame:CGRectMake(OFFSET_TEXT, 0.0f, self.view.frame.size.width - OFFSET_TEXT * 2, 10.0f)];
    [rtLabel setFont:[UIFont fontWithName:KAKADU_FONT_NORMAL size:16.0f]];
    [rtLabel setText:[self aboutText]];
    return [rtLabel optimumSize].height;
}

#pragma MFMailComposeViewControllerDelegate

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
}


@end
