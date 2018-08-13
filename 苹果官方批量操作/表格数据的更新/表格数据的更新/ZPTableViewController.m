//
//  ZPTableViewController.m
//  用storyboard自定义等高的cell
//
//  Created by apple on 16/5/18.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "ZPTableViewController.h"
#import "ZPDeal.h"
#import "ZPTableViewCell.h"

@interface ZPTableViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray *deals;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ZPTableViewController

#pragma mark ————— 懒加载 —————
-(NSMutableArray *)deals
{
    if (_deals == nil)
    {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"deals" ofType:@"plist"];
        NSArray *dicArray = [NSArray arrayWithContentsOfFile:path];
        
        NSMutableArray *tempArray = [NSMutableArray array];
        for (NSDictionary *dic in dicArray)
        {
            ZPDeal *deal = [ZPDeal dealWithDict:dic];
            [tempArray addObject:deal];
        }
        
        _deals = tempArray;
    }
    
    return _deals;
}

#pragma mark ————— 生命周期 —————
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //允许在编辑模式下进行批量操作
    self.tableView.allowsMultipleSelectionDuringEditing = YES;
}

#pragma mark ————— 点击“批量”按钮 —————
- (IBAction)batchOperation:(id)sender
{
    [self.tableView setEditing:!self.tableView.isEditing animated:YES];
}

#pragma mark ————— 点击“删除”按钮 —————
- (IBAction)remove:(id)sender
{
    //获得所有被选中的行
    NSArray *selectedIndexPathsArray = [self.tableView indexPathsForSelectedRows];
    
    NSMutableArray *deleteDeals = [NSMutableArray array];
    for (NSIndexPath *selectedIndexPath in selectedIndexPathsArray)
    {
        [deleteDeals addObject:[self.deals objectAtIndex:selectedIndexPath.row]];
    }
    
    [self.deals removeObjectsInArray:deleteDeals];
    
    [self.tableView reloadData];
}

#pragma mark ————— UITableViewDataSource —————
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.deals.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZPTableViewCell *cell = [ZPTableViewCell cellWithTableView:tableView];
    
    cell.deal = [self.deals objectAtIndex:indexPath.row];
    
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
