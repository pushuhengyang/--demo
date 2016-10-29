//
//  JDYcalenCell1.h
//  日历Demo
//
//  Created by 123 on 16/1/4.
//  Copyright © 2016年 xu wenhao. All rights reserved.
//cell有几种状态 选择 与正常 

#import <UIKit/UIKit.h>
@interface JDYcalenCell1 : UICollectionViewCell



@property (weak, nonatomic) IBOutlet UILabel *detal_lb;//特殊解释

@property (weak, nonatomic) IBOutlet UILabel *sub_lb;//入住离店等



@property (weak, nonatomic) IBOutlet UILabel *date_lb;//日期 节日等

@property(strong,nonatomic) NSDate *date;


-(void)setDate:(NSDate *)date andWithSelecte:(BOOL)isSelect;

@end
