//
//  JDYcalenFlowLayout.m
//  日历Demo
//
//  Created by 123 on 16/1/4.
//  Copyright © 2016年 xu wenhao. All rights reserved.
//

#import "JDYcalenFlowLayout.h"

#define  SW [UIScreen mainScreen].bounds.size.width
#define LINSPACE 0.f
#define ITEMSPACE 0.f
#define HEADSPACE 40.f
#define ITEMSH 30.f
@interface JDYcalenFlowLayout ()
{
    CGFloat _viewHight;
    
}


@end

@implementation JDYcalenFlowLayout

-(instancetype)init{
    if (self=[super init]) {
        self.scrollDirection=UICollectionViewScrollDirectionVertical;
        self.minimumInteritemSpacing=ITEMSPACE;
        self.minimumLineSpacing=LINSPACE;
        self.headerReferenceSize=CGSizeMake(SW, HEADSPACE);
        self.itemSize=CGSizeMake((SW-1)/7, (SW-1)/7);
        
    }
    return self;
}












@end
