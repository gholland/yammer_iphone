//
//  MessageTableCell.m
//  Yammer
//
//  Created by aa on 1/30/09.
//  Copyright 2009 Yammer, Inc. All rights reserved.
//

#import "MessageTableCell.h"
#import "MainTabBarController.h"

@interface MessageTableCell()
- (UILabel *)newLabelWithPrimaryColor:(UIColor *)primaryColor selectedColor:(UIColor *)selectedColor fontSize:(CGFloat)fontSize bold:(BOOL)bold;
@end

@implementation MessageTableCell

@synthesize fromLabel;
@synthesize previewLabel;
@synthesize timeLabel;
@synthesize length;
@synthesize paperclip_image;
@synthesize paperclip;
@synthesize lock_image;
@synthesize priv_lock;

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier {
  if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier]) {
    UIView *myContentView = self.contentView;
    self.fromLabel = [self newLabelWithPrimaryColor:[UIColor blackColor] selectedColor:[UIColor whiteColor] fontSize:12.0 bold:YES]; 
		self.fromLabel.textAlignment = UITextAlignmentLeft; // default
    
    self.previewLabel = [self newLabelWithPrimaryColor:[UIColor blackColor] selectedColor:[UIColor whiteColor] fontSize:12.0 bold:NO]; 
		self.previewLabel.textAlignment = UITextAlignmentLeft; // default
    [self.previewLabel setNumberOfLines:2];
    
    self.timeLabel = [self newLabelWithPrimaryColor:[UIColor blackColor] selectedColor:[UIColor whiteColor] fontSize:10.0 bold:NO]; 
		self.timeLabel.textAlignment = UITextAlignmentLeft; // default

    self.paperclip_image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"paperclip.png"]];
    self.lock_image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"lock.png"]];

		[myContentView addSubview:self.fromLabel];
		[myContentView addSubview:self.previewLabel];
		[myContentView addSubview:self.timeLabel];
    [myContentView addSubview:self.paperclip_image];
    [myContentView addSubview:self.lock_image];

		[self.fromLabel release];  
		[self.previewLabel release];  
		[self.timeLabel release];
		[self.paperclip_image release];
    [self.lock_image release];
  }
  
  return self;
}


//  if (group_name)
//    return [NSString stringWithFormat:@"%@ in %@", time, group_name];
//  return time;

- (void)setMessage:(NSMutableDictionary *)message {  
  self.contentView.backgroundColor = [UIColor whiteColor];
  previewLabel.backgroundColor = [UIColor whiteColor];
  fromLabel.backgroundColor = [UIColor whiteColor];
  timeLabel.backgroundColor = [UIColor whiteColor];
  
  NSMutableDictionary *body = [message objectForKey:@"body"];
  
  self.fromLabel.text = [message objectForKey:@"fromLine"];
  self.timeLabel.text = [message objectForKey:@"timeLine"];
  self.previewLabel.text = [body objectForKey:@"plain"];
  length = [self.previewLabel.text length];
  self.paperclip = false;
  if ([[message objectForKey:@"attachments"] count] > 0)
    self.paperclip = true;
  
  self.priv_lock = false;
  if ([message objectForKey:@"lock"])
    self.priv_lock = true;
  if ([message objectForKey:@"lockColor"]) {
    self.priv_lock = true;
    self.contentView.backgroundColor = [MainTabBarController privateGray];
    previewLabel.backgroundColor = [MainTabBarController privateGray];    
    fromLabel.backgroundColor = [MainTabBarController privateGray];  
    timeLabel.backgroundColor = [MainTabBarController privateGray];  
  }
  
  [self setNeedsDisplay];
}

- (void)layoutSubviews {
  
  [super layoutSubviews];
	
  CGRect frame;    
  frame = CGRectMake(65, 1, 230, 14);
  self.fromLabel.frame = frame;
  
  frame = CGRectMake(-20, -20, 6, 12);
  self.paperclip_image.frame = frame;
  self.lock_image.frame = frame;
  
  int preview_x = 65;
  int preview_width = 230;
  
  if (self.paperclip) {
    preview_x = 75;
    preview_width = 220;
    frame = CGRectMake(65, 18, 6, 12);
    self.paperclip_image.frame = frame;
  }
  
  if (self.priv_lock) {
    preview_x = 85;
    preview_width = 210;
    frame = CGRectMake(63, 16, 16, 16);
    self.lock_image.frame = frame;    
  }
  
  if (self.paperclip && self.priv_lock) {
    preview_x = 95;
    preview_width = 200;

    frame = CGRectMake(83, 19, 6, 12);
    self.paperclip_image.frame = frame;

    frame = CGRectMake(63, 16, 16, 16);
    self.lock_image.frame = frame;
  }
  
  if (length > 50) {
    frame = CGRectMake(preview_x, 15, preview_width, 30);
    self.previewLabel.frame = frame;    
    frame = CGRectMake(65, 45, 230, 14);
    self.timeLabel.frame = frame;
  }
  else {
    frame = CGRectMake(preview_x, 15, preview_width, 17);
    self.previewLabel.frame = frame;    
    frame = CGRectMake(65, 32, 230, 14);
    self.timeLabel.frame = frame;
  }
}
  
- (UILabel *)newLabelWithPrimaryColor:(UIColor *)primaryColor selectedColor:(UIColor *)selectedColor fontSize:(CGFloat)fontSize bold:(BOOL)bold {
  UIFont *font;
  if (bold) {
    font = [UIFont boldSystemFontOfSize:fontSize];
  } else {
    font = [UIFont systemFontOfSize:fontSize];
  }
  
	UILabel *newLabel = [[UILabel alloc] initWithFrame:CGRectZero];
	newLabel.backgroundColor = [UIColor whiteColor];
	newLabel.opaque = YES;
	newLabel.textColor = primaryColor;
	newLabel.highlightedTextColor = selectedColor;
	newLabel.font = font;
  newLabel.numberOfLines = 1;
	
	return newLabel;
}

- (void)dealloc {
  [fromLabel release];
  [previewLabel release];
  [timeLabel release];
  [paperclip_image release];
  [lock_image release];
  [super dealloc];
}

@end
