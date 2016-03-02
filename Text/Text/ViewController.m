//
//  ViewController.m
//  Text
//
//  Created by MS on 16-1-21.
//  Copyright (c) 2016年 MS. All rights reserved.
//

#import "ViewController.h"
#import "QFRequestManager.h"
#import "ZLScrollView.h"



#define REQURL @"http://tubu.ibuzhai.com/rest/v3/advertisements?&position=%2C1&object_type=&app_version=4.2.0&api_version=1&device_type=2&destination=0"


@interface ViewController ()<UITableViewDelegate,UITableViewDataSource,ZLScrollViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate>{

    UITableView *_tableView;
    
    NSMutableArray *_dataArray;
    
    NSMutableArray *_array;
    
    NSMutableArray *_scenodArray;
 
    ZLScrollView *_scrollView;
    
    UICollectionView *_collectionView;
    
    UICollectionViewFlowLayout *_layout;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self creatData];
    
    [self creatTableView];
    
    [self creatScrollView];
    
    [self creatCollectionView];
}

-(void)creatCollectionView{

    _layout = [[UICollectionViewFlowLayout alloc]init];
    
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 180, self.view.frame.size.width, 100*2) collectionViewLayout:_layout];
    
    _collectionView.delegate = self;
    
    _collectionView.dataSource = self;
    
    _collectionView.backgroundColor = [UIColor whiteColor];
    
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"ID"];
    
    [_tableView addSubview:_collectionView];
    
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{

    return _scenodArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{

    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ID" forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor whiteColor];
    
    NSArray *array = @[@"全部",@"周末",@"长线",@"摄影",@"入门",@"进阶",@"露营",@"亲子"];
    
    CGFloat xSpace = (self.view.frame.size.width-4*80)/5;
    
    for (int i=0; i<4; i++) {
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        
        button.frame = CGRectMake(xSpace+i*(xSpace+80), 0, 80, 80);
        
        [button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"fenlei%d",i+1]] forState:UIControlStateNormal];
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(15, 60, 50, 50)];
        
        label.text = array[i];
        
        label.textAlignment = NSTextAlignmentCenter;
        
        label.font = [UIFont boldSystemFontOfSize:15];
        
        [button addSubview:label];
        
        [cell addSubview:button];
    }
    
    return cell;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake(86, 100);
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    
    return 1;
}



-(void)creatScrollView{


 
    _dataArray = [[NSMutableArray alloc]init];
    
    [QFRequestManager requestWithUrl:REQURL IsCache:YES FinishBlock:^(NSData *data) {
        
        NSDictionary *rootDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        
        NSArray *array = [rootDic objectForKey:@"advertisements"];
        
        for (NSDictionary *dic in array) {
            
            NSString *string = [dic objectForKey:@"share_pic"];
            
            [_dataArray addObject:string];
        }
        
        _scrollView = [[ZLScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 180)];
        
        [_scrollView addImageArrayWithArray:_dataArray IsFromWeb:YES PlaceHolderImage:nil];
        
        _scrollView.delegate = self;
        
        _tableView.tableHeaderView = _scrollView;
        
        [self performSelectorOnMainThread:@selector(backMain) withObject:nil waitUntilDone:YES];
        
    } FailedBlock:^(NSError *error) {
        
        
    }];
    



}

-(void)backMain{
    
    [_tableView reloadData];
}


-(void)clickImageTag:(NSInteger)tag{

    
}

-(void)creatData{
    
    _array = [[NSMutableArray alloc]init];
    
    for (int i=0; i<10; i++) {
        
        NSString *string = [NSString stringWithFormat:@"第%d行",i];
        
        [_array addObject:string];
    }
    
    _scenodArray = [[NSMutableArray alloc]init];
    
    for (int i=0; i<8; i++) {
        
        NSString *string = [NSString stringWithFormat:@"第%d个Item",i];
        
        [_scenodArray addObject:string];
    }
}



-(void)creatTableView{

    _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    
    _tableView.delegate = self;
    
    _tableView.dataSource = self;
    
    [self.view addSubview:_tableView];
    

}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    if (section == 0) {
        
        return 1;
        
    }else if (section == 1){
    
        return _dataArray.count;
    }
    return _dataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{

    return 20;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"id"];
    
    if (!cell) {
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"id"];
    }
    
    cell.textLabel.text = _array[indexPath.row];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 100*2;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
