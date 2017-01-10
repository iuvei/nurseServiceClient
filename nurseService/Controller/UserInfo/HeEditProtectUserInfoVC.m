//
//  HeProtectedUserInfoVC.m
//  nurseService
//
//  Created by Tony on 2017/1/10.
//  Copyright © 2017年 iMac. All rights reserved.
//

#import "HeEditProtectUserInfoVC.h"
#import "HeProtectUserInfoTableCell.h"
#import "HeEditProtectUserInfoVC.h"
#import "HeBaseTableViewCell.h"
#import "FTPopOverMenu.h"
#import "HeSelectProtectUserAddressVC.h"

@interface HeEditProtectUserInfoVC ()<UITextFieldDelegate,UIActionSheetDelegate>
{
    //用户性别 男 1 女 2
    ENUM_SEXType userSex;
}
@property(strong,nonatomic)IBOutlet UITableView *tableview;
@property(strong,nonatomic)NSArray *dataSource;

@end

@implementation HeEditProtectUserInfoVC
@synthesize tableview;
@synthesize dataSource;
@synthesize userInfoDict;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.backgroundColor = [UIColor clearColor];
        label.font = APPDEFAULTTITLETEXTFONT;
        label.textColor = APPDEFAULTTITLECOLOR;
        label.textAlignment = NSTextAlignmentCenter;
        self.navigationItem.titleView = label;
        label.text = @"编辑信息";
        [label sizeToFit];
        self.title = @"编辑信息";
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initializaiton];
    [self initView];
}

- (void)initializaiton
{
    [super initializaiton];
    [Tool setExtraCellLineHidden:tableview];
    tableview.backgroundView = nil;
    tableview.backgroundColor = APPDEFAULTTABLEBACKGROUNDCOLOR;
    
    dataSource = @[@"姓名",@"性别",@"身份证号",@"年龄",@"联系电话",@"关系",@"地址",@"病史备注"];
    
    
}

- (void)initView
{
    [super initView];
    tableview.backgroundView = nil;
    tableview.backgroundColor = [UIColor colorWithWhite:237.0 /255.0 alpha:1.0];
    [Tool setExtraCellLineHidden:tableview];
    
    tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 50)];
    tableview.tableFooterView = footerView;
    tableview.showsVerticalScrollIndicator = NO;
    tableview.showsHorizontalScrollIndicator = NO;
    UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, SCREENWIDTH - 20, 30)];
    tipLabel.font = [UIFont systemFontOfSize:13.0];
    tipLabel.textColor = [UIColor grayColor];
    tipLabel.text = @"例：青霉素过敏、咽喉炎、长期感冒低热、肥胖";
    tipLabel.backgroundColor = [UIColor clearColor];
    [footerView addSubview:tipLabel];
}


- (IBAction)saveProtectUserInfo:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kAddProtectedUserInfoNotification object:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([textField isFocused]) {
        [textField resignFirstResponder];
    }
    return YES;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [dataSource count];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    
    static NSString *cellIndentifier = @"HeUserCellIndentifier";
    CGSize cellSize = [tableView rectForRowAtIndexPath:indexPath].size;
    
    
    HeBaseTableViewCell *cell  = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell = [[HeBaseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    UIFont *textFont = [UIFont systemFontOfSize:15.0];
    NSString *title = dataSource[row];
    
    CGFloat titleX = 10;
    CGFloat titleY = 0;
    CGFloat titleH = cellSize.height;
    if (row == [dataSource count] - 1) {
        titleH = 30;
    }
    CGFloat titleW = 80;
    UILabel *topicLabel = [[UILabel alloc] init];
    topicLabel.textAlignment = NSTextAlignmentLeft;
    topicLabel.backgroundColor = [UIColor clearColor];
    topicLabel.text = [NSString stringWithFormat:@"%@",title];
    topicLabel.numberOfLines = 0;
    topicLabel.textColor = [UIColor blackColor];
    topicLabel.font = textFont;
    topicLabel.frame = CGRectMake(titleX, titleY, titleW, titleH);
    [cell.contentView addSubview:topicLabel];
    
    textFont = [UIFont systemFontOfSize:16.0];
    
    CGFloat contentFieldY = 0;
    CGFloat contentFieldW = 150;
    CGFloat contentFieldH = cellSize.height;
    CGFloat contentFieldX = SCREENWIDTH - contentFieldW - 15;
    
    UITextField *contentField = [[UITextField alloc] initWithFrame:CGRectMake(contentFieldX, contentFieldY, contentFieldW, contentFieldH)];
    contentField.delegate = self;
    contentField.font = textFont;
    contentField.textAlignment = NSTextAlignmentRight;
    
    NSString *placeholder = @"";
    UIFont *contentFont = [UIFont systemFontOfSize:16.0];
    switch (row) {
        case 0:
        {
            //姓名
            placeholder = @"受保护人姓名";
            break;
        }
        case 1:
        {
            //性别
            CGFloat contentLabelX = 90;
            CGFloat contentLabelW = SCREENWIDTH - contentLabelX - 10;
            CGFloat contentLabelY = 0;
            CGFloat contentLabelH = cellSize.height;
            
            UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(contentLabelX, contentLabelY, contentLabelW, contentLabelH)];
            contentLabel.textAlignment = NSTextAlignmentRight;
            contentLabel.textColor = [UIColor blackColor];
            contentLabel.font = contentFont;
            [cell addSubview:contentLabel];
            if (userSex == ENUM_SEX_Boy) {
                contentLabel.text = @"男";
            }
            else{
                contentLabel.text = @"女";
            }
            
            contentField.hidden = YES;
            
            break;
        }
        case 2:
        {
            //身份证号
            placeholder = @"请输入身份证号";
            break;
        }
        case 3:
        {
            //年龄
            placeholder = @"请输入年龄";
            break;
        }
        case 4:
        {
            //联系电话
            placeholder = @"请输入联系电话";
            break;
        }
        case 5:
        {
            //关系
            CGFloat contentLabelX = 90;
            CGFloat contentLabelW = SCREENWIDTH - contentLabelX - 10;
            CGFloat contentLabelY = 0;
            CGFloat contentLabelH = cellSize.height;
            
            UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(contentLabelX, contentLabelY, contentLabelW, contentLabelH)];
            contentLabel.textAlignment = NSTextAlignmentRight;
            contentLabel.textColor = [UIColor blackColor];
            contentLabel.font = contentFont;
            contentLabel.text = @"自己";
            [cell addSubview:contentLabel];
            
            contentField.hidden = YES;
            break;
        }
        case 6:
        {
            //地址
            CGFloat contentLabelX = 90;
            CGFloat contentLabelW = SCREENWIDTH - contentLabelX - 10;
            CGFloat contentLabelY = 0;
            CGFloat contentLabelH = cellSize.height;
            
            UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(contentLabelX, contentLabelY, contentLabelW, contentLabelH)];
            contentLabel.textAlignment = NSTextAlignmentRight;
            contentLabel.textColor = [UIColor blackColor];
            contentLabel.font = contentFont;
            contentLabel.text = @"广东省中山市西区";
            [cell addSubview:contentLabel];
            
            contentField.hidden = YES;
            break;
        }
        case 7:
        {
            //病史备注
            placeholder = @"请输入备注信息";
            contentFieldX = 10;
            contentFieldW = SCREENWIDTH - 2 * contentFieldX;
            contentField.frame = CGRectMake(contentFieldX, contentFieldY, contentFieldW, contentFieldH);
            contentField.textAlignment = NSTextAlignmentLeft;
            
            break;
        }
            
        default:
            break;
    }
    contentField.placeholder = placeholder;
    [cell addSubview:contentField];
    
    return cell;
}

- (void)selectRelation:(id)sender
{
    NSArray *menuArray = @[@"父亲",@"母亲",@"妻子",@"自己",@"丈夫"];
    [FTPopOverMenu showForSender:sender
                        withMenu:menuArray
                  imageNameArray:nil
                       doneBlock:^(NSInteger selectedIndex) {
                           NSString *relation = menuArray[selectedIndex];
                           NSLog(@"relation = %@",relation);
                           
                       } dismissBlock:^{
                           
                           NSLog(@"user canceled. do nothing.");
                           
                       }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if (row == [dataSource count] - 1) {
        return 100;
    }
    return 50;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    HeBaseTableViewCell *cell  = [tableView cellForRowAtIndexPath:indexPath];
    switch (row) {
        case 1:{
            UIActionSheet *actionsheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"男",@"女", nil];
            actionsheet.tag = 100;
            [actionsheet showInView:cell];
            break;
        }
        case 5:
        {
            //选择关系
            [self selectRelation:cell];
            break;
        }
        case 6:{
            //选择地址
            HeSelectProtectUserAddressVC *selectAddressVC = [[HeSelectProtectUserAddressVC alloc] init];
            selectAddressVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:selectAddressVC animated:YES];
            break;
        }
        default:
            break;
    }
    NSLog(@"row = %ld , section = %ld",row,section);
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 100) {
        userSex = buttonIndex + 1;
        NSLog(@"userSex = %ld",buttonIndex);
        [tableview reloadData];
    }
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
