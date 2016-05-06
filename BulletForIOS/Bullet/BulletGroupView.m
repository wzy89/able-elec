//
//  BulletGroupView.m
//  BulletForIOS
//
//  Created by 王朝阳 on 16/4/27.
//  Copyright © 2016年 Risun. All rights reserved.
//

#import "BulletGroupView.h"

#define PROLOADNUM 15

@interface BulletGroupView ()
{
    BulletSettingDic *_bulletDic;
    
    NSInteger _trajectoryNum;   //轨道数
    CGFloat _trajectoryHeight;  //轨道高度
}
@property (nonatomic, strong) NSMutableArray *trajectoryNumArray;   //这是一个辅助数组，辅助产生随机行（轨迹）数

@property (nonatomic, strong) NSMutableArray *wholeDataArray;       //待加载的data

@property (nonatomic, strong) NSMutableArray *tmpLoadDataArray;     //加载中的data

@property (nonatomic, strong) NSMutableArray *bulletArray;              //buttletView数组

@property (nonatomic, strong) NSMutableArray *reuseableBulletArray;     //可重用的buttletView数组

@property BOOL isStopped;

@end

@implementation BulletGroupView

#pragma mark - Private

#pragma mark 做视图
//做 辅助产生随机行数的 数组
-(void)makeTrajectoryNumArray
{
    if (_trajectoryNumArray.count > 0) return;
    for (int i = 0; i<_trajectoryNum; i++)
    {
        [_trajectoryNumArray addObject:[NSString stringWithFormat:@"%i",i]];
    }
}
//加载弹幕视图，每行一个，随机出现在某一行
-(void)loadButtetView
{
    [self makeTrajectoryNumArray];
    int j = (int) _trajectoryNumArray.count;
    for (int i = j; i > 0; i--)
    {
        NSString *comment = [_tmpLoadDataArray firstObject];
        if (comment)
        {
            [_tmpLoadDataArray removeObjectAtIndex:0];
            //随机生成弹道创建弹幕进行展示（弹幕的随机飞入效果）
            NSInteger index = arc4random()%_trajectoryNumArray.count;
            int trajectory = [[_trajectoryNumArray objectAtIndex:index] intValue];
            [_trajectoryNumArray removeObjectAtIndex:index];
            [self createBulletView:comment trajectory:trajectory];
        }
        else
        {
            //没有评论时
            break;
        }
    }
}

- (void)createBulletView:(NSString *)comment trajectory:(int)trajectory
{
    if (self.isStopped)return;
    
    //创建BulletView，如果有移除来的，那么重用；
    BulletView *view;
    [_bulletDic setbulletText:comment];
    if (_reuseableBulletArray.count)
    {
        view = [_reuseableBulletArray firstObject];
        [view reloadDataWithDic:_bulletDic];
        [_reuseableBulletArray removeObjectAtIndex:0];
    }else
    {
        view = [[BulletView alloc] initWithCommentDic:_bulletDic];
    }
    view.trajectory = trajectory;
    [_bulletArray addObject:view];
    
    __unsafe_unretained BulletView *weakBulletView = view;
    __unsafe_unretained BulletGroupView *weakSelf = self;
    
    view.moveBlock = ^(CommentMoveStatus status)
    {
        if (weakSelf.isStopped) return;
        switch (status) {
            case MoveIn:
                //弹幕开始进入
                break;
            case Enter: {
                //弹幕完全进入屏幕，判断接下来是否还有内容，如果有则在该弹道轨迹对列中创建弹幕
                NSString *comment = [weakSelf nextComment];
                if (comment)
                {
                    [weakSelf createBulletView:comment trajectory:trajectory];
                } else
                {
                    //此时还有没完全走出去的,那么没走出去一条，就重新看一遍有没有新来的，如果有就加进去一条
                    [weakSelf getMoreComment];
                    NSString *moreComment = [weakSelf nextComment];
                    if (moreComment)
                    {
                        [weakSelf createBulletView:moreComment trajectory:trajectory];
                    }else
                    {
                        //可用的没了，要保存下顺序数组
                        [_trajectoryNumArray addObject:[NSString stringWithFormat:@"%i",trajectory]];
                    }
                }
                break;
            }
            case MoveOut:
            {
                //弹幕飞出屏幕后从弹幕管理数组中删除，加入到reuseable数组中
                if ([weakSelf.bulletArray containsObject:weakBulletView])
                {
                    [weakSelf.bulletArray removeObject:weakBulletView];
                    [weakSelf.reuseableBulletArray addObject:weakBulletView];
                    //NSLog(@"_bulletArray--%lu",(unsigned long)_bulletArray.count);
                    //NSLog(@"_reuseableBulletArray--%lu",(unsigned long)_reuseableBulletArray.count);
                }
                break;
            }
            default:
                break;
        }
    };
    //弹幕生成后，加到视图上
    view.frame = CGRectMake(CGRectGetWidth(self.frame)+CGRectGetWidth(view.bounds), 34 * view.trajectory, CGRectGetWidth(view.bounds), CGRectGetHeight(view.bounds));
    [self addSubview:view];
    [view startAnimation];
}
#pragma mark 数组操作－缓冲加载评论
- (NSString *)nextComment
{
    NSString *comment = [_tmpLoadDataArray firstObject];
    if (comment)
    {
        [_tmpLoadDataArray removeObjectAtIndex:0];
    }
    return comment;
}
-(void)getMoreComment
{
    if ([_wholeDataArray firstObject])
    {
        NSArray *array;
        if (_wholeDataArray.count<=PROLOADNUM)
        {
            array = [NSArray arrayWithArray:_wholeDataArray];
            [_wholeDataArray removeAllObjects];
        }
        else
        {
            array = [_wholeDataArray subarrayWithRange:NSMakeRange(0, 20)];
            [_wholeDataArray removeObjectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 20)]];
        }
        [_tmpLoadDataArray addObjectsFromArray:array];
    }
}

-(void)setDataSource:(NSArray<NSString *> *)dataSource
{
    if (_dataSource.count >0)
    {
        NSLog(@"您已经设置过datasource了！");
        return;
    }else
    {
        _dataSource = dataSource;
        [_wholeDataArray addObjectsFromArray:dataSource];
    }
}
#pragma mark - Public

//这个字典中设置弹幕的字体和颜色，具体哪些键，请参看BulletView.h中的键定义。
-(instancetype)initWithOriginY:(CGFloat)originY trajectoryHeight:(CGFloat)traHeight trajectoryNum:(NSInteger)traNum
{
    self = [super initWithFrame:CGRectMake(0, originY, [UIScreen mainScreen].bounds.size.width, traHeight*traNum)];
    if (self)
    {
        if (traNum>0)
        {
            _trajectoryNum = traNum;
            _trajectoryHeight = traHeight;
            _dataSource = [[NSArray alloc] init];
            _wholeDataArray = [[NSMutableArray alloc] initWithCapacity:PROLOADNUM];
            _tmpLoadDataArray = [[NSMutableArray alloc] initWithCapacity:PROLOADNUM];
            _trajectoryNumArray = [[NSMutableArray alloc] initWithCapacity:traNum];
            _bulletArray = [[NSMutableArray alloc] initWithCapacity:traNum];
            _reuseableBulletArray = [[NSMutableArray alloc] initWithCapacity:traNum];
        }
    }
    return self;
}

//这个字典中设置弹幕的字体和颜色，具体哪些键，请参看BulletView.h中的键定义。
-(void)setBulletDic:(BulletSettingDic *)bulletDic
{
    _bulletDic = bulletDic;
}

//在数据源中添加数据,在原数据源数据取完后，会继续获取这里的数据显示。
-(void)addObjectsToDataSource:(NSArray <NSString *>*)arrayToAdd
{
    if ([arrayToAdd firstObject])
    {
        [_wholeDataArray addObjectsFromArray:arrayToAdd];
        if (_trajectoryNumArray.count)
        {
            [self getMoreComment];
            [self loadButtetView];
        }
    }
}

//开始显示弹幕
-(void)startBullet
{
    if (self.tmpLoadDataArray.count == 0)[self getMoreComment];
    self.isStopped = NO;
    [self loadButtetView];
}

//停止显示弹幕
-(void)stopBullet
{
    self.isStopped = YES;
    
    [self.reuseableBulletArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
     {
         BulletView *view = obj;
         [view removeFromSuperview];
         view = nil;
     }];
    
    [self.bulletArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
    {
        BulletView *view = obj;
        [view removeFromSuperview];
        view = nil;
    }];
    
    [_wholeDataArray removeAllObjects];
    [_tmpLoadDataArray removeAllObjects];
    [_trajectoryNumArray removeAllObjects];
    
    _dataSource = nil;
}

- (void)pauseBullet
{
    [self.bulletArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
     {
         BulletView *view = obj;
         [view pauseAnimation];
     }];
}
-(void)resumeBullet
{
    [self.bulletArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
     {
         BulletView *view = obj;
         [view resumeAnimation];
     }];
}

@end
