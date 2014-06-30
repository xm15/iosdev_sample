//
//  NextVC.h
//  ClassSample
//
//  Created by caigee on 14-6-29.
//  Copyright (c) 2014年 caigee. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol textSendDelegate;

@interface NextVC : UIViewController
{
    UITextField *_myTextField;
}
// 协议的实例
@property (nonatomic,assign)id<textSendDelegate> delegate;


@end


// 协议的声明
@protocol textSendDelegate <NSObject>

//一定要实现的
@required
-(void)textSend:(NSString *)textString;
//可选实现
@optional
-(void)logOfTextSend;

@end