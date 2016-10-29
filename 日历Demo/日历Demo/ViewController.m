//
//  ViewController.m
//  日历Demo
//
//  Created by 123 on 16/1/3.
//  Copyright © 2016年 xu wenhao. All rights reserved.
//

#import "ViewController.h"
#import "JDYcalenCell1.h"
#import "JDYcalenFlowLayout.h"
#import "JDYcalenReusableView.h"//网格head 高度为40

@interface ViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>
{
    NSDate *starDate;//入住时间
    NSDate *endDate;//离店时间
}

@property(nonatomic,strong)NSCalendar *calendar;//历法（暂时为一种 ：公历） 日历的范围为当前月份到次年当前月份(暂时)

@property(nonatomic,strong)NSDate *firstDate;
@property(nonatomic,strong)NSDate *lastDate;

@property (weak, nonatomic) IBOutlet UICollectionView *collV;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUI];
}
-(void)setUI{
    JDYcalenFlowLayout  *fl=[[JDYcalenFlowLayout alloc]init];
    self.edgesForExtendedLayout=UIRectEdgeNone;
    self.collV.backgroundColor=[UIColor whiteColor];
    self.collV.collectionViewLayout=fl;
    self.collV.delegate=self;
    self.collV.dataSource=self;
}
-(NSCalendar *)calendar{
    if (_calendar==nil) {
        _calendar=[NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    }
    return _calendar;
}
-(NSDate *)firstDate{
    if (_firstDate==nil) {
        _firstDate=[NSDate date];
    }
    return _firstDate;
}
-(NSDate *)lastDate{
    if (_lastDate==nil) {
        NSDateComponents *com=[NSDateComponents new];
        com.year=1;
        _lastDate=[self.calendar  dateByAddingComponents:com toDate:self.firstDate options:0];//默认增加一年
    }
    return _lastDate;
}


#pragma --mark collectionView delegate
//多少月
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
 return  [self.calendar components:NSCalendarUnitMonth fromDate:self.firstDate toDate:self.lastDate options:0].month+1;
}
//该月有几块
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSDateComponents *com=[NSDateComponents new];
    com.month=section;
    NSDate *secDate=[self.calendar dateByAddingComponents:com toDate:self.firstDate options:0];
    //判断有几周
    NSUInteger weeksCount=[self.calendar rangeOfUnit:NSCalendarUnitWeekOfMonth inUnit:NSCalendarUnitMonth forDate:secDate].length;
    return weeksCount*7;
}
//每一块的显示
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    JDYcalenCell1 *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"JDYcalenCell1" forIndexPath:indexPath];
    
    NSDate *moDate=[self secDateWithIndexPath:indexPath];
    NSDate *cellDate=[self cellDateWithIndexPath:indexPath];
    NSUInteger mNum=[self.calendar ordinalityOfUnit:NSCalendarUnitMonth inUnit:NSCalendarUnitYear forDate:moDate];
    NSUInteger cellNum=[self.calendar ordinalityOfUnit:NSCalendarUnitMonth inUnit:NSCalendarUnitYear forDate:cellDate];
    
    BOOL isSelece=NO;
    
    if ([cellDate compare:_firstDate]==NSOrderedSame ) {
        
        cell.layer.zPosition=100;
    }else{
        cell.layer.zPosition=0;
    }
    
    
    if (mNum==cellNum) {//如果一个月 显示
//       //什么情况下选择位yes
//        if (starDate!=nil) {
//            if (endDate!=nil) {
//                if ([cellDate compare:starDate]!=NSOrderedAscending&&[cellDate compare:endDate]!=NSOrderedDescending) {
//                    isSelece=YES;
//                }
//            }else{
//                if ([cellDate compare:starDate]==NSOrderedSame) {
//                    isSelece=YES;
//                }
//            }
//        }
        [cell setDate:cellDate andWithSelecte:isSelece];
    }
    else{
    cell.date_lb.text=@"";
    }

    return cell;
}
//每个cell对应的日期
-(NSDate *)cellDateWithIndexPath:(NSIndexPath *)indexpath{
    NSDate *moDate=[self secDateWithIndexPath:indexpath];//该月对应的firstday
    //在该月第几周的第几天
    NSUInteger wNum=[self.calendar ordinalityOfUnit:NSCalendarUnitWeekOfMonth inUnit:NSCalendarUnitMonth forDate:moDate];//第几周
    
    NSUInteger dNum=[self.calendar ordinalityOfUnit:NSCalendarUnitWeekday inUnit:NSCalendarUnitWeekOfMonth forDate:moDate];//周几
    NSUInteger moCount=(wNum-1)*7+dNum;
    NSDateComponents *com=[NSDateComponents new];
    com.day=1+indexpath.item-moCount;
    return [self.calendar dateByAddingComponents:com toDate:moDate options:0];
}



//每个secion的月对应的first日期
-(NSDate *)secDateWithIndexPath:(NSIndexPath *)indexpath{
    NSDateComponents *com=[NSDateComponents new];
    com.month=indexpath.section;
    return [self.calendar dateByAddingComponents:com toDate:self.firstDate options:0];
}


-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if (kind == UICollectionElementKindSectionHeader) {
        JDYcalenReusableView *headV=[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"JDYcalenReusableView" forIndexPath:indexPath];
        //年月
        NSInteger secNum=indexPath.section;
        NSDateComponents *com=[NSDateComponents new];
        com.month=secNum;

        NSDate *secDate=[self.calendar dateByAddingComponents:com toDate:self.firstDate options:0];
        NSDateFormatter *form=[NSDateFormatter new];
        form.dateFormat=@"yyyy年MM月";
        headV.date_lb.text=[form stringFromDate:secDate];
        
        return headV;
        
    }
        return nil;
}

////该块是否允许选择
//-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath{
//    NSDate *moDate=[self secDateWithIndexPath:indexPath];
//    NSDate *cellDate=[self cellDateWithIndexPath:indexPath];
//    NSUInteger mNum=[self.calendar ordinalityOfUnit:NSCalendarUnitMonth inUnit:NSCalendarUnitYear forDate:moDate];
//    NSUInteger cellNum=[self.calendar ordinalityOfUnit:NSCalendarUnitMonth inUnit:NSCalendarUnitYear forDate:cellDate];
//    
//    //不显示的返回NO 当前日期以前的也返回NO
//    if (mNum==cellNum) {
//        if ([cellDate compare:[NSDate date]]==NSOrderedAscending) {
//            return NO;
//        }
//        return YES;
//    }else
//        return NO;
//
//}

//-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
//    NSDate *seleDate=[self cellDateWithIndexPath:indexPath];//选中的日期
//    
//    NSUInteger minSec=0;//最小的sec
//    NSUInteger maxSec=0;//最大的sec
//    
//    //两种情况下重新设置入住时间，  一种是都没有设置 另一种是都已经设置了但是重新选择了
//    if (starDate==nil|endDate!=nil) {
//      
//        starDate=seleDate;
//        endDate=nil;
//        
//    }
//    //走到这里说明有出行时间
//    if (starDate!=nil&&endDate==nil) {
//        if ([seleDate compare:starDate]==NSOrderedAscending) {//选择的时间在前
//            endDate=starDate;
//            starDate=seleDate;
//        }
//        else if([seleDate compare:starDate]==NSOrderedDescending){
//            endDate=seleDate;
//        }
//   
//    }
//    
//    
//    
//    
//     [collectionView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section]];
//}








- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
