//
//  PageContentViewController.m
//  Unity-iPhone
//
//  Created by sina askarnejad on 4/29/14.
//
//

#import "PageContentViewController.h"

@interface PageContentViewController ()

@end

@implementation PageContentViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [_contentLabel setText:_text];
    [_contentImage setImage:[UIImage imageNamed:_fileName]];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_contentImage release];
    [_contentLabel release];
    [_testcontroler release];
    [super dealloc];
}
@end
