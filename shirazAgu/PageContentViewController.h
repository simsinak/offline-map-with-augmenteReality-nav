//
//  PageContentViewController.h
//  Unity-iPhone
//
//  Created by sina askarnejad on 4/29/14.
//
//

#import <UIKit/UIKit.h>

@interface PageContentViewController : UIViewController 
@property (retain, nonatomic) IBOutlet UIImageView *contentImage;
@property (retain, nonatomic) IBOutlet UILabel *contentLabel;
@property NSUInteger contentIndex;
@property (nonatomic , strong) NSString *text;
@property (nonatomic , strong)NSString *fileName;
@property (retain, nonatomic) IBOutlet UIPageControl *testcontroler;
@end
